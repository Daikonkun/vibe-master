# Isolate worktree-merge git side-effects from concurrent agents

**ID**: REQ-1776394648  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-17T02:57:28Z  

## Description

Source: code-review of agent concurrency flow. Severity: HIGH. Evidence: worktree-merge.sh runs git add -A (line 33) which stages ALL dirty files including other agents in-flight edits, then commits them as auto-commit manifest and docs. It also stashes remaining untracked changes (line 42). When an unmapped branch is merged (no worktree-manifest entry), requirement status updates are silently skipped (lines 60-92). Required outcome: (1) Replace git add -A with explicit file list matching only the current merge operation files. (2) Refuse to stash if unrelated dirty files exist — surface an error instead. (3) When branch is not mapped in worktree manifest, warn and require --force or explicit confirmation before proceeding. (4) Never auto-commit files that do not belong to the current merge operation.

## Success Criteria

- [x] `worktree-merge.sh` no longer runs `git add -A`; instead it stages only the explicit files it modifies (manifests, generated docs, and the specific spec files for linked REQ IDs)
- [x] If unrelated dirty files exist in the working tree, the script exits with a clear error message listing the unexpected dirty files, instead of auto-committing or stashing them
- [x] When the target branch has no entry in `.worktree-manifest.json`, the script prints a warning and exits non-zero unless `--force` is passed
- [x] The auto-stash behavior is removed entirely; the script requires a clean working tree (excluding its own manifest/doc writes) before proceeding
- [x] Merging an unmapped branch with `--force` still completes the git merge but logs that no requirement status was updated

## Technical Notes

- **Explicit staging**: Replace `git add -A` (line 33) with `git add .requirement-manifest.json .worktree-manifest.json REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/` — the same list already used at line 126.
- **Dirty-tree check**: After the auto-commit of manifest/docs, re-check `git status --porcelain`. If remaining dirty files exist, print them and `exit 1` instead of stashing. This forces the operator/agent to commit or stash manually.
- **Unmapped branch guard**: After `WORKTREE_PATH` and `REQ_IDS` lookups (lines 56-62), check if both are empty. If so, print warning + exit 1 unless `$FORCE` is set.
- **Backward compatibility**: Add a `--force` flag parser (similar to `update-requirement-status.sh`) to opt into the old permissive behavior for edge cases.
- **Affected file**: `scripts/worktree-merge.sh`.

## Development Plan

1. Review existing `scripts/worktree-merge.sh` merge flow and identify all git side-effect points (`git add -A`, auto-stash, and unmapped-branch continuation).
2. Add `--force` option parsing and enforce an active-worktree mapping guard so unmapped branches fail fast unless explicitly forced.
3. Replace broad staging with explicit, merge-owned staging: manifests, generated docs, and only linked `docs/requirements/REQ-*.md` files.
4. Remove auto-stash behavior and enforce clean-working-tree checks that print unexpected dirty files and exit non-zero.
5. Validate script syntax and invariants (`bash -n scripts/worktree-merge.sh`) and verify no `git add -A` or stash operations remain.

## Dependencies

None (can be implemented independently, but benefits from REQ-1776394634 locking infrastructure)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
