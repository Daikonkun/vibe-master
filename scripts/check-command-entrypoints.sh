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
names_file="$(mktemp)"

cleanup() {
  rm -f "$names_file"
}
trap cleanup EXIT

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

extract_frontmatter_value() {
  local file="$1"
  local key="$2"

  awk -F':' -v wanted="$key" '
    $1 == wanted {
      value = substr($0, index($0, ":") + 1)
      gsub(/^[[:space:]]+/, "", value)
      gsub(/[[:space:]]+$/, "", value)
      gsub(/^"/, "", value)
      gsub(/"$/, "", value)
      print value
      exit
    }
  ' "$file"
}

check_prompt_metadata() {
  local prompt="$1"
  local base field value

  base="$(basename "$prompt" .prompt.md)"

  if ! grep -q '^---$' "$prompt"; then
    echo "FAIL: $prompt is missing YAML frontmatter delimiters (---)." >&2
    missing=1
    return
  fi

  for field in name description agent; do
    if ! grep -q "^${field}:" "$prompt"; then
      echo "FAIL: $prompt is missing required frontmatter field: ${field}" >&2
      missing=1
    fi
  done

  value="$(extract_frontmatter_value "$prompt" "name")"
  if [ -z "$value" ]; then
    echo "FAIL: $prompt has empty or unreadable frontmatter name." >&2
    missing=1
    return
  fi

  if [ "$value" != "$base" ]; then
    echo "FAIL: $prompt frontmatter name ('$value') must match filename command ('$base')." >&2
    missing=1
  fi

  printf '%s\n' "$value" >> "$names_file"
}

check_command_presence_in_docs() {
  local cmd="$1"

  if ! grep -q "/${cmd}" docs/COMMAND_MAP.md; then
    echo "FAIL: docs/COMMAND_MAP.md is missing command /${cmd}." >&2
    missing=1
  fi

  if ! grep -q "/${cmd}" copilot-instructions.md; then
    echo "FAIL: copilot-instructions.md is missing command /${cmd}." >&2
    missing=1
  fi
}

for file in "${FILES[@]}"; do
  [ -f "$file" ] || continue
  check_file_refs "$file"
done

for prompt in .github/prompts/*.prompt.md; do
  [ -f "$prompt" ] || continue
  check_prompt_metadata "$prompt"
  check_command_presence_in_docs "$(basename "$prompt" .prompt.md)"
done

for required_command in add-requirement status start-work work-on; do
  if [ ! -f ".github/prompts/${required_command}.prompt.md" ]; then
    echo "FAIL: missing required representative prompt file .github/prompts/${required_command}.prompt.md" >&2
    missing=1
    continue
  fi
  check_command_presence_in_docs "$required_command"
done

duplicate_names="$(sort "$names_file" | uniq -d || true)"
if [ -n "$duplicate_names" ]; then
  echo "FAIL: duplicate prompt frontmatter names detected:" >&2
  echo "$duplicate_names" >&2
  missing=1
fi

if [ "$missing" -ne 0 ]; then
  echo "" >&2
  echo "Command entrypoint guard failed." >&2
  echo "Fix script references, prompt frontmatter metadata, and command docs so slash-command routing stays consistent." >&2
  exit 1
fi

echo "PASS: Command entrypoints and prompt metadata are valid."
