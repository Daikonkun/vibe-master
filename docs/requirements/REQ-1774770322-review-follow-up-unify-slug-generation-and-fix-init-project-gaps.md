# Review follow-up: unify slug generation and fix init-project gaps

**ID**: REQ-1774770322  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-03-29T07:45:22Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: (1) create-requirement.sh slug generation does not lowercase or collapse hyphens, while start-work.sh does — causing mismatched spec filenames vs branch names. (2) init-project.sh never creates docs/requirements/ directory or an initial git commit despite comments suggesting it should. (3) init-project.sh sed substitution is vulnerable to special characters in project name — should use jq --arg instead. (4) REQ-1774630000 manifest entry has updatedAt before createdAt. Required outcome: unify slug logic, complete init-project.sh setup, fix manifest timestamp, and add timestamp validation.

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
