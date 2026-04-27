# Review follow-up: make start-work race regression independent from candidate count

**ID**: REQ-1777258373137099177  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
