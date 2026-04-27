# Harden start-work with dual-manifest atomic section

**ID**: REQ-1777257209745418656  
**Status**: MERGED  
**Priority**: HIGH  
**Created**: 2026-04-27T02:33:29Z  

## Description

Refactor scripts/start-work.sh so requirement/worktree manifest validation and mutation run under one with_manifest_locks critical section. Prevent same-REQ concurrent bootstrap races, avoid partial writes between manifests, and add recovery-safe behavior when worktree create succeeds but manifest update fails.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Inspect current `scripts/start-work.sh` flow and identify where requirement/worktree manifest reads, validation, and writes happen today.
2. Refactor `scripts/start-work.sh` to execute requirement/worktree manifest validation + mutation inside one `with_manifest_locks` critical section, including failure handling when `git worktree add` succeeds but manifest update fails.
3. Reuse and/or extend shared lock helpers in `scripts/_manifest-lock.sh` so lock acquisition and release remain atomic and portable for both manifests.
4. Add/adjust regression coverage in `scripts/check-start-work-clean.sh` (and related lifecycle checks such as `scripts/check-requirement-worktree-lifecycle.sh` if needed) to assert no partial dual-manifest writes under concurrent starts.
5. Verify end-to-end behavior by running `scripts/start-work.sh REQ-1777257209745418656` in a clean test scenario, then `./scripts/status.sh` and `./scripts/show-requirement.sh REQ-1777257209745418656` to confirm `IN_PROGRESS` state and consistent worktree mapping.

**Last updated**: 2026-04-27T02:41:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section
* **Branch**: feature/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section
* **Merged**: Yes
* **Deployed**: No
