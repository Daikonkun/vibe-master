#!/bin/bash
# Merge a feature branch, clean worktree, and update manifests

set -euo pipefail

BRANCH=""
BASE_BRANCH="main"
FORCE="false"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REQ_MANIFEST="$PROJECT_ROOT/.requirement-manifest.json"
WORKTREE_MANIFEST="$PROJECT_ROOT/.worktree-manifest.json"
source "$PROJECT_ROOT/scripts/_manifest-lock.sh"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
STASHED=false
UNMAPPED_FORCE_MODE=false
HAS_WORKTREE_MAPPING=false
WORKTREE_REMOVED=false

usage() {
  cat << 'EOF'
Usage: ./scripts/worktree-merge.sh <branch> [base-branch] [--force]

Flags:
  --force   Allow merge when no worktree-manifest mapping exists for the branch
EOF
}

if [ "$#" -eq 0 ]; then
  usage >&2
  exit 1
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit 0
fi

BRANCH="$1"
shift

if [ "$#" -gt 0 ] && [[ "$1" != --* ]]; then
  BASE_BRANCH="$1"
  shift
fi

for arg in "$@"; do
  case "$arg" in
    --force)
      FORCE="true"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -z "$BRANCH" ]; then
  usage >&2
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

if [ -n "$WORKTREE_PATH" ] || [ -n "$REQ_IDS" ]; then
  HAS_WORKTREE_MAPPING=true
else
  echo "⚠️  Warning: No worktree-manifest mapping found for branch: $BRANCH" >&2
  if [ "$FORCE" != "true" ]; then
    echo "Refusing to merge unmapped branch without --force." >&2
    exit 1
  fi
  UNMAPPED_FORCE_MODE=true
  echo "Proceeding due to --force. Requirement status updates will be skipped." >&2
fi

echo "Merging $BRANCH into $BASE_BRANCH..."
git -C "$PROJECT_ROOT" checkout "$BASE_BRANCH"
git -C "$PROJECT_ROOT" merge --no-ff "$BRANCH" -m "Merge $BRANCH"

if [ -n "$WORKTREE_PATH" ] && [ -d "$WORKTREE_PATH" ]; then
  if git -C "$PROJECT_ROOT" worktree remove "$WORKTREE_PATH"; then
    WORKTREE_REMOVED=true
  elif [ "$UNMAPPED_FORCE_MODE" = true ]; then
    echo "⚠️  Could not remove worktree during forced unmapped merge: $WORKTREE_PATH" >&2
  else
    echo "Error: Failed to remove worktree: $WORKTREE_PATH" >&2
    exit 1
  fi
fi

if ! git -C "$PROJECT_ROOT" branch -d "$BRANCH"; then
  if [ "$UNMAPPED_FORCE_MODE" = true ]; then
    echo "⚠️  Could not delete branch during forced unmapped merge: $BRANCH" >&2
  else
    echo "Error: Failed to delete merged branch: $BRANCH" >&2
    exit 1
  fi
fi

if [ "$HAS_WORKTREE_MAPPING" = true ]; then
  jq_update_manifest_locked "$WORKTREE_MANIFEST" \
    '.worktrees |= map(
      if .branch == $branch or .id == $branch
      then .status = "MERGED" | .mergedAt = $ts
      else .
      end
    )' \
    --arg branch "$BRANCH" \
    --arg ts "$TIMESTAMP"
fi

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
else
  echo "⚠️  No mapped requirements found for $BRANCH; no requirement status was updated."
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
if [ "$WORKTREE_REMOVED" = true ]; then
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
if [ "$UNMAPPED_FORCE_MODE" = true ]; then
  echo "⚠️  Completed forced unmapped merge. No requirement statuses were updated."
fi

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
  echo "Restoring stashed changes..."
  git -C "$PROJECT_ROOT" stash pop 2>/dev/null || {
    echo "⚠️  Could not pop stash automatically. Run 'git stash pop' manually." >&2
  }
fi
