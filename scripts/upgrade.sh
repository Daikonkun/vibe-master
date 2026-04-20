#!/bin/bash
# Safely preview/apply Vibe Master template updates in an isolated worktree.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

BASE_BRANCH="main"
WORKTREE_PATH=""
BRANCH_NAME="chore/vibe-master-upgrade"
COMMAND_NAME="upgrade"
CHECK_ONLY="false"
APPLY="false"
ASSUME_YES="false"
TEMPLATE_REPO="${VIBE_MASTER_TEMPLATE_REPO:-}"

UPGRADE_STAGING=""
TEMPLATE_DIR=""
DIFF_FILE=""
DIFF_HAS_CHANGES="false"

ROOT_STATUS_BEFORE="$(git -C "$PROJECT_ROOT" status --short || true)"

usage() {
  cat << 'EOF'
Usage: ./scripts/upgrade.sh [options]

Safely upgrade from the latest Vibe Master GitHub template in an isolated worktree.

Options:
  --template-repo <url>  GitHub URL for the template source repository.
                         Default: $VIBE_MASTER_TEMPLATE_REPO or origin remote URL.
  --base-branch <name>   Base branch for upgrade worktree creation (default: main)
  --worktree-path <path> Upgrade worktree path (default: ../upgrade/vibe-master-latest)
  --branch-name <name>   Upgrade branch name (default: chore/vibe-master-upgrade)
  --command-name <name>  Slash command name to validate (default: upgrade)
  --check-only           Run preflight conflict checks only, then exit
  --apply                Apply template files after previewing diff
  --yes                  Skip interactive confirmation prompt (with --apply only)
  -h, --help             Show this help

Behavior:
  1) Always performs slash-command conflict preflight checks first.
  2) Creates/reuses an isolated sibling worktree.
  3) Clones latest template into <worktree>/.upgrade-template/latest.
  4) Generates diff preview at <worktree>/.upgrade-template/upgrade-preview.diff.
  5) Applies changes only when --apply is used and confirmation is explicit.
EOF
}

KNOWN_NATIVE_COMMANDS=(
  ask
  explain
  fix
  tests
  test
  doc
  docs
  help
  clear
  new
  terminal
  run
  start
  debug
  review
)

check_command_conflicts() {
  local command="$1"
  local prompts_dir="$PROJECT_ROOT/.github/prompts"

  if [[ ! "$command" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Invalid command name '$command'. Use lowercase letters, digits, and hyphens only." >&2
    return 1
  fi

  if [ ! -d "$prompts_dir" ]; then
    echo "Error: Prompt directory not found: $prompts_dir" >&2
    return 1
  fi

  local native
  for native in "${KNOWN_NATIVE_COMMANDS[@]}"; do
    if [ "$native" = "$command" ]; then
      echo "Error: /$command conflicts with a known native VS Code/Copilot slash command name." >&2
      echo "Recommendation: rename to /vm-$command (or another unique project prefix)." >&2
      return 1
    fi
  done

  local project_match_count
  project_match_count="$(find "$prompts_dir" -maxdepth 1 -type f -name "${command}.prompt.md" | wc -l | tr -d ' ')"
  if [ "$project_match_count" -gt 1 ]; then
    echo "Error: /$command is defined by multiple prompt files in .github/prompts/." >&2
    echo "Recommendation: keep one canonical file and rename others to unique slash command names." >&2
    return 1
  fi

  echo "✅ Preflight command check passed for /$command"
  echo "   Project prompt matches: $project_match_count file(s)"
  echo "   Known native/Copilot command collisions: none"
}

resolve_template_repo() {
  if [ -n "$TEMPLATE_REPO" ]; then
    return 0
  fi

  if git -C "$PROJECT_ROOT" remote get-url origin >/dev/null 2>&1; then
    local origin_url
    origin_url="$(git -C "$PROJECT_ROOT" remote get-url origin)"
    if echo "$origin_url" | grep -Eq 'github\.com'; then
      TEMPLATE_REPO="$origin_url"
    fi
  fi

  if [ -z "$TEMPLATE_REPO" ]; then
    echo "Error: No template repo configured. Provide --template-repo <https://github.com/...> or set VIBE_MASTER_TEMPLATE_REPO." >&2
    return 1
  fi

  if ! echo "$TEMPLATE_REPO" | grep -Eq 'github\.com'; then
    echo "Error: Template repo must be a GitHub URL: $TEMPLATE_REPO" >&2
    return 1
  fi

  return 0
}

is_registered_worktree() {
  local target_path="$1"
  git -C "$PROJECT_ROOT" worktree list --porcelain | awk '/^worktree / {print substr($0, 10)}' | grep -Fxq "$target_path"
}

ensure_upgrade_worktree() {
  if [ -z "$WORKTREE_PATH" ]; then
    WORKTREE_PATH="$(dirname "$PROJECT_ROOT")/upgrade/vibe-master-latest"
  fi

  if [ -d "$WORKTREE_PATH" ]; then
    if is_registered_worktree "$WORKTREE_PATH"; then
      echo "ℹ️ Reusing existing upgrade worktree: $WORKTREE_PATH"
      return 0
    fi
    echo "Error: Path exists but is not a registered git worktree: $WORKTREE_PATH" >&2
    return 1
  fi

  if ! git -C "$PROJECT_ROOT" rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
    echo "Error: Base branch does not exist locally: $BASE_BRANCH" >&2
    return 1
  fi

  mkdir -p "$(dirname "$WORKTREE_PATH")"

  if git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    git -C "$PROJECT_ROOT" worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
  else
    git -C "$PROJECT_ROOT" worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "$BASE_BRANCH"
  fi

  echo "✅ Created isolated upgrade worktree: $WORKTREE_PATH"
}

prepare_preview() {
  UPGRADE_STAGING="$WORKTREE_PATH/.upgrade-template"
  TEMPLATE_DIR="$UPGRADE_STAGING/latest"
  DIFF_FILE="$UPGRADE_STAGING/upgrade-preview.diff"

  rm -rf "$TEMPLATE_DIR"
  mkdir -p "$UPGRADE_STAGING"

  echo "⬇️  Cloning template: $TEMPLATE_REPO"
  git clone --depth 1 "$TEMPLATE_REPO" "$TEMPLATE_DIR" >/dev/null

  if diff -ruN --exclude='.git' --exclude='.upgrade-template' "$TEMPLATE_DIR" "$WORKTREE_PATH" > "$DIFF_FILE"; then
    DIFF_HAS_CHANGES="false"
  else
    DIFF_HAS_CHANGES="true"
  fi

  echo "✅ Upgrade preview ready"
  echo "   Worktree: $WORKTREE_PATH"
  echo "   Template: $TEMPLATE_REPO"
  echo "   Diff file: $DIFF_FILE"
  if [ "$DIFF_HAS_CHANGES" = "true" ]; then
    echo ""
    echo "Preview (first 120 lines):"
    head -n 120 "$DIFF_FILE"
  else
    echo "   No differences detected between template and worktree."
  fi
}

apply_template() {
  if [ "$DIFF_HAS_CHANGES" != "true" ]; then
    echo "ℹ️ Nothing to apply."
    return 0
  fi

  if [ "$ASSUME_YES" != "true" ]; then
    echo ""
    echo "Apply template files into the isolated worktree now? Type 'yes' to continue:"
    local confirmation
    read -r confirmation
    if [ "$confirmation" != "yes" ]; then
      echo "Cancelled apply. Preview artifacts remain in $UPGRADE_STAGING/."
      return 0
    fi
  fi

  if ! command -v rsync >/dev/null 2>&1; then
    echo "Error: rsync is required for --apply but is not installed." >&2
    return 1
  fi

  rsync -a --delete \
    --exclude '.git' \
    --exclude '.upgrade-template' \
    "$TEMPLATE_DIR"/ "$WORKTREE_PATH"/

  echo "✅ Applied template files in isolated worktree."
  echo "   Review with: git -C \"$WORKTREE_PATH\" status --short"
}

assert_root_unchanged() {
  local root_status_after
  root_status_after="$(git -C "$PROJECT_ROOT" status --short || true)"

  if [ "$root_status_after" != "$ROOT_STATUS_BEFORE" ]; then
    echo "Error: Active project working tree changed during upgrade workflow." >&2
    echo "Before:" >&2
    printf '%s\n' "$ROOT_STATUS_BEFORE" >&2
    echo "After:" >&2
    printf '%s\n' "$root_status_after" >&2
    return 1
  fi

  echo "✅ Active project tree remained unchanged (status snapshot matched)."
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    --template-repo)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Error: --template-repo requires a value" >&2
        usage >&2
        exit 1
      fi
      TEMPLATE_REPO="$1"
      shift
      ;;
    --base-branch)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Error: --base-branch requires a value" >&2
        usage >&2
        exit 1
      fi
      BASE_BRANCH="$1"
      shift
      ;;
    --worktree-path)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Error: --worktree-path requires a value" >&2
        usage >&2
        exit 1
      fi
      WORKTREE_PATH="$1"
      shift
      ;;
    --branch-name)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Error: --branch-name requires a value" >&2
        usage >&2
        exit 1
      fi
      BRANCH_NAME="$1"
      shift
      ;;
    --command-name)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Error: --command-name requires a value" >&2
        usage >&2
        exit 1
      fi
      COMMAND_NAME="$1"
      shift
      ;;
    --check-only)
      CHECK_ONLY="true"
      shift
      ;;
    --apply)
      APPLY="true"
      shift
      ;;
    --yes)
      ASSUME_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$ASSUME_YES" = "true" ] && [ "$APPLY" != "true" ]; then
  echo "Error: --yes can only be used with --apply" >&2
  exit 1
fi

check_command_conflicts "$COMMAND_NAME"

if [ "$CHECK_ONLY" = "true" ]; then
  echo "Preflight check-only mode complete."
  exit 0
fi

resolve_template_repo
ensure_upgrade_worktree
prepare_preview

if [ "$APPLY" = "true" ]; then
  apply_template
else
  echo ""
  echo "Preview-only mode. Re-run with --apply after reviewing $DIFF_FILE."
fi

assert_root_unchanged

echo ""
echo "Next steps:"
echo "  1. Inspect diff: $DIFF_FILE"
echo "  2. If ready, run: ./scripts/upgrade.sh --apply --template-repo \"$TEMPLATE_REPO\""
echo "  3. Validate manifests/docs: jq . .requirement-manifest.json && jq . .worktree-manifest.json && bash scripts/regenerate-docs.sh"