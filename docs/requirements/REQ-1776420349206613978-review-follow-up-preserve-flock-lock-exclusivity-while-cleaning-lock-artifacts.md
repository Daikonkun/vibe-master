# Review follow-up: preserve flock lock exclusivity while cleaning lock artifacts

**ID**: REQ-1776420349206613978  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
