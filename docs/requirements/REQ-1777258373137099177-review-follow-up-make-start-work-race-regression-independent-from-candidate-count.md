# Review follow-up: make start-work race regression independent from candidate count

**ID**: REQ-1777258373137099177  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-27T02:52:53Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/check-start-work-clean.sh defaults RACE_REQ to SUCCESS_REQ and executes a successful start-work before the race section, so repositories with only two PROPOSED/BACKLOG candidates can cause both race invocations to fail and produce a false negative. Required outcome: make the race test always use a fresh requirement not consumed by earlier steps, or explicitly require at least three candidates before running the race assertion.

## Success Criteria

- [x] Race validation in `scripts/check-start-work-clean.sh` uses a dedicated requirement that is not consumed by the earlier success-path `start-work` invocation.
- [x] Candidate-count handling is explicit: race check runs only when a third candidate exists, otherwise it is skipped with an informational message.
- [x] Regression script still passes end-to-end (`bash scripts/check-start-work-clean.sh`) with lock-cleanup and idempotence checks intact.

## Technical Notes

- Added `RACE_REQ` selection from `CANDIDATE_REQS[2]` when available.
- Added conditional race block that launches two concurrent `start-work` attempts against `RACE_REQ` and asserts exactly one succeeds.
- Added fallback behavior to skip race assertion when fewer than three eligible candidates are available, preventing false negatives caused by candidate reuse.


## Development Plan

1. Update candidate selection in `scripts/check-start-work-clean.sh` so the race/assertion path uses a dedicated requirement ID that is not consumed by the earlier success-path `start-work` invocation.
2. Add/adjust guard logic in `scripts/check-start-work-clean.sh` to enforce the minimum candidate count needed by the revised flow (for example, fail fast when there are not enough PROPOSED/BACKLOG items for both success and race checks).
3. Re-run the regression check with `bash scripts/check-start-work-clean.sh` and confirm the race section remains valid regardless of initial candidate ordering/count edge cases.
4. Run `bash scripts/regenerate-docs.sh` to keep generated requirement/status documentation consistent after script changes.
5. Verify requirement linkage and lifecycle state with `bash scripts/show-requirement.sh REQ-1777258373137099177`, ensuring the requirement remains actionable and aligned with this fix scope.

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
