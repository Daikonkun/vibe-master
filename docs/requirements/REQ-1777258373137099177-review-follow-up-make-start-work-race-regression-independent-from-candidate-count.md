# Review follow-up: make start-work race regression independent from candidate count

**ID**: REQ-1777258373137099177  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-27T02:52:53Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/check-start-work-clean.sh defaults RACE_REQ to SUCCESS_REQ and executes a successful start-work before the race section, so repositories with only two PROPOSED/BACKLOG candidates can cause both race invocations to fail and produce a false negative. Required outcome: make the race test always use a fresh requirement not consumed by earlier steps, or explicitly require at least three candidates before running the race assertion.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777258373137099177-review-follow-up-make-start-work-race-regression-independent-from-candidate-count.md`.
   - **Summary**: Source: code-review. Severity: HIGH. Evidence: scripts/check-start-work-clean.sh
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777258373137099177` and verify success criteria are met.

**Last updated**: 2026-04-27T03:12:11Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777258373137099177-review-follow-up-make-start-work-race-regression-independent-from-candidate-count
* **Branch**: feature/REQ-1777258373137099177-review-follow-up-make-start-work-race-regression-independent-from-candidate-count
* **Merged**: No
* **Deployed**: No
