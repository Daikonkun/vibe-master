#!/bin/bash
# Guard: ensure command docs/prompts do not reference nonexistent scripts.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

if [ ! -d "scripts" ]; then
  echo "Error: scripts/ directory not found." >&2
  exit 1
fi

FILES=(
  "README.md"
  "copilot-instructions.md"
  "docs/COMMAND_MAP.md"
)

for prompt in .github/prompts/*.prompt.md; do
  [ -f "$prompt" ] || continue
  FILES+=("$prompt")
done

missing=0

check_file_refs() {
  local file="$1"
  local refs ref

  refs="$(grep -Eo '(\./)?scripts/[A-Za-z0-9._-]+\.sh' "$file" | sed 's#^\./##' | sort -u || true)"

  if [ -z "$refs" ]; then
    return
  fi

  while IFS= read -r ref; do
    [ -n "$ref" ] || continue
    if [ ! -f "$ref" ]; then
      echo "FAIL: $file references missing script entrypoint: $ref" >&2
      missing=1
    fi
  done <<< "$refs"
}

for file in "${FILES[@]}"; do
  [ -f "$file" ] || continue
  check_file_refs "$file"
done

if [ "$missing" -ne 0 ]; then
  echo "" >&2
  echo "Command entrypoint guard failed." >&2
  echo "Fix missing script references or update docs/prompt text to the correct command entrypoint." >&2
  exit 1
fi

echo "PASS: Command entrypoint references are valid."
