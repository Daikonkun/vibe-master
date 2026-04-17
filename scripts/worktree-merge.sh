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
UNMAPPED_FORCE_MODE=false
WORKTREE_REMOVED=false

usage() {
  cat << 'EOF'
Usage: ./scripts/worktree-merge.sh <branch> [base-branch] [--force]

Flags:
  --force   Allow merge when no ACTIVE worktree mapping exists for the branch
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

# Remove stale lock artifacts from previous interrupted operations.
rm -f "${REQ_MANIFEST}.lock" "${WORKTREE_MANIFEST}.lock"

DIRTY_FILES="$(git -C "$PROJECT_ROOT" status --porcelain)"
if [ -n "$DIRTY_FILES" ]; then
  echo "Error: Working tree is not clean. Refusing to merge with unrelated in-flight changes." >&2
  echo "Unexpected dirty files:" >&2
  echo "$DIRTY_FILES" | sed 's/^/  /' >&2
  exit 1
fi

if ! git -C "$PROJECT_ROOT" rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
  echo "Error: Base branch not found locally: $BASE_BRANCH" >&2
  exit 1
fi

if ! git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Error: Feature branch not found locally: $BRANCH" >&2
  exit 1
fi

WORKTREE_ENTRY="$(jq -c --arg branch "$BRANCH" '
  .worktrees[]? | select((.branch == $branch or .id == $branch) and .status == "ACTIVE")
' "$WORKTREE_MANIFEST" | head -1)"

WORKTREE_PATH=""
REQ_IDS=""
if [ -n "$WORKTREE_ENTRY" ]; then
  WORKTREE_PATH="$(echo "$WORKTREE_ENTRY" | jq -r '.path // empty')"
  REQ_IDS="$(echo "$WORKTREE_ENTRY" | jq -r '.requirementIds[]?')"
else
  echo "⚠️  Warning: No ACTIVE worktree mapping found for branch: $BRANCH" >&2
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

if [ -n "$WORKTREE_ENTRY" ]; then
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

# Remove transient lock artifacts produced by manifest updates.
rm -f "${REQ_MANIFEST}.lock" "${WORKTREE_MANIFEST}.lock"

FILES_TO_ADD=()

add_stage_file() {
  local candidate="$1"
  local existing

  [ -z "$candidate" ] && return
  [ ! -e "$PROJECT_ROOT/$candidate" ] && return

  for existing in "${FILES_TO_ADD[@]:-}"; do
    if [ "$existing" = "$candidate" ]; then
      return
    fi
  done

  FILES_TO_ADD+=("$candidate")
}

add_stage_file ".requirement-manifest.json"
add_stage_file ".worktree-manifest.json"
add_stage_file "REQUIREMENTS.md"
add_stage_file "docs/STATUS.md"
add_stage_file "docs/ROADMAP.md"
add_stage_file "docs/DEPENDENCIES.md"

if [ -n "$REQ_IDS" ]; then
  while IFS= read -r reqId; do
    [ -z "$reqId" ] && continue
    req_spec="$(find "$PROJECT_ROOT/docs/requirements" -maxdepth 1 -type f -name "${reqId}-*.md" | head -1)"
    if [ -n "$req_spec" ]; then
      add_stage_file "${req_spec#$PROJECT_ROOT/}"
    fi
  done <<< "$REQ_IDS"
fi

if [ "${#FILES_TO_ADD[@]}" -gt 0 ]; then
  git -C "$PROJECT_ROOT" add -- "${FILES_TO_ADD[@]}"
fi

is_allowed_dirty_file() {
  local candidate="$1"
  local staged
  for staged in "${FILES_TO_ADD[@]:-}"; do
    if [ "$staged" = "$candidate" ]; then
      return 0
    fi
  done
  return 1
}

STATUS_AFTER_STAGE="$(git -C "$PROJECT_ROOT" status --porcelain)"
if [ -n "$STATUS_AFTER_STAGE" ]; then
  UNEXPECTED_DIRTY=()
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    dirty_path="${line:3}"
    if [[ "$dirty_path" == *" -> "* ]]; then
      dirty_path="${dirty_path##* -> }"
    fi

    if ! is_allowed_dirty_file "$dirty_path"; then
      UNEXPECTED_DIRTY+=("$line")
    fi
  done <<< "$STATUS_AFTER_STAGE"

  if [ "${#UNEXPECTED_DIRTY[@]}" -gt 0 ]; then
    echo "Error: Unexpected dirty files detected; refusing to continue." >&2
    printf '  %s\n' "${UNEXPECTED_DIRTY[@]}" >&2
    exit 1
  fi
fi

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
