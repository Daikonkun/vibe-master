# Review follow-up: enforce requirement-worktree lifecycle invariants

**ID**: REQ-1776415557577295081  
**Status**: CODE_REVIEW  
**Priority**: MEDIUM  
**Created**: 2026-04-17T08:45:57Z  

## Description

Source: code-review of delegated REQ flow. Severity: MEDIUM. Evidence: requirement REQ-1775718117 is DEPLOYED while its linked worktree entry remains ACTIVE, leaving lifecycle data inconsistent and cleanup ambiguous. Required outcome: add invariant checks that prevent terminal requirements from retaining ACTIVE worktrees, plus a repair path for existing inconsistent records.

## Success Criteria

- [x] Terminal transitions are blocked when a requirement still links to an `ACTIVE` worktree (including missing/misaligned worktree linkage drift checks).
- [x] A deterministic repair path exists to reconcile terminal-requirement/active-worktree drift in manifest data.
- [x] Regression coverage verifies both invariant enforcement and reconciliation behavior.

## Technical Notes

- Added `with_manifest_locks` to `scripts/_manifest-lock.sh` to acquire two manifest locks in deterministic path order for cross-manifest operations.
- Refactored `scripts/update-requirement-status.sh` to perform status updates inside lock-protected transactions and enforce terminal lifecycle invariants against `.worktree-manifest.json`.
- Added `scripts/reconcile-lifecycle-invariants.sh` with check/apply modes to repair legacy drift (`MERGED`/`DEPLOYED` + `ACTIVE` => `MERGED`; `CANCELLED` + `ACTIVE` => `ABANDONED`).
- Added `scripts/check-requirement-worktree-lifecycle.sh` regression coverage for invariant-block + repair-path behavior.
- Validated on real data by reconciling `REQ-1775718117` drift in branch manifests and by running the new regression script successfully.


## Development Plan

1. Add a lifecycle invariant check in `scripts/update-requirement-status.sh` so transitions to terminal statuses (`MERGED`, `DEPLOYED`, `CANCELLED`) cannot leave a linked worktree in `ACTIVE` state.
2. Reuse/extend manifest-safe helpers in `scripts/_manifest-lock.sh` and update `scripts/update-requirement-status.sh` to read `.worktree-manifest.json` and enforce cross-manifest requirement/worktree consistency under lock.
3. Implement a repair path for existing inconsistent data by adding a targeted reconciliation command in `scripts/upgrade.sh` (or a dedicated helper script) that scans `.requirement-manifest.json` + `.worktree-manifest.json` and resolves terminal-requirement/active-worktree mismatches deterministically.
4. Add regression coverage in shell checks (new or extended script under `scripts/check-*.sh`) that reproduces the `REQ-1775718117`-style inconsistency and asserts the invariant now blocks or repairs it.
5. Validate end-to-end with `./scripts/regenerate-docs.sh`, `./scripts/show-requirement.sh REQ-1776415557577295081`, and lifecycle-focused checks to confirm status/worktree metadata remain synchronized.

**Last updated**: 2026-04-20T10:09:18Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants
* **Branch**: feature/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants
* **Merged**: No
* **Deployed**: No
