# Review follow-up: preserve flock lock exclusivity while cleaning lock artifacts

**ID**: REQ-1776420349206613978  
**Status**: DEPLOYED  
**Priority**: HIGH  
**Created**: 2026-04-17T10:05:49Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/_manifest-lock.sh removes .lock files after flock-backed operations; waiting processes may still hold file descriptors to the previous inode while a new process recreates the lock path, allowing overlapping critical sections. Required outcome: preserve strict mutual exclusion while still avoiding stale lock artifacts, add a regression that covers waiter-plus-newcomer lock contention, and verify start-work remains clean.

## Success Criteria

- [x] `scripts/_manifest-lock.sh` preserves flock mutual exclusion by using a stable lock-file inode and no longer deleting flock lock files after each critical section.
- [x] Regression coverage detects waiter-plus-newcomer contention overlap and passes via `bash scripts/check-manifest-lock-race.sh 30`.
- [x] Lock cleanup expectations remain satisfied with `bash scripts/check-start-work-clean.sh`, and forced fallback validation passes with `MANIFEST_LOCK_FORCE_MKDIR=1 bash scripts/check-manifest-lock-race.sh 30`.

## Technical Notes

- Updated `scripts/_manifest-lock.sh` to resolve deterministic lock paths outside repo root (`.git/.manifest-locks` when available, fallback to `${TMPDIR:-/tmp}/vibe-manifest-locks`), normalize manifest paths before hashing, and keep flock lock files persistent to avoid inode churn under contention.
- Updated mkdir fallback cleanup to remove only lock directories (`*.lock.d`) and removed root lock-file deletion patterns in `scripts/worktree-merge.sh` and `scripts/create-requirement.sh`.
- Added deterministic waiter/newcomer overlap regression in `scripts/check-manifest-lock-race.sh` (`assert_waiter_newcomer_exclusivity_flock`) to fail if a newcomer enters while a waiter still holds the lock.
- Validation evidence (run in feature worktree):
	- `bash scripts/check-manifest-lock-race.sh 30` -> PASS
	- `MANIFEST_LOCK_FORCE_MKDIR=1 bash scripts/check-manifest-lock-race.sh 30` -> PASS
	- `bash scripts/check-start-work-clean.sh` -> PASS


## Development Plan

1. Audit lock-file lifecycle in `scripts/_manifest-lock.sh`, focusing on `with_manifest_lock` and `manifest_lock_cleanup_artifacts`, and design a flock-path change that preserves a single lock inode during waiter contention.
2. Implement the exclusivity fix in `scripts/_manifest-lock.sh` so flock-backed critical sections cannot overlap when a waiter and a newcomer contend on the same manifest lock path.
3. Update lock-artifact cleanup call sites in `scripts/start-work.sh`, `scripts/worktree-merge.sh`, and `scripts/create-requirement.sh` as needed to keep repos clean without breaking flock mutual exclusion.
4. Add or extend regression coverage in `scripts/check-manifest-lock-race.sh` for waiter-plus-newcomer contention, and run `bash scripts/check-manifest-lock-race.sh 30` plus `MANIFEST_LOCK_FORCE_MKDIR=1 bash scripts/check-manifest-lock-race.sh 30`.
5. Verify no lock artifacts remain by running `bash scripts/check-start-work-clean.sh`, then update Success Criteria and Technical Notes in this requirement file with concrete command evidence.

**Last updated**: 2026-04-20T04:00:53Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts
* **Branch**: feature/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts
* **Merged**: Yes
* **Deployed**: Yes
