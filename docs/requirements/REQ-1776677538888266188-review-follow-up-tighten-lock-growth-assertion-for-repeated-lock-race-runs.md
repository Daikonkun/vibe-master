# Review follow-up: tighten lock-growth assertion for repeated lock-race runs

**ID**: REQ-1776677538888266188  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-20T09:32:18Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/check-manifest-lock-race.sh allows FINAL_LOCK_COUNT up to INITIAL_LOCK_COUNT + 1, so a leak of one new lock file per run still passes each run and repeated-run accumulation can evade in-script detection. Required outcome: update the lock-growth assertion to fail on any net increase in the controlled test lock root across a single run, and add regression coverage or explicit checks that prove repeated executions do not accumulate lock artifacts.

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
