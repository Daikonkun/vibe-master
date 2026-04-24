# Review follow-up: make worktree-merge REQ resolution resilient to missing requirement.worktreeId

**ID**: REQ-1777000250213162367  
**Status**: DEPLOYED  
**Priority**: HIGH  
**Created**: 2026-04-24T03:10:50Z  

## Description

Source: code-review of REQ-1776999531888370737. Severity: HIGH. Evidence: scripts/worktree-merge.sh now accepts REQ IDs but exits immediately when .requirement-manifest.json has no worktreeId for that REQ, before attempting resolution via .worktree-manifest.json requirementIds linkage. This can block REQ-ID merges when manifests drift or legacy records omit worktreeId. Required outcome: keep REQ-ID support but fall back to ACTIVE worktree lookup by requirementIds when worktreeId is missing/stale, and only fail after both lookup paths are exhausted with explicit diagnostics.

## Success Criteria

- [x] `/worktree-merge REQ-...` no longer fails immediately when `requirement.worktreeId` is missing; it attempts ACTIVE lookup by `requirementIds`.
- [x] When `requirement.worktreeId` is present but stale/unmatched, the script warns and falls back to ACTIVE lookup by `requirementIds`.
- [x] If both lookup paths fail, the script exits non-zero with explicit diagnostics describing which lookups were attempted.
- [x] Existing REQ-ID behavior for unknown requirements remains unchanged (`Requirement not found`).
- [x] Regression coverage exists for the missing/stale `worktreeId` fallback path.

## Technical Notes

- Primary change is in `scripts/worktree-merge.sh` REQ-ID resolution branch before merge preflight checks.
- Resolution order: (1) try ACTIVE worktree by `worktreeId`/branch/id when `requirement.worktreeId` exists, (2) fallback to ACTIVE worktree matching `requirementIds` containing the target REQ.
- Emit clear failure messages for two distinct cases: missing `worktreeId` plus missing fallback mapping, and stale `worktreeId` plus missing fallback mapping.
- Add regression in `scripts/check-worktree-merge-req-fallback.sh` to validate stale/missing `worktreeId` fallback and guard against reintroducing hard-fail behavior.
- Preserve existing lifecycle and merge safeguards after branch resolution (clean tree and CODE_REVIEW gate behavior).

## Development Plan

1. Refactor REQ-ID resolution in `scripts/worktree-merge.sh` to separate primary `worktreeId` lookup from fallback `requirementIds` lookup. ✅
2. Add explicit warning and failure diagnostics for stale/missing `worktreeId` cases while preserving unknown-REQ error behavior. ✅
3. Create a regression script `scripts/check-worktree-merge-req-fallback.sh` covering stale/missing `worktreeId` fallback behavior. ✅
4. Run regression checks and targeted command validations for REQ-ID resolution behavior. ✅
5. Mark success criteria and advance requirement to `CODE_REVIEW` once evidence checks pass. ✅

**Last updated**: 2026-04-24T03:19:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777000250213162367-review-follow-up-make-worktree-merge-req-resolution-resilient-to-missing-requirement-worktreeid
* **Branch**: feature/REQ-1777000250213162367-review-follow-up-make-worktree-merge-req-resolution-resilient-to-missing-requirement-worktreeid
* **Merged**: Yes
* **Deployed**: Yes
