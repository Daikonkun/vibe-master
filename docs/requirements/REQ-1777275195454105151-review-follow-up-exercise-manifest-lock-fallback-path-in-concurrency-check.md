# Review follow-up: exercise manifest lock fallback path in concurrency check

**ID**: REQ-1777275195454105151  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-27T07:33:15Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/check-concurrent-workflows.sh lines 323-349 added concurrent docs regeneration and stale *.lock.d checks, but scripts/_manifest-lock.sh only uses the mkdir fallback when flock is unavailable or MANIFEST_LOCK_FORCE_MKDIR=1; on this environment command -v flock resolves /opt/homebrew/bin/flock, so the new fallback-artifact assertion does not exercise the fallback path it claims to protect. Required outcome: update the regression to force MANIFEST_LOCK_FORCE_MKDIR=1 for the docs-regeneration fallback-artifact scenario, or add an equivalent dedicated fallback-mode test that fails on stale *.lock.d artifacts.

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
