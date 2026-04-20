#!/bin/bash
# Regression check: upgrade --apply must preserve requirement/worktree manifest history.

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/upgrade-manifest-history-check.XXXXXX")"
CHECK_ROOT="$TMP_ROOT/check"
TEMPLATE_REPO="$TMP_ROOT/template-github.com-source"
UPGRADE_WORKTREE="$TMP_ROOT/upgrade-worktree"

SEED_REQ_ID="REQ-9999999999000000001"
SEED_WORKTREE_ID="feature/REQ-9999999999000000001-upgrade-history-seed"
SEED_TIMESTAMP="2026-04-20T00:00:00Z"

REQ_COUNT_BEFORE="0"
WT_COUNT_BEFORE="0"

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

copy_repo_snapshot() {
  local src_root="$1"
  local dst_root="$2"

  mkdir -p "$dst_root"
  (
    cd "$src_root"
    tar -cf - --exclude='.git' .
  ) | tar -xf - -C "$dst_root"
}

init_git_repo() {
  local repo_root="$1"
  local user_name="$2"
  local user_email="$3"
  local commit_message="$4"

  git -C "$repo_root" init -b main >/dev/null
  git -C "$repo_root" config user.email "$user_email"
  git -C "$repo_root" config user.name "$user_name"
  git -C "$repo_root" add .
  git -C "$repo_root" commit -m "$commit_message" >/dev/null
}

seed_manifest_history() {
  local req_manifest="$CHECK_ROOT/.requirement-manifest.json"
  local wt_manifest="$CHECK_ROOT/.worktree-manifest.json"
  local req_tmp="$req_manifest.seed.tmp"
  local wt_tmp="$wt_manifest.seed.tmp"

  jq \
    --arg req_id "$SEED_REQ_ID" \
    --arg wt_id "$SEED_WORKTREE_ID" \
    --arg ts "$SEED_TIMESTAMP" \
    '.requirements += [{
      id: $req_id,
      name: "Upgrade history preservation seed",
      description: "Synthetic entry used by check-upgrade-manifest-history.sh",
      status: "IN_PROGRESS",
      priority: "LOW",
      createdAt: $ts,
      updatedAt: $ts,
      worktreeId: $wt_id,
      origin: "regression-check"
    }]' "$req_manifest" > "$req_tmp"
  mv "$req_tmp" "$req_manifest"

  jq \
    --arg wt_id "$SEED_WORKTREE_ID" \
    --arg req_id "$SEED_REQ_ID" \
    --arg wt_path "$CHECK_ROOT/seed-worktree" \
    --arg ts "$SEED_TIMESTAMP" \
    '.worktrees += [{
      id: $wt_id,
      path: $wt_path,
      branch: $wt_id,
      baseBranch: "main",
      requirementIds: [$req_id],
      createdAt: $ts,
      status: "ACTIVE"
    }]' "$wt_manifest" > "$wt_tmp"
  mv "$wt_tmp" "$wt_manifest"
}

create_template_with_stub_manifests() {
  copy_repo_snapshot "$CHECK_ROOT" "$TEMPLATE_REPO"

  cat > "$TEMPLATE_REPO/.requirement-manifest.json" << 'EOF'
{
  "$schema": ".requirement-manifest.schema.json",
  "version": "1.0",
  "projectName": "Template Project",
  "requirements": [],
  "requiresDeployment": true
}
EOF

  cat > "$TEMPLATE_REPO/.worktree-manifest.json" << 'EOF'
{
  "$schema": ".worktree-manifest.schema.json",
  "version": "1.0",
  "worktrees": []
}
EOF

  init_git_repo "$TEMPLATE_REPO" "Upgrade Template Check" "upgrade-template-check@example.com" "template snapshot"
}

assert_prereqs() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "FAIL: jq is required." >&2
    exit 1
  fi

  if ! command -v rsync >/dev/null 2>&1; then
    echo "FAIL: rsync is required." >&2
    exit 1
  fi
}

assert_history_preserved() {
  local req_manifest="$UPGRADE_WORKTREE/.requirement-manifest.json"
  local wt_manifest="$UPGRADE_WORKTREE/.worktree-manifest.json"
  local req_count_after
  local wt_count_after

  if [ ! -f "$req_manifest" ] || [ ! -f "$wt_manifest" ]; then
    echo "FAIL: upgrade output manifests are missing from $UPGRADE_WORKTREE." >&2
    exit 1
  fi

  req_count_after="$(jq -r '.requirements | length' "$req_manifest")"
  wt_count_after="$(jq -r '.worktrees | length' "$wt_manifest")"

  if [ "$req_count_after" -lt "$REQ_COUNT_BEFORE" ]; then
    echo "FAIL: requirement manifest history shrank after upgrade apply ($REQ_COUNT_BEFORE -> $req_count_after)." >&2
    exit 1
  fi

  if [ "$wt_count_after" -lt "$WT_COUNT_BEFORE" ]; then
    echo "FAIL: worktree manifest history shrank after upgrade apply ($WT_COUNT_BEFORE -> $wt_count_after)." >&2
    exit 1
  fi

  if ! jq -e --arg id "$SEED_REQ_ID" '.requirements[] | select(.id == $id)' "$req_manifest" >/dev/null; then
    echo "FAIL: seeded requirement history entry was lost after upgrade apply." >&2
    exit 1
  fi

  if ! jq -e --arg id "$SEED_WORKTREE_ID" '.worktrees[] | select(.id == $id)' "$wt_manifest" >/dev/null; then
    echo "FAIL: seeded worktree history entry was lost after upgrade apply." >&2
    exit 1
  fi

  echo "PASS: upgrade apply preserved manifest history ($REQ_COUNT_BEFORE/$WT_COUNT_BEFORE -> $req_count_after/$wt_count_after)."
}

assert_prereqs

copy_repo_snapshot "$PROJECT_ROOT" "$CHECK_ROOT"
init_git_repo "$CHECK_ROOT" "Upgrade Manifest History Check" "upgrade-manifest-history-check@example.com" "baseline snapshot"

seed_manifest_history

git -C "$CHECK_ROOT" add .requirement-manifest.json .worktree-manifest.json
git -C "$CHECK_ROOT" commit -m "seed manifest history" >/dev/null

REQ_COUNT_BEFORE="$(jq -r '.requirements | length' "$CHECK_ROOT/.requirement-manifest.json")"
WT_COUNT_BEFORE="$(jq -r '.worktrees | length' "$CHECK_ROOT/.worktree-manifest.json")"

create_template_with_stub_manifests

(
  cd "$CHECK_ROOT"
  bash scripts/upgrade.sh \
    --template-repo "$TEMPLATE_REPO" \
    --worktree-path "$UPGRADE_WORKTREE" \
    --branch-name "chore/upgrade-manifest-history-check" \
    --apply \
    --yes >/dev/null
)

assert_history_preserved
