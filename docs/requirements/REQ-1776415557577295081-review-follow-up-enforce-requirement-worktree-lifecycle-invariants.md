# Review follow-up: enforce requirement-worktree lifecycle invariants

**ID**: REQ-1776415557577295081  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T08:45:57Z  

## Description

Source: code-review of delegated REQ flow. Severity: MEDIUM. Evidence: requirement REQ-1775718117 is DEPLOYED while its linked worktree entry remains ACTIVE, leaving lifecycle data inconsistent and cleanup ambiguous. Required outcome: add invariant checks that prevent terminal requirements from retaining ACTIVE worktrees, plus a repair path for existing inconsistent records.

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
