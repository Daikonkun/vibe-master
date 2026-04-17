#!/bin/bash
# Shared helpers for lock-safe, atomic manifest writes.

ensure_flock_available() {
  if command -v flock >/dev/null 2>&1; then
    return 0
  fi

  echo "Error: missing required dependency: flock" >&2
  echo "Install with Homebrew: brew install flock" >&2
  echo "Or run: bash scripts/bootstrap-deps.sh --install" >&2
  return 1
}

with_manifest_lock() {
  local manifest_file="$1"
  shift

  ensure_flock_available || return 1

  (
    flock -x 200
    "$@"
  ) 200>"${manifest_file}.lock"
}

jq_update_manifest_locked() {
  local manifest_file="$1"
  local jq_filter="$2"
  shift 2

  if [ ! -f "$manifest_file" ]; then
    echo "Error: Manifest not found: $manifest_file" >&2
    return 1
  fi

  ensure_flock_available || return 1

  if ! (
    flock -x 200

    tmp_file="$(mktemp "${manifest_file}.XXXXXX")"

    if ! jq "$@" "$jq_filter" "$manifest_file" > "$tmp_file"; then
      rm -f "$tmp_file"
      exit 1
    fi

    if ! mv "$tmp_file" "$manifest_file"; then
      rm -f "$tmp_file"
      exit 1
    fi
  ) 200>"${manifest_file}.lock"; then
    return 1
  fi
}
