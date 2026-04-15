# Review follow-up: replace bc with portable arithmetic in compact-context.sh

**ID**: REQ-1776235658  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-15T06:47:38Z  

## Description

Source: code-review REQ-1776233067. Severity: MEDIUM. Evidence: scripts/compact-context.sh uses bc for floating-point multiplication (CONTEXT_WINDOW_LIMIT * COMPACTION_THRESHOLD). The bc command is not available in all minimal environments and will cause script failure. Required outcome: replace bc with awk or shell integer arithmetic so the script works on systems without bc installed.

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
