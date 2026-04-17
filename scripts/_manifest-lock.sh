#!/bin/bash
# Shared helpers for lock-safe, atomic manifest writes.

manifest_lock_supports_flock() {
  if [ "${MANIFEST_LOCK_FORCE_MKDIR:-0}" = "1" ]; then
    return 1
  fi

  command -v flock >/dev/null 2>&1
}

manifest_lock_wait_for_directory() {
  local lock_dir="$1"
  local max_attempts="${2:-3000}"
  local attempt=0

  while ! mkdir "$lock_dir" 2>/dev/null; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "Error: timed out waiting for lock: $lock_dir" >&2
      echo "Hint: install flock with: bash scripts/bootstrap-deps.sh --install" >&2
      return 1
    fi
    sleep 0.01
  done
}

with_manifest_lock() {
  local manifest_file="${1:-}"
  shift || true

  if [ -z "$manifest_file" ] || [ "$#" -eq 0 ]; then
    echo "Usage: with_manifest_lock <manifest-file> <command> [args...]" >&2
    return 1
  fi

  local lock_file="${manifest_file}.lock"

  if manifest_lock_supports_flock; then
    (
      flock -x 200
      "$@"
    ) 200>"$lock_file"
    return $?
  fi

  local lock_dir="${lock_file}.d"
  local status=0
  manifest_lock_wait_for_directory "$lock_dir" || return 1

  if "$@"; then
    status=0
  else
    status=$?
  fi

  rmdir "$lock_dir" 2>/dev/null || true
  return "$status"
}

_jq_update_manifest_locked_inner() {
  local manifest_file="$1"
  local jq_filter="$2"
  shift 2

  local tmp_file
  tmp_file="$(mktemp "${manifest_file}.XXXXXX")"

  if ! jq "$@" "$jq_filter" "$manifest_file" > "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi

  if ! mv "$tmp_file" "$manifest_file"; then
    rm -f "$tmp_file"
    return 1
  fi
}

jq_update_manifest_locked() {
  local manifest_file="$1"
  local jq_filter="$2"
  shift 2

  if [ ! -f "$manifest_file" ]; then
    echo "Error: Manifest not found: $manifest_file" >&2
    return 1
  fi

  with_manifest_lock "$manifest_file" _jq_update_manifest_locked_inner "$manifest_file" "$jq_filter" "$@"
}
