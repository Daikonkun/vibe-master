# Review follow-up: make start-work race regression independent from candidate count

**ID**: REQ-1777258373137099177  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
