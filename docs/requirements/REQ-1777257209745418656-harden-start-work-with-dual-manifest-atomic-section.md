# Harden start-work with dual-manifest atomic section

**ID**: REQ-1777257209745418656  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
