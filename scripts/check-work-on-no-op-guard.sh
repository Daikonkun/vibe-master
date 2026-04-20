#!/bin/bash
# Regression check: work-on no-op guard must include tracked working-tree evidence.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROMPT_FILE="$PROJECT_ROOT/.github/prompts/work-on.prompt.md"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "FAIL: missing prompt file: $PROMPT_FILE" >&2
  exit 1
fi

MISSING=0

assert_contains() {
  local needle="$1"
  local label="$2"

  if ! grep -Fq "$needle" "$PROMPT_FILE"; then
    echo "FAIL: missing $label" >&2
    echo "  expected text: $needle" >&2
    MISSING=1
  fi
}

assert_contains "git -C <worktree-path> diff --name-status <base-branch>...HEAD" "commit-diff no-op evidence command"
assert_contains "git -C <worktree-path> status --porcelain --untracked-files=no" "tracked working-tree no-op evidence command"
assert_contains "Treat evidence as present when either signal is non-empty." "dual-signal no-op evidence rule"
assert_contains "No-op evidence is tracked-only: staged and unstaged tracked deltas count, while untracked files are excluded." "tracked-only evidence constraint"

if [ "$MISSING" -ne 0 ]; then
  echo "FAIL: work-on no-op guard contract is incomplete." >&2
  exit 1
fi

echo "PASS: work-on no-op guard includes dual evidence signals and tracked-only semantics."