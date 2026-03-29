# Review follow-up: unify slug generation and fix init-project gaps

**ID**: REQ-1774770322  
**Status**: IN_PROGRESS  
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


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1774770322-review-follow-up-unify-slug-generation-and-fix-init-project-gaps.md`.
   - **Summary**: Source: code-review. Severity: MEDIUM. Evidence: (1) create-requirement.sh slug 
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1774770322` and verify success criteria are met.

**Last updated**: 2026-03-29T08:18:36Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
