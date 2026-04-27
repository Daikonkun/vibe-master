# Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review

**ID**: REQ-1777257357997508079  
**Status**: PROPOSED  
**Priority**: CRITICAL  
**Created**: 2026-04-27T02:35:58Z  

## Description

Define and implement end-to-end concurrency safety for simultaneous sessions running /start-work, /work-on, /worktree-merge, and /code-review. Cover manifest transaction boundaries, read-then-act race windows, docs regeneration serialization, and regression tests. This umbrella coordinates REQ-1777257209745418656, REQ-1777257214829301915, and REQ-1777257221458997051 and extends scope to /code-review side effects under parallel execution.

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
