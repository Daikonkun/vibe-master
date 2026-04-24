# Review follow-up: make worktree-merge atomic across merge and cleanup failures

**ID**: REQ-1777018133258390308  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-24T08:08:53Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/worktree-merge.sh merges into base before cleanup/manifest updates (merge at line ~226), then exits on cleanup failures such as worktree remove or branch delete errors (lines ~235-248), which can leave merge committed while requirement/worktree manifests and docs are not updated. Required outcome: make /worktree-merge transactional/fail-safe so post-merge cleanup failures cannot leave lifecycle manifests stale; either preflight cleanup blockers before merge, or persist/commit manifest status updates and clear recovery instructions before exiting.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
