# Review follow-up: enforce requirement-worktree lifecycle invariants

**ID**: REQ-1776415557577295081  
**Status**: IN_PROGRESS  
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


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants.md`.
   - **Summary**: Source: code-review of delegated REQ flow. Severity: MEDIUM. Evidence: requireme
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776415557577295081` and verify success criteria are met.

**Last updated**: 2026-04-20T09:55:50Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants
* **Branch**: feature/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants
* **Merged**: No
* **Deployed**: No
