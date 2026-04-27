# Harden start-work with dual-manifest atomic section

**ID**: REQ-1777257209745418656  
**Status**: IN_PROGRESS  
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

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section.md`.
   - **Summary**: Refactor scripts/start-work.sh so requirement/worktree manifest validation and m
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777257209745418656` and verify success criteria are met.

**Last updated**: 2026-04-27T02:38:26Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section
* **Branch**: feature/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section
* **Merged**: No
* **Deployed**: No
