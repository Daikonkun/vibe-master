# Review follow-up: harden manifest lock helper critical section and portability

**ID**: REQ-1776395706  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-17T03:15:06Z  

## Description

Source: code-review of REQ-1776394634. Severity: HIGH. Evidence: scripts/_manifest-lock.sh currently releases flock before mv in jq_update_manifest_locked, allowing lost updates under concurrent writers; it also hard-fails when flock is unavailable on macOS by default. Required outcome: (1) hold lock from read through atomic rename for each manifest update, (2) provide a macOS-compatible locking path or dependency bootstrap guidance that is enforced before mutating workflows, and (3) add a regression check for concurrent manifest writers.

## Success Criteria

- [x] `jq_update_manifest_locked` keeps a single lock held across read, transform, and atomic rename for each manifest write.
- [x] Manifest locking works on macOS even when `flock` is unavailable by using a portable fallback path, and dependency guidance remains available via `scripts/bootstrap-deps.sh`.
- [x] A concurrent-writer regression check exists and passes for both lock backends (flock and mkdir fallback).

## Technical Notes

- Refactored lock logic in `scripts/_manifest-lock.sh` so `jq_update_manifest_locked` executes the full jq+mv sequence inside `with_manifest_lock`, preventing lock window splits.
- Added lock backend selection with `manifest_lock_supports_flock` and a portable directory lock fallback (`mkdir` lock directory) for environments without `flock`.
- Added bounded wait/retry in `manifest_lock_wait_for_directory` with actionable install guidance when lock contention exceeds timeout.
- Added `scripts/check-manifest-lock-race.sh` to exercise concurrent manifest writes and assert zero lost updates.
- Validation run results:
	- `bash scripts/check-manifest-lock-race.sh 30` -> PASS (flock + mkdir backends)
	- `MANIFEST_LOCK_FORCE_MKDIR=1 bash scripts/check-manifest-lock-race.sh 30` -> PASS (mkdir backend)
	- `bash scripts/bootstrap-deps.sh` -> PASS (`flock` detected)

## Development Plan

1. Inspect `scripts/_manifest-lock.sh` and all manifest-mutating callers to map current lock critical sections and portability behavior.
2. Refactor the lock helper so every `jq_update_manifest_locked` call keeps lock acquisition through atomic `mv` in one uninterrupted critical section.
3. Add a portable lock fallback for hosts lacking `flock`, while preserving dependency guidance through `scripts/bootstrap-deps.sh`.
4. Add a concurrent-writer regression script (`scripts/check-manifest-lock-race.sh`) that verifies no lost updates under parallel writes.
5. Validate both normal and forced-fallback lock backends, then sync success criteria and technical notes with command evidence.

**Last updated**: 2026-04-17T07:01:09Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776395706-review-follow-up-harden-manifest-lock-helper-critical-section-and-portability
* **Branch**: feature/REQ-1776395706-review-follow-up-harden-manifest-lock-helper-critical-section-and-portability
* **Merged**: No
* **Deployed**: No
