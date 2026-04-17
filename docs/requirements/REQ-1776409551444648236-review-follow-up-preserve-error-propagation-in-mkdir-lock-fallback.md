# Review follow-up: preserve error propagation in mkdir lock fallback

**ID**: REQ-1776409551444648236  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-17T07:05:51Z  

## Description

Source: code-review of REQ-1776395706. Severity: HIGH. Evidence: scripts/_manifest-lock.sh uses 'if ! ""; then status=0; fi' in the mkdir fallback path, which captures the status of the negated condition instead of the wrapped command; fallback lock operations can incorrectly report success. Repro: under MANIFEST_LOCK_FORCE_MKDIR=1, with_manifest_lock on a command that exits 17 returns 0. Required outcome: preserve wrapped command exit status in fallback mode and add a regression assertion for non-zero propagation.

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
