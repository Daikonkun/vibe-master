# Review follow-up: make worktree-merge atomic across merge and cleanup failures

**ID**: REQ-1777018133258390308  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-24T08:08:53Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/worktree-merge.sh merges into base before cleanup/manifest updates (merge at line ~226), then exits on cleanup failures such as worktree remove or branch delete errors (lines ~235-248), which can leave merge committed while requirement/worktree manifests and docs are not updated. Required outcome: make /worktree-merge transactional/fail-safe so post-merge cleanup failures cannot leave lifecycle manifests stale; either preflight cleanup blockers before merge, or persist/commit manifest status updates and clear recovery instructions before exiting.

## Success Criteria

- [x] `scripts/worktree-merge.sh` keeps the merge-first approach and performs merge into base before lifecycle cleanup.
- [x] If post-merge cleanup fails (e.g., worktree removal or branch deletion), the script still writes and commits manifest/doc reconciliation state in the same run.
- [x] Failure output includes clear recovery guidance without leaving requirement/worktree lifecycle state stale.

## Technical Notes

- Decision (2026-04-24): adopt **merge-first with guaranteed post-merge reconciliation commit**.
- Implement an explicit post-merge reconciliation path that is executed regardless of cleanup success.
- Preserve strict error visibility, but prevent partial lifecycle updates after a successful merge.

## Development Plan

1. Inspect merge and cleanup flow in `scripts/worktree-merge.sh`, then identify all post-merge failure points (`git worktree remove`, branch deletion, and manifest/doc updates) that can leave lifecycle state stale.
2. Implement a guaranteed post-merge reconciliation path in `scripts/worktree-merge.sh` so requirement/worktree manifests and generated docs are updated and committed even if cleanup operations fail.
3. Ensure failure messaging in `scripts/worktree-merge.sh` includes explicit recovery instructions (exact follow-up command(s) and expected state) while still surfacing the original cleanup error.
4. Regenerate project documentation with `./scripts/regenerate-docs.sh` and verify affected outputs in `docs/STATUS.md` and `REQUIREMENTS.md` remain consistent with manifest state.
5. Validate end-to-end behavior with `./scripts/check-requirement-worktree-lifecycle.sh` and `./scripts/show-requirement.sh REQ-1777018133258390308`.

**Last updated**: 2026-04-24T08:26:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777018133258390308-review-follow-up-make-worktree-merge-atomic-across-merge-and-cleanup-failures
* **Branch**: feature/REQ-1777018133258390308-review-follow-up-make-worktree-merge-atomic-across-merge-and-cleanup-failures
* **Merged**: No
* **Deployed**: No
