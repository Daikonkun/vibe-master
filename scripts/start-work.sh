#!/bin/bash
# Create a git worktree for a requirement and mark it IN_PROGRESS

set -euo pipefail

REQ_ID="${1:-}"
BASE_BRANCH="${2:-main}"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REQ_MANIFEST="$PROJECT_ROOT/.requirement-manifest.json"
WORKTREE_MANIFEST="$PROJECT_ROOT/.worktree-manifest.json"
source "$PROJECT_ROOT/scripts/_manifest-lock.sh"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if [ -z "$REQ_ID" ]; then
  echo "Usage: $0 REQ-<timestamp> [base-branch]" >&2
  exit 1
fi

if [[ ! "$REQ_ID" =~ ^REQ-[0-9]{10,}$ ]]; then
  echo "Error: Invalid requirement ID format: $REQ_ID" >&2
  exit 1
fi

if [ ! -f "$REQ_MANIFEST" ]; then
  echo "Error: .requirement-manifest.json not found" >&2
  exit 1
fi

if ! jq -e --arg reqId "$REQ_ID" '.requirements[] | select(.id == $reqId)' "$REQ_MANIFEST" >/dev/null; then
  echo "Error: Requirement not found: $REQ_ID" >&2
  exit 1
fi

ACTIVE_WORKTREE="$(jq -r --arg reqId "$REQ_ID" '
  .requirements[] | select(.id == $reqId) | .worktreeId // empty
' "$REQ_MANIFEST")"

if [ -n "$ACTIVE_WORKTREE" ]; then
  WT_STATUS="$(jq -r --arg wtId "$ACTIVE_WORKTREE" '
    .worktrees[]? | select(.id == $wtId) | .status
  ' "$WORKTREE_MANIFEST" 2>/dev/null | head -1)"
  if [ "$WT_STATUS" = "ACTIVE" ]; then
    echo "Error: Requirement $REQ_ID already has an active worktree: $ACTIVE_WORKTREE" >&2
    exit 1
  fi
fi

CURRENT_STATUS="$(jq -r --arg reqId "$REQ_ID" '
  .requirements[] | select(.id == $reqId) | .status // empty
' "$REQ_MANIFEST")"

if [ -z "$CURRENT_STATUS" ]; then
  echo "Error: Requirement status not found: $REQ_ID" >&2
  exit 1
fi

if [ "$CURRENT_STATUS" != "PROPOSED" ] && [ "$CURRENT_STATUS" != "BACKLOG" ]; then
  echo "Error: Requirement $REQ_ID is $CURRENT_STATUS. start-work is only allowed from PROPOSED or BACKLOG." >&2
  exit 1
fi

REQ_NAME="$(jq -r --arg reqId "$REQ_ID" '.requirements[] | select(.id == $reqId) | .name' "$REQ_MANIFEST")"
SLUG="$(echo "$REQ_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//; s/-$//')"
BRANCH_ID="feature/${REQ_ID}-${SLUG}"
WORKTREE_PATH="$(dirname "$PROJECT_ROOT")/${BRANCH_ID}"

if ! git -C "$PROJECT_ROOT" rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
  echo "Error: Base branch does not exist locally: $BASE_BRANCH" >&2
  exit 1
fi

if [ -d "$WORKTREE_PATH" ]; then
  echo "Error: Worktree path already exists: $WORKTREE_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$WORKTREE_PATH")"

if git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH_ID"; then
  git -C "$PROJECT_ROOT" worktree add "$WORKTREE_PATH" "$BRANCH_ID"
else
  git -C "$PROJECT_ROOT" worktree add -b "$BRANCH_ID" "$WORKTREE_PATH" "$BASE_BRANCH"
fi

if [ ! -f "$WORKTREE_MANIFEST" ]; then
  with_manifest_lock "$WORKTREE_MANIFEST" bash -c '
    manifest="$1"
    if [ -f "$manifest" ]; then
      exit 0
    fi

    cat > "$manifest" << '\''JSON'\''
{
  "$schema": ".worktree-manifest.schema.json",
  "version": "1.0",
  "worktrees": []
}
JSON
  ' _ "$WORKTREE_MANIFEST"
fi

# Validate updatedAt >= createdAt
CREATED_AT="$(jq -r --arg reqId "$REQ_ID" '.requirements[] | select(.id == $reqId) | .createdAt' "$REQ_MANIFEST")"
if [ -n "$CREATED_AT" ] && [ "$CREATED_AT" != "null" ] && [[ "$TIMESTAMP" < "$CREATED_AT" ]]; then
  echo "Error: updatedAt ($TIMESTAMP) would be before createdAt ($CREATED_AT)" >&2
  exit 1
fi

jq_update_manifest_locked "$REQ_MANIFEST" \
  '.requirements |= map(
     if .id == $reqId
     then .status = "IN_PROGRESS" | .worktreeId = $branch | .updatedAt = $ts
     else .
     end
   )' \
  --arg reqId "$REQ_ID" \
  --arg branch "$BRANCH_ID" \
  --arg ts "$TIMESTAMP"

jq_update_manifest_locked "$WORKTREE_MANIFEST" \
  '.worktrees += [{
     "id": $id,
     "path": $path,
     "branch": $branch,
     "baseBranch": $base,
     "requirementIds": [$reqId],
     "createdAt": $ts,
     "status": "ACTIVE"
   }]' \
  --arg id "$BRANCH_ID" \
  --arg path "$WORKTREE_PATH" \
  --arg branch "$BRANCH_ID" \
  --arg base "$BASE_BRANCH" \
  --arg reqId "$REQ_ID" \
  --arg ts "$TIMESTAMP"

"$PROJECT_ROOT/scripts/regenerate-docs.sh" >/dev/null

# Generate/update Development Plan for idempotent execution context (REQ-1774681642)
"$PROJECT_ROOT/scripts/generate-plan.sh" "$REQ_ID" || echo "Warning: Plan generation failed (non-fatal)"

git -C "$PROJECT_ROOT" add \
  .requirement-manifest.json \
  .worktree-manifest.json \
  REQUIREMENTS.md \
  docs/STATUS.md \
  docs/ROADMAP.md \
  docs/DEPENDENCIES.md \
  docs/requirements/ 2>/dev/null || true

git -C "$PROJECT_ROOT" commit -m "chore: start work on $REQ_ID" --no-verify 2>/dev/null || true

echo "✅ Work started for $REQ_ID"
echo "Worktree ID: $BRANCH_ID"
echo "Path: $WORKTREE_PATH"
echo "Base branch: $BASE_BRANCH"
