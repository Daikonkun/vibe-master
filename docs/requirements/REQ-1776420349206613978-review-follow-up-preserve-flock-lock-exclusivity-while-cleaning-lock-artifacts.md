# Review follow-up: preserve flock lock exclusivity while cleaning lock artifacts

**ID**: REQ-1776420349206613978  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-17T10:05:49Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/_manifest-lock.sh removes .lock files after flock-backed operations; waiting processes may still hold file descriptors to the previous inode while a new process recreates the lock path, allowing overlapping critical sections. Required outcome: preserve strict mutual exclusion while still avoiding stale lock artifacts, add a regression that covers waiter-plus-newcomer lock contention, and verify start-work remains clean.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts.md`.
   - **Summary**: Source: code-review. Severity: HIGH. Evidence: scripts/_manifest-lock.sh removes
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776420349206613978` and verify success criteria are met.

**Last updated**: 2026-04-20T03:38:35Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts
* **Branch**: feature/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts
* **Merged**: No
* **Deployed**: No
