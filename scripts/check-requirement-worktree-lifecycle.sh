#!/bin/bash
# Regression check: terminal requirements must not retain ACTIVE worktrees; repair path must reconcile existing drift.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/req-wt-lifecycle-check.XXXXXX")"
CHECK_ROOT="$TMP_ROOT/check"

cleanup() {
  if [ -d "$CHECK_ROOT/.git" ]; then
    while IFS= read -r wt_path; do
      [ -z "$wt_path" ] && continue
      if [ "$wt_path" != "$CHECK_ROOT" ] && [[ "$wt_path" == "$TMP_ROOT"/* ]]; then
        git -C "$CHECK_ROOT" worktree remove "$wt_path" --force >/dev/null 2>&1 || true
      fi
    done < <(git -C "$CHECK_ROOT" worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}')
  fi

  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

assert_prereqs() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "FAIL: jq is required." >&2
    exit 1
  fi
}

copy_repo_snapshot() {
  mkdir -p "$CHECK_ROOT"
  (
    cd "$PROJECT_ROOT"
    tar -cf - --exclude='.git' .
  ) | tar -xf - -C "$CHECK_ROOT"
}

init_git_repo() {
  git -C "$CHECK_ROOT" init -b main >/dev/null
  git -C "$CHECK_ROOT" config user.email "req-wt-lifecycle-check@example.com"
  git -C "$CHECK_ROOT" config user.name "Requirement Worktree Lifecycle Check"
  git -C "$CHECK_ROOT" add .
  git -C "$CHECK_ROOT" commit -m "baseline snapshot" >/dev/null
}

pick_candidate_requirement() {
  jq -r '.requirements[]
    | select((.status == "PROPOSED" or .status == "BACKLOG") and ((.worktreeId // "") == ""))
    | .id' "$CHECK_ROOT/.requirement-manifest.json" | head -1
}

assert_prereqs
copy_repo_snapshot
init_git_repo

REQ_ID="$(pick_candidate_requirement)"
if [ -z "$REQ_ID" ]; then
  echo "FAIL: no PROPOSED/BACKLOG requirement without a worktree is available for regression setup." >&2
  exit 1
fi

cd "$CHECK_ROOT"

bash scripts/start-work.sh "$REQ_ID" >/dev/null

WT_ID="$(jq -r --arg reqId "$REQ_ID" '.requirements[] | select(.id == $reqId) | .worktreeId // empty' .requirement-manifest.json)"
if [ -z "$WT_ID" ]; then
  echo "FAIL: start-work did not attach a worktreeId for $REQ_ID." >&2
  exit 1
fi

WT_STATUS="$(jq -r --arg wtId "$WT_ID" '.worktrees[] | select(.id == $wtId) | .status // empty' .worktree-manifest.json | head -1)"
if [ "$WT_STATUS" != "ACTIVE" ]; then
  echo "FAIL: expected ACTIVE worktree after start-work, got '$WT_STATUS'." >&2
  exit 1
fi

bash scripts/update-requirement-status.sh "$REQ_ID" CODE_REVIEW --no-refresh >/dev/null

set +e
MERGE_BLOCK_OUTPUT="$(bash scripts/update-requirement-status.sh "$REQ_ID" MERGED --no-refresh 2>&1)"
MERGE_BLOCK_STATUS=$?
set -e

if [ "$MERGE_BLOCK_STATUS" -eq 0 ]; then
  echo "FAIL: expected MERGED transition to be blocked while worktree is ACTIVE." >&2
  exit 1
fi

if ! grep -Fq "linked worktree remains ACTIVE" <<< "$MERGE_BLOCK_OUTPUT"; then
  echo "FAIL: blocked MERGED transition did not surface lifecycle invariant error." >&2
  echo "$MERGE_BLOCK_OUTPUT" >&2
  exit 1
fi

# Seed legacy drift intentionally so repair path can be validated.
bash scripts/update-requirement-status.sh "$REQ_ID" MERGED --force --no-refresh >/dev/null

WT_STATUS_AFTER_FORCE="$(jq -r --arg wtId "$WT_ID" '.worktrees[] | select(.id == $wtId) | .status // empty' .worktree-manifest.json | head -1)"
if [ "$WT_STATUS_AFTER_FORCE" != "ACTIVE" ]; then
  echo "FAIL: expected seeded drift to keep worktree ACTIVE, got '$WT_STATUS_AFTER_FORCE'." >&2
  exit 1
fi

bash scripts/reconcile-lifecycle-invariants.sh --apply --no-refresh >/dev/null

WT_STATUS_AFTER_REPAIR="$(jq -r --arg wtId "$WT_ID" '.worktrees[] | select(.id == $wtId) | .status // empty' .worktree-manifest.json | head -1)"
if [ "$WT_STATUS_AFTER_REPAIR" != "MERGED" ]; then
  echo "FAIL: lifecycle reconciliation did not repair ACTIVE worktree drift ($WT_STATUS_AFTER_REPAIR)." >&2
  exit 1
fi

REQ_STATUS_FINAL="$(jq -r --arg reqId "$REQ_ID" '.requirements[] | select(.id == $reqId) | .status // empty' .requirement-manifest.json)"
if [ "$REQ_STATUS_FINAL" != "MERGED" ]; then
  echo "FAIL: reconciliation unexpectedly changed requirement status ($REQ_STATUS_FINAL)." >&2
  exit 1
fi

echo "PASS: lifecycle invariant blocks terminal transition with ACTIVE worktree and reconciliation repairs seeded drift."
