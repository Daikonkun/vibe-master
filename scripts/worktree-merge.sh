#!/bin/bash
# Merge a feature branch, clean worktree, and update manifests

set -euo pipefail

BRANCH="${1:-}"
BASE_BRANCH="${2:-main}"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REQ_MANIFEST="$PROJECT_ROOT/.requirement-manifest.json"
WORKTREE_MANIFEST="$PROJECT_ROOT/.worktree-manifest.json"
source "$PROJECT_ROOT/scripts/_manifest-lock.sh"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
STASHED=false

if [ -z "$BRANCH" ]; then
  echo "Usage: $0 <branch> [base-branch]" >&2
  exit 1
fi

if [ ! -f "$REQ_MANIFEST" ] || [ ! -f "$WORKTREE_MANIFEST" ]; then
  echo "Error: requirement/worktree manifest missing" >&2
  exit 1
fi

DIRTY_FILES="$(git -C "$PROJECT_ROOT" status --porcelain)"
if [ -n "$DIRTY_FILES" ]; then
  echo "⚠️  Working tree is not clean. Reviewing changes..."

  # Auto-commit manifest and docs changes (these are auto-generated)
  AUTO_COMMIT_FILES="$(echo "$DIRTY_FILES" | grep -E '^\s*[MADRC]\s+.*\.(json|md)$' | grep -E '(requirement-manifest|worktree-manifest|REQUIREMENTS|STATUS|ROADMAP|DEPENDENCIES|docs/requirements/)' || true)"
  if [ -n "$AUTO_COMMIT_FILES" ]; then
    echo "Auto-committing manifest/docs changes:"
    echo "$AUTO_COMMIT_FILES" | sed 's/^/  /'
    git -C "$PROJECT_ROOT" add -A
    git -C "$PROJECT_ROOT" commit -m "chore: auto-commit manifest and docs before merge" --no-verify 2>/dev/null || true
  fi

  # Check if there are still dirty files after auto-commit
  REMAINING_DIRTY="$(git -C "$PROJECT_ROOT" status --porcelain)"
  if [ -n "$REMAINING_DIRTY" ]; then
    echo "Stashing remaining uncommitted changes:"
    echo "$REMAINING_DIRTY" | sed 's/^/  /'
    git -C "$PROJECT_ROOT" stash push -m "auto-stash before merge of $BRANCH" --include-untracked
    STASHED=true
  fi
fi

if ! git -C "$PROJECT_ROOT" rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
  echo "Error: Base branch not found locally: $BASE_BRANCH" >&2
  exit 1
fi

if ! git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Error: Feature branch not found locally: $BRANCH" >&2
  exit 1
fi

WORKTREE_PATH="$(jq -r --arg branch "$BRANCH" '
  .worktrees[]? | select(.branch == $branch or .id == $branch) | .path
' "$WORKTREE_MANIFEST" | head -1)"
REQ_IDS="$(jq -r --arg branch "$BRANCH" '
  .worktrees[]? | select(.branch == $branch or .id == $branch) | .requirementIds[]
' "$WORKTREE_MANIFEST")"

echo "Merging $BRANCH into $BASE_BRANCH..."
git -C "$PROJECT_ROOT" checkout "$BASE_BRANCH"
git -C "$PROJECT_ROOT" merge --no-ff "$BRANCH" -m "Merge $BRANCH"

if [ -n "$WORKTREE_PATH" ] && [ -d "$WORKTREE_PATH" ]; then
  git -C "$PROJECT_ROOT" worktree remove "$WORKTREE_PATH"
fi

git -C "$PROJECT_ROOT" branch -d "$BRANCH"

jq_update_manifest_locked "$WORKTREE_MANIFEST" \
  '.worktrees |= map(
    if .branch == $branch or .id == $branch
    then .status = "MERGED" | .mergedAt = $ts
    else .
    end
  )' \
  --arg branch "$BRANCH" \
  --arg ts "$TIMESTAMP"

# Determine target status based on requiresDeployment flag
REQUIRES_DEPLOYMENT="$(jq -r '.requiresDeployment // true' "$REQ_MANIFEST")"
if [ "$REQUIRES_DEPLOYMENT" = "false" ]; then
  REQ_TARGET_STATUS="DEPLOYED"
else
  REQ_TARGET_STATUS="MERGED"
fi

if [ -n "$REQ_IDS" ]; then
  while IFS= read -r reqId; do
    [ -z "$reqId" ] && continue
    # Warn if requirement is not in an expected pre-merge state
    CURRENT_REQ_STATUS="$(jq -r --arg reqId "$reqId" '.requirements[] | select(.id == $reqId) | .status' "$REQ_MANIFEST")"
    if [ "$CURRENT_REQ_STATUS" != "CODE_REVIEW" ] && [ "$CURRENT_REQ_STATUS" != "MERGED" ]; then
      echo "⚠️  Warning: $reqId is in $CURRENT_REQ_STATUS (expected CODE_REVIEW). Proceeding anyway."
    fi
    if [ "$REQ_TARGET_STATUS" = "DEPLOYED" ]; then
      jq_update_manifest_locked "$REQ_MANIFEST" \
        '.requirements |= map(
          if .id == $reqId
          then .status = "DEPLOYED" | .updatedAt = $ts | .deployedAt = $ts
          else .
          end
        )' \
        --arg reqId "$reqId" \
        --arg ts "$TIMESTAMP"
    else
      jq_update_manifest_locked "$REQ_MANIFEST" \
        '.requirements |= map(
          if .id == $reqId
          then .status = "MERGED" | .updatedAt = $ts
          else .
          end
        )' \
        --arg reqId "$reqId" \
        --arg ts "$TIMESTAMP"
    fi
  done <<< "$REQ_IDS"
fi

"$PROJECT_ROOT/scripts/regenerate-docs.sh" >/dev/null

git -C "$PROJECT_ROOT" add \
  .requirement-manifest.json \
  .worktree-manifest.json \
  REQUIREMENTS.md \
  docs/STATUS.md \
  docs/ROADMAP.md \
  docs/DEPENDENCIES.md \
  docs/requirements/ 2>/dev/null || true

git -C "$PROJECT_ROOT" commit -m "chore: update manifests and docs after merging $BRANCH" --no-verify 2>/dev/null || true

echo "✅ Merged $BRANCH"
if [ -n "$WORKTREE_PATH" ]; then
  echo "Removed worktree: $WORKTREE_PATH"
fi
if [ -n "$REQ_IDS" ]; then
  echo "Updated requirements to $REQ_TARGET_STATUS: $(echo "$REQ_IDS" | tr '\n' ' ' | xargs)"
  if [ "$REQ_TARGET_STATUS" = "DEPLOYED" ]; then
    echo "✅ Requirements marked DEPLOYED (project does not require deployment)."
  else
    echo "⚠️  Requirements merged but not yet deployed. Deploy your changes, then run:"
    echo "   /update-requirement <REQ-ID> DEPLOYED"
  fi
fi

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
  echo "Restoring stashed changes..."
  git -C "$PROJECT_ROOT" stash pop 2>/dev/null || {
    echo "⚠️  Could not pop stash automatically. Run 'git stash pop' manually." >&2
  }
fi
