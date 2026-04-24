# Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings

**ID**: REQ-1777001176788056212  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-24T03:26:16Z  

## Description

Source: code-review of REQ-1777000250213162367. Severity: HIGH. Evidence: scripts/worktree-merge.sh resolves REQ-ID lookups with jq pipelines ending in head -1, so if manifest drift yields multiple ACTIVE worktrees linked to the same REQ (by stale worktreeId or duplicate requirementIds), the script silently picks one branch instead of failing. Required outcome: detect and reject ambiguous ACTIVE matches for REQ-ID resolution with explicit diagnostics listing conflicting worktree ids/branches, and add regression coverage for duplicate-match scenarios.

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
