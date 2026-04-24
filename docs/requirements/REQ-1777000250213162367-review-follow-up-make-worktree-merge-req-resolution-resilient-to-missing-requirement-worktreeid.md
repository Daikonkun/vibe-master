# Review follow-up: make worktree-merge REQ resolution resilient to missing requirement.worktreeId

**ID**: REQ-1777000250213162367  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-24T03:10:50Z  

## Description

Source: code-review of REQ-1776999531888370737. Severity: HIGH. Evidence: scripts/worktree-merge.sh now accepts REQ IDs but exits immediately when .requirement-manifest.json has no worktreeId for that REQ, before attempting resolution via .worktree-manifest.json requirementIds linkage. This can block REQ-ID merges when manifests drift or legacy records omit worktreeId. Required outcome: keep REQ-ID support but fall back to ACTIVE worktree lookup by requirementIds when worktreeId is missing/stale, and only fail after both lookup paths are exhausted with explicit diagnostics.

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
