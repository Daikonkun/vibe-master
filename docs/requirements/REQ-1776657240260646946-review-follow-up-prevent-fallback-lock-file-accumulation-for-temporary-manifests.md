# Review follow-up: prevent fallback lock-file accumulation for temporary manifests

**ID**: REQ-1776657240260646946  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-20T03:54:00Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/_manifest-lock.sh writes flock lock files to a persistent fallback directory (/var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks) and does not clean them in flock mode, while scripts/check-manifest-lock-race.sh uses a unique mktemp manifest path per run. Repro: running bash scripts/check-manifest-lock-race.sh 1 twice increased lock-file count in /var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks from 1 to 3. Required outcome: preserve flock exclusivity and error propagation while lifecycle-managing lock artifacts, with scope focused primarily on regression-tooling temporary manifests.

## Success Criteria

- [x] Fallback flock lock files are lifecycle-managed (for example by bounded cleanup, deterministic reuse, or garbage collection) so repeated regression runs do not cause unbounded growth.
- [x] Scope is explicitly limited to regression-tooling temporary manifests unless broader impact is discovered, and production manifest locking semantics remain unchanged.
- [x] Regression evidence is added showing repeated executions of `bash scripts/check-manifest-lock-race.sh 1` do not produce net lock-file growth in the fallback lock directory under a controlled test lock root.

## Technical Notes

- Open Question decisions captured on 2026-04-20:
	- Lock artifacts should be lifecycle-managed.
	- Affected paths are mainly in regression tooling.
- Keep exclusivity and exit-code propagation guarantees validated by existing lock race checks while introducing lifecycle management.
- Implementation (2026-04-20): `scripts/check-manifest-lock-race.sh` now derives a controlled lock root and cleans the normalized per-run lock artifact in `cleanup()`, preserving flock/mkdir concurrency and exit-code assertions while preventing temporary-manifest lock accumulation across repeated runs.
- Validation evidence (2026-04-20T09:19:45Z): repeated runs with `MANIFEST_LOCK_DIR="$(mktemp -d \"${TMPDIR:-/tmp}/manifest-lock-persist.XXXXXX\")" bash scripts/check-manifest-lock-race.sh 1` produced `after_run1=0` and `after_run2=0`; default-root runs preserved `fallback_before=3` and `fallback_after=3`.

## Development Plan

1. Reproduce lock-file growth in a controlled test root using two sequential runs of `bash scripts/check-manifest-lock-race.sh 1`.
2. Implement temporary-manifest lock lifecycle management in `scripts/check-manifest-lock-race.sh` by exporting a controlled `MANIFEST_LOCK_DIR` and removing the normalized per-run lock artifact in `cleanup()`.
3. Keep scope limited to regression-tooling temporary manifests and preserve production manifest locking semantics in `scripts/_manifest-lock.sh`.
4. Re-run `bash scripts/check-manifest-lock-race.sh 1` for flock and mkdir backends to confirm concurrent-write, exclusivity, and exit-code behavior remains intact.
5. Confirm repeated executions show no net lock growth in both a persistent controlled lock root and the shared fallback root.

## Dependencies

REQ-1776420349206613978

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests
* **Branch**: feature/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests
* **Merged**: No
* **Deployed**: No
