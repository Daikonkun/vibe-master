# Review follow-up: define true canonical manifest root for /work-on

**ID**: REQ-1776738115172246724  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-21T02:21:55Z  

## Description

Source: code-review of REQ-1776668089944983961. Severity: HIGH. Evidence: .github/prompts/work-on.prompt.md now says to resolve the canonical tracker root via git rev-parse --show-toplevel, but in a linked feature worktree this returns that worktree root (which may contain stale local manifests), not the tracker source-of-truth root. Required outcome: update /work-on instructions and checks to derive canonical manifest root independently of current worktree, then keep fallback resolution and diagnostics anchored to that canonical source.

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
