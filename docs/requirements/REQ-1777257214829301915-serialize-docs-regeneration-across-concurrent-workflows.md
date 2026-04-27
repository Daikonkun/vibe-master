# Serialize docs regeneration across concurrent workflows

**ID**: REQ-1777257214829301915  
**Status**: DEPLOYED  
**Priority**: HIGH  
**Created**: 2026-04-27T02:33:34Z  

## Description

Add lock/serialization around scripts/regenerate-docs.sh and callers so concurrent sessions do not race-write REQUIREMENTS.md and docs/*.md. Ensure deterministic outputs and safe retries when two sessions run status/work-on/merge concurrently.

## Success Criteria

- [x] `scripts/regenerate-docs.sh` executes inside a lock-protected critical section shared with manifest writers (`with_manifest_locks`), preventing concurrent doc-write races.
- [x] Existing callers (`scripts/status.sh`, `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, `scripts/worktree-merge.sh`, and related wrappers) continue to use `scripts/regenerate-docs.sh` and therefore inherit serialized regeneration without caller-side behavioral drift.
- [x] Determinism and lock behavior are validated via regression checks (`scripts/check-docs-sync.sh` and `scripts/check-manifest-lock-race.sh`) after the serialization change.

## Technical Notes

- Implementation keeps all doc-output writes inside `regenerate_docs_locked()` and invokes it through `with_manifest_locks "$REQ_MANIFEST" "$WORKTREE_MANIFEST"`.
- Lock ordering is delegated to `scripts/_manifest-lock.sh` (`with_manifest_locks`) to avoid lock inversion and preserve existing flock/mkdir fallback semantics.
- `set -euo pipefail` was applied in `scripts/regenerate-docs.sh` for stricter failure propagation in concurrent runs.

## Development Plan

1. Inspect all doc regeneration entry points (`scripts/status.sh`, `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, `scripts/worktree-merge.sh`) and confirm they route through `scripts/regenerate-docs.sh`.
2. Introduce a lock-scoped wrapper in `scripts/regenerate-docs.sh` so generation executes under shared requirement/worktree manifest locks.
3. Preserve generated output semantics (`REQUIREMENTS.md`, `docs/STATUS.md`, `docs/ROADMAP.md`, `docs/DEPENDENCIES.md`, and spec status sync) while moving logic under the lock wrapper.
4. Run deterministic/regression checks: `bash scripts/regenerate-docs.sh`, `bash scripts/check-docs-sync.sh`, `bash scripts/check-manifest-lock-race.sh 20`.
5. Update this spec with completion evidence and promote lifecycle when no-op evidence guard is satisfied.

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: Yes
* **Deployed**: Yes
