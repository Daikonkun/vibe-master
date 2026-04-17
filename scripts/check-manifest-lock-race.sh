#!/bin/bash
# Regression check: concurrent manifest writers should not lose updates.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
source "$PROJECT_ROOT/scripts/_manifest-lock.sh"

WORKERS="${1:-40}"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/manifest-lock-race.XXXXXX")"
TEST_MANIFEST="$TMP_ROOT/manifest.json"

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

if [[ ! "$WORKERS" =~ ^[0-9]+$ ]] || [ "$WORKERS" -le 0 ]; then
  echo "Usage: $0 [worker-count]" >&2
  echo "Example: $0 40" >&2
  exit 1
fi

cat > "$TEST_MANIFEST" << 'JSON'
{
  "requirements": []
}
JSON

write_once() {
  local req_id="$1"

  jq_update_manifest_locked "$TEST_MANIFEST" \
    '.requirements += [{"id": $id}]' \
    --arg id "$req_id"
}

run_parallel_writes() {
  local prefix="$1"
  local count="$2"
  local i=1

  while [ "$i" -le "$count" ]; do
    write_once "${prefix}-${i}" &
    i=$((i + 1))
  done

  wait
}

assert_count() {
  local prefix="$1"
  local expected="$2"
  local actual
  local unique

  actual="$(jq --arg prefix "$prefix" '[.requirements[] | select(.id | startswith($prefix))] | length' "$TEST_MANIFEST")"
  unique="$(jq --arg prefix "$prefix" '[.requirements[] | select(.id | startswith($prefix)) | .id] | unique | length' "$TEST_MANIFEST")"

  if [ "$actual" -ne "$expected" ] || [ "$unique" -ne "$expected" ]; then
    echo "FAIL: lost or duplicate updates for prefix '$prefix' (actual=$actual unique=$unique expected=$expected)" >&2
    jq '.' "$TEST_MANIFEST" >&2
    exit 1
  fi
}

assert_error_propagation() {
  local backend="$1"
  local status=0
  local expected=17

  if [ "$backend" = "mkdir" ]; then
    MANIFEST_LOCK_FORCE_MKDIR=1 with_manifest_lock "$TEST_MANIFEST" bash -c 'exit 17' || status=$?
    unset MANIFEST_LOCK_FORCE_MKDIR
  else
    with_manifest_lock "$TEST_MANIFEST" bash -c 'exit 17' || status=$?
  fi

  if [ "$status" -ne "$expected" ]; then
    echo "FAIL: backend '$backend' did not preserve command exit code (expected=$expected actual=$status)" >&2
    exit 1
  fi
}

if manifest_lock_supports_flock; then
  run_parallel_writes "flock" "$WORKERS"
  assert_count "flock" "$WORKERS"
  assert_error_propagation "flock"

  MANIFEST_LOCK_FORCE_MKDIR=1
  run_parallel_writes "mkdir" "$WORKERS"
  unset MANIFEST_LOCK_FORCE_MKDIR
  assert_count "mkdir" "$WORKERS"
  assert_error_propagation "mkdir"

  echo "PASS: flock and mkdir lock backends preserved concurrent writes and error propagation ($WORKERS each)."
else
  run_parallel_writes "mkdir" "$WORKERS"
  assert_count "mkdir" "$WORKERS"
  assert_error_propagation "mkdir"

  echo "PASS: mkdir lock backend preserved concurrent writes and error propagation ($WORKERS)."
fi
