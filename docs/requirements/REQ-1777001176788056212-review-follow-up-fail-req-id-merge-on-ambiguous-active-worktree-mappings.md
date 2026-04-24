# Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings

**ID**: REQ-1777001176788056212  
**Status**: CODE_REVIEW  
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


## Development Plan

1. Refactor REQ-ID lookup in `scripts/worktree-merge.sh` to collect all ACTIVE matches for both primary (`worktreeId`/branch/id) and fallback (`requirementIds`) resolution stages instead of piping directly to `head -1`.
2. Add ambiguity detection in `scripts/worktree-merge.sh`: when more than one ACTIVE candidate matches, fail with explicit diagnostics listing candidate worktree ids and branches.
3. Keep existing fallback behavior intact for single-match cases, including stale-`worktreeId` warning path and existing unknown-REQ/not-found error semantics.
4. Add regression coverage in a new check script (or extend `scripts/check-worktree-merge-req-fallback.sh`) to simulate duplicate ACTIVE mappings and assert the command fails with ambiguity diagnostics.
5. Validate by running worktree-merge regression scripts and targeted REQ-ID resolution checks, then regenerate docs only if generated artifacts are affected.

**Last updated**: 2026-04-24T03:35:16Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Branch**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Merged**: No
* **Deployed**: No
