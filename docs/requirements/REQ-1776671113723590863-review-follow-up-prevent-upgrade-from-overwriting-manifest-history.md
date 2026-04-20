# Review follow-up: prevent /upgrade from overwriting manifest history

**ID**: REQ-1776671113723590863  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-20T07:45:13Z  

## Description

Source: code-review of REQ-1776670068095886474. Severity: HIGH. Evidence: scripts/upgrade.sh applies template files using rsync --delete while excluding only .git and .upgrade-template, which allows template .requirement-manifest.json and .worktree-manifest.json to overwrite project requirement/worktree history in the upgrade worktree before merge. README's Replace vs Merge Guide says these manifests must be merged, not replaced. Required outcome: update /upgrade apply behavior to preserve manifest data (exclude manifest files from blanket replace and provide explicit merge path), and add a regression check that verifies manifest records survive upgrade apply.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history.md`.
   - **Summary**: Source: code-review of REQ-1776670068095886474. Severity: HIGH. Evidence: script
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776671113723590863` and verify success criteria are met.

**Last updated**: 2026-04-20T07:54:06Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Branch**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Merged**: No
* **Deployed**: No
