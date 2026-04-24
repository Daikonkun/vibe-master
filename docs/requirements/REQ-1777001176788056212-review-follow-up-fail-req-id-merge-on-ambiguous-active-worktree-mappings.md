# Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings

**ID**: REQ-1777001176788056212  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-24T03:26:16Z  

## Description

Source: code-review of REQ-1777000250213162367. Severity: HIGH. Evidence: scripts/worktree-merge.sh resolves REQ-ID lookups with jq pipelines ending in head -1, so if manifest drift yields multiple ACTIVE worktrees linked to the same REQ (by stale worktreeId or duplicate requirementIds), the script silently picks one branch instead of failing. Required outcome: detect and reject ambiguous ACTIVE matches for REQ-ID resolution with explicit diagnostics listing conflicting worktree ids/branches, and add regression coverage for duplicate-match scenarios.

## Success Criteria

- [x] If REQ-ID resolution yields multiple ACTIVE candidates (primary `worktreeId` lookup), `scripts/worktree-merge.sh` fails instead of choosing one arbitrarily.
- [x] If fallback `requirementIds` lookup yields multiple ACTIVE candidates, `scripts/worktree-merge.sh` fails and lists conflicting candidate ids/branches.
- [x] Diagnostics for ambiguous REQ-ID matches are explicit and include candidate worktree identifiers for operator recovery.
- [x] Single-candidate REQ-ID flows continue to work for stale-`worktreeId` fallback and existing forced-unmapped behavior.
- [x] Regression coverage exists for ambiguous ACTIVE mappings and all related checks pass.

## Technical Notes

- `scripts/worktree-merge.sh` now treats REQ-ID lookup as a cardinality-checked query in both stages: primary (`worktreeId`) and fallback (`requirementIds`).
- Ambiguity checks intentionally fail-fast before merge preflight so no branch checkout/merge side effects occur when mapping is inconsistent.
- Candidate reporting includes both worktree `id` and `branch` to make manifest repair straightforward.
- Implementation avoids bash-4-only builtins (`mapfile`) to remain compatible with macOS default bash.
- Added `scripts/check-worktree-merge-req-ambiguous.sh` and validated alongside existing `scripts/check-worktree-merge-req-fallback.sh` and `scripts/check-worktree-merge-unmapped-force.sh`.

## Development Plan

1. Refactor REQ-ID lookup in `scripts/worktree-merge.sh` to collect all ACTIVE matches for both primary (`worktreeId`/branch/id) and fallback (`requirementIds`) resolution stages instead of piping directly to `head -1`. ✅
2. Add ambiguity detection in `scripts/worktree-merge.sh`: when more than one ACTIVE candidate matches, fail with explicit diagnostics listing candidate worktree ids and branches. ✅
3. Keep existing fallback behavior intact for single-match cases, including stale-`worktreeId` warning path and existing unknown-REQ/not-found error semantics. ✅
4. Add regression coverage in a new check script (or extend `scripts/check-worktree-merge-req-fallback.sh`) to simulate duplicate ACTIVE mappings and assert the command fails with ambiguity diagnostics. ✅
5. Validate by running worktree-merge regression scripts and targeted REQ-ID resolution checks, then regenerate docs only if generated artifacts are affected. ✅

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Branch**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Merged**: No
* **Deployed**: No
