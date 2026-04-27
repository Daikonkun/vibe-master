# Add concurrency regression suite for parallel sessions

**ID**: REQ-1777257221458997051  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-27T02:33:41Z  

## Description

Introduce regression tests that simulate simultaneous /start-work, /work-on status advancement, and /worktree-merge execution across two REQs. Cover same-REQ race, cross-REQ parallel progression, and manifest/docs consistency under concurrent runs.

## Success Criteria

- [x] Add a dedicated concurrent workflow regression harness in `scripts/check-concurrent-workflows.sh` covering same-REQ `/start-work` race behavior, cross-REQ parallel progression, and lifecycle/docs consistency checks.
- [x] Validate concurrent manifest lock integrity with `bash scripts/check-manifest-lock-race.sh` after introducing the new regression harness.
- [x] Confirm generated docs stay synchronized with manifest-backed state after concurrent workflow exercise using `bash scripts/check-docs-sync.sh`.

## Technical Notes

- Added `scripts/check-concurrent-workflows.sh` as an isolated snapshot-based regression suite that:
   - clones the repository tree (excluding `.git`) into a temporary test repo,
   - executes a same-REQ dual `/start-work` race and asserts exactly one success,
   - runs cross-REQ concurrent `/start-work` and concurrent `CODE_REVIEW` advancement,
   - exercises `scripts/worktree-merge.sh` end-to-end and validates lifecycle/worktree invariants,
   - verifies docs/manifests stay structurally consistent.
- Added portability guard for macOS shell environments by avoiding `mapfile` and using a `while read` candidate collector.
- Added deterministic fixture seeding when fewer than three `PROPOSED/BACKLOG` requirements are available in the isolated snapshot to keep regression coverage stable.
- Validation run completed successfully:
   - `bash scripts/check-concurrent-workflows.sh`
   - `bash scripts/check-manifest-lock-race.sh`
   - `bash scripts/check-docs-sync.sh`


## Development Plan

1. Trace concurrency-sensitive paths in `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, and `scripts/worktree-merge.sh`, focusing on manifest-lock boundaries and docs regeneration side-effects.
2. Implement `scripts/check-concurrent-workflows.sh` to exercise same-REQ race handling, cross-REQ parallel progression, and merge/lifecycle consistency in an isolated test snapshot.
3. Ensure script portability and deterministic candidate selection by adding fixture seeding fallback and shell-compatible iteration.
4. Run validation suite:
   - `bash scripts/check-concurrent-workflows.sh`
   - `bash scripts/check-manifest-lock-race.sh`
   - `bash scripts/check-docs-sync.sh`
5. Promote lifecycle when all criteria are satisfied and tracked implementation evidence is present.

**Last updated**: 2026-04-27T04:18:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777257221458997051-add-concurrency-regression-suite-for-parallel-sessions
* **Branch**: feature/REQ-1777257221458997051-add-concurrency-regression-suite-for-parallel-sessions
* **Merged**: No
* **Deployed**: No
