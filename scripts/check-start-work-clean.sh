#!/bin/bash
# Regression check: start-work should not leave lock artifacts, and docs regen should be idempotent.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/start-work-clean-check.XXXXXX")"
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

assert_no_lock_artifacts() {
  local repo_root="$1"
  local has_errors=0

  for lock_file in \
    "$repo_root/.requirement-manifest.json.lock" \
    "$repo_root/.worktree-manifest.json.lock"; do
    if [ -e "$lock_file" ]; then
      echo "FAIL: stale lock file found: $lock_file" >&2
      has_errors=1
    fi
  done

  while IFS= read -r lock_dir; do
    [ -z "$lock_dir" ] && continue
    echo "FAIL: stale lock directory found: $lock_dir" >&2
    has_errors=1
  done < <(find "$repo_root" -maxdepth 1 -type d -name '*.lock.d' -print)

  if [ "$has_errors" -ne 0 ]; then
    exit 1
  fi
}

mkdir -p "$CHECK_ROOT"
(
  cd "$PROJECT_ROOT"
  tar -cf - --exclude='.git' .
) | tar -xf - -C "$CHECK_ROOT"

git -C "$CHECK_ROOT" init -b main >/dev/null
git -C "$CHECK_ROOT" config user.email "start-work-clean-check@example.com"
git -C "$CHECK_ROOT" config user.name "Start Work Clean Check"
git -C "$CHECK_ROOT" add .
git -C "$CHECK_ROOT" commit -m "baseline snapshot" >/dev/null

cd "$CHECK_ROOT"

CANDIDATE_REQS=()
while IFS= read -r req_id; do
  [ -z "$req_id" ] && continue
  CANDIDATE_REQS+=("$req_id")
done < <(
  jq -r '.requirements[]
    | select((.status == "PROPOSED" or .status == "BACKLOG") and ((.worktreeId // "") == ""))
    | .id' .requirement-manifest.json
)

if [ "${#CANDIDATE_REQS[@]}" -lt 2 ]; then
  echo "FAIL: expected at least two PROPOSED/BACKLOG requirements without worktrees for regression check." >&2
  exit 1
fi

SUCCESS_REQ="${CANDIDATE_REQS[0]}"
FAIL_REQ="${CANDIDATE_REQS[1]}"

# 1) No-op regenerate-docs should not change generated outputs after baseline generation.
bash scripts/regenerate-docs.sh >/dev/null
git add REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/ .requirement-manifest.json .worktree-manifest.json
git commit -m "baseline generated docs" >/dev/null || true

bash scripts/regenerate-docs.sh >/dev/null
if ! git diff --quiet -- REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements; then
  echo "FAIL: regenerate-docs produced generated-doc diffs without manifest changes." >&2
  git --no-pager diff -- REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements >&2
  exit 1
fi

# 2) start-work success path should not leave lock artifacts.
bash scripts/start-work.sh "$SUCCESS_REQ" >/dev/null
assert_no_lock_artifacts "$CHECK_ROOT"

# 3) start-work failure after lock acquisition should still clean lock artifacts.
cp .worktree-manifest.json .worktree-manifest.json.bak
printf '{\n' > .worktree-manifest.json

set +e
FAIL_OUTPUT="$(bash scripts/start-work.sh "$FAIL_REQ" 2>&1)"
FAIL_STATUS=$?
set -e

mv .worktree-manifest.json.bak .worktree-manifest.json

if [ "$FAIL_STATUS" -eq 0 ]; then
  echo "FAIL: expected induced start-work failure, but command succeeded." >&2
  exit 1
fi

if ! grep -Eq 'parse error|Error:' <<< "$FAIL_OUTPUT"; then
  echo "FAIL: induced start-work failure did not surface expected script error output." >&2
  echo "$FAIL_OUTPUT" >&2
  exit 1
fi

assert_no_lock_artifacts "$CHECK_ROOT"

# 4) Locks should be acquirable immediately after failed start-work without manual cleanup.
source scripts/_manifest-lock.sh
with_manifest_lock .requirement-manifest.json true
with_manifest_lock .worktree-manifest.json true
assert_no_lock_artifacts "$CHECK_ROOT"

echo "PASS: start-work lock cleanup and regenerate-docs idempotence checks passed."