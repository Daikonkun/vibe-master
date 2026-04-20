# Review follow-up: harden work-on no-op guard against manifest context drift

**ID**: REQ-1776668089944983961  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-20T06:54:49Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: MEDIUM. Evidence: .github/prompts/work-on.prompt.md step 7 requires resolving active worktree path from .worktree-manifest.json, but linked feature worktrees can have stale local manifests with no self-entry, causing guard resolution failures in feature-worktree execution contexts. Required outcome: define canonical manifest lookup for /work-on and add a fallback resolver based on current repository path/branch when local worktree mapping is absent, with clear diagnostics.

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
