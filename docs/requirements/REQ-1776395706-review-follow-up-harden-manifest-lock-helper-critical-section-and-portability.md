# Review follow-up: harden manifest lock helper critical section and portability

**ID**: REQ-1776395706  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-17T03:15:06Z  

## Description

Source: code-review of REQ-1776394634. Severity: HIGH. Evidence: scripts/_manifest-lock.sh currently releases flock before mv in jq_update_manifest_locked, allowing lost updates under concurrent writers; it also hard-fails when flock is unavailable on macOS by default. Required outcome: (1) hold lock from read through atomic rename for each manifest update, (2) provide a macOS-compatible locking path or dependency bootstrap guidance that is enforced before mutating workflows, and (3) add a regression check for concurrent manifest writers.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776395706-review-follow-up-harden-manifest-lock-helper-critical-section-and-portability.md`.
   - **Summary**: Source: code-review of REQ-1776394634. Severity: HIGH. Evidence: scripts/_manife
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776395706` and verify success criteria are met.

**Last updated**: 2026-04-17T06:52:11Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
