#!/bin/bash
# Regression check for REQ-ID worktree resolution fallback when requirement.worktreeId is missing or stale.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_UNDER_TEST="$PROJECT_ROOT/scripts/worktree-merge.sh"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wt-merge-req-fallback.XXXXXX")"
REPO_DIR="$TMP_ROOT/repo"
WORKTREE_PATH="$TMP_ROOT/feature-wt"
REQ_ID="REQ-1111111111"
BRANCH_NAME="feature/$REQ_ID-fallback-check"

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

mkdir -p "$REPO_DIR/scripts"
cp "$SCRIPT_UNDER_TEST" "$REPO_DIR/scripts/worktree-merge.sh"
cp "$PROJECT_ROOT/scripts/_manifest-lock.sh" "$REPO_DIR/scripts/_manifest-lock.sh"

cat > "$REPO_DIR/scripts/regenerate-docs.sh" << 'EOF'
#!/bin/bash
set -euo pipefail
exit 0
EOF

cat > "$REPO_DIR/.requirement-manifest.json" << EOF
{
  "\$schema": ".requirement-manifest.schema.json",
  "version": "1.0",
  "requiresDeployment": true,
  "requirements": [
    {
      "id": "$REQ_ID",
      "name": "fallback check",
      "description": "regression fixture",
      "status": "CODE_REVIEW",
      "priority": "MEDIUM",
      "createdAt": "2026-01-01T00:00:00Z",
      "updatedAt": "2026-01-01T00:00:00Z",
      "worktreeId": "feature/stale-branch"
    }
  ]
}
EOF

cat > "$REPO_DIR/.worktree-manifest.json" << EOF
{
  "\$schema": ".worktree-manifest.schema.json",
  "version": "1.0",
  "worktrees": [
    {
      "id": "$BRANCH_NAME",
      "path": "$WORKTREE_PATH",
      "branch": "$BRANCH_NAME",
      "baseBranch": "main",
      "requirementIds": ["$REQ_ID"],
      "createdAt": "2026-01-01T00:00:00Z",
      "status": "ACTIVE"
    }
  ]
}
EOF

chmod +x "$REPO_DIR/scripts/worktree-merge.sh" "$REPO_DIR/scripts/regenerate-docs.sh"

git -C "$REPO_DIR" init -b main >/dev/null
git -C "$REPO_DIR" config user.email "regression-check@example.com"
git -C "$REPO_DIR" config user.name "Regression Check"

echo "base" > "$REPO_DIR/README.md"
git -C "$REPO_DIR" add .
git -C "$REPO_DIR" commit -m "init repo" >/dev/null

git -C "$REPO_DIR" checkout -b "$BRANCH_NAME" >/dev/null
echo "feature" >> "$REPO_DIR/README.md"
git -C "$REPO_DIR" add README.md
git -C "$REPO_DIR" commit -m "feature change" >/dev/null
git -C "$REPO_DIR" checkout main >/dev/null

git -C "$REPO_DIR" worktree add "$WORKTREE_PATH" "$BRANCH_NAME" >/dev/null

# Keep tracked dirty file in the active worktree so merge aborts before destructive actions.
echo "dirty" >> "$WORKTREE_PATH/README.md"

set +e
OUTPUT="$(cd "$REPO_DIR" && ./scripts/worktree-merge.sh "$REQ_ID" 2>&1)"
STATUS=$?
set -e

if [ "$STATUS" -eq 0 ]; then
  echo "FAIL: expected non-zero status because tracked dirty file should block merge" >&2
  echo "$OUTPUT" >&2
  exit 1
fi

if ! echo "$OUTPUT" | grep -q "Falling back to requirement linkage lookup"; then
  echo "FAIL: expected stale-worktreeId fallback warning" >&2
  echo "$OUTPUT" >&2
  exit 1
fi

if ! echo "$OUTPUT" | grep -q "Resolved $REQ_ID to branch: $BRANCH_NAME"; then
  echo "FAIL: expected REQ resolution to fallback branch" >&2
  echo "$OUTPUT" >&2
  exit 1
fi

if ! echo "$OUTPUT" | grep -q "Failed to remove worktree"; then
  echo "FAIL: expected downstream failure after successful branch resolution" >&2
  echo "$OUTPUT" >&2
  exit 1
fi

echo "PASS: REQ fallback resolves stale worktreeId via requirementIds and proceeds into downstream merge workflow."