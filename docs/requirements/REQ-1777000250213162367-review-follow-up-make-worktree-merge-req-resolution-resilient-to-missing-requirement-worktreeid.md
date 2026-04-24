# Review follow-up: make worktree-merge REQ resolution resilient to missing requirement.worktreeId

**ID**: REQ-1777000250213162367  
**Status**: CODE_REVIEW  
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


## Development Plan

1. Update `scripts/worktree-merge.sh` REQ-ID resolver so missing or stale `requirement.worktreeId` does not fail immediately.
2. Implement a two-phase lookup in `scripts/worktree-merge.sh`: first try ACTIVE mapping by `worktreeId`/branch/id, then fallback to ACTIVE mapping by `requirementIds` containing the target REQ.
3. Standardize diagnostics in `scripts/worktree-merge.sh` for each failure mode (`unknown REQ`, `no ACTIVE mapping after both lookups`, `resolved mapping missing branch`).
4. Add or update regression coverage in `scripts/check-worktree-merge-unmapped-force.sh` (or adjacent worktree-merge checks) to include the missing-`worktreeId` fallback scenario.
5. Validate behavior with direct script runs (`./scripts/worktree-merge.sh REQ-...`) for success and failure paths, then run `./scripts/regenerate-docs.sh` if generated docs are affected.

**Last updated**: 2026-04-24T03:19:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777000250213162367-review-follow-up-make-worktree-merge-req-resolution-resilient-to-missing-requirement-worktreeid
* **Branch**: feature/REQ-1777000250213162367-review-follow-up-make-worktree-merge-req-resolution-resilient-to-missing-requirement-worktreeid
* **Merged**: No
* **Deployed**: No
