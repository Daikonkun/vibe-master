# Review follow-up: clean lock/timestamp artifacts after start-work

**ID**: REQ-1776418077426972512  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T09:27:57Z  

## Description

Source: orchestrator workflow hygiene review. Evidence: after /start-work, stale lock artifacts (.requirement-manifest.json.lock and .worktree-manifest.json.lock) and timestamp-only doc diffs can remain in the repo, creating avoidable dirty-tree noise. Required outcome: make /start-work leave a clean workspace by removing lock artifacts reliably and avoiding unnecessary timestamp churn unless generated content materially changes.

## Success Criteria

- [ ] Running `bash scripts/start-work.sh <REQ-ID>` from a clean repo leaves no lock artifacts (`.requirement-manifest.json.lock`, `.worktree-manifest.json.lock`, or stale `*.lock.d` directories) in the project root after success.
- [ ] If `/start-work` fails after lock acquisition, lock artifacts are still cleaned up, and a rerun can acquire locks immediately without manual deletion.
- [ ] Documentation regeneration triggered by `/start-work` does not create timestamp-only diffs when manifest state is unchanged (idempotent reruns produce no generated-doc changes).
- [ ] A reproducible verification path is documented and automated (for example via an existing `scripts/check-*.sh` guard or a new check script) to assert lock cleanup and no-op doc regeneration behavior.

## Technical Notes

- Primary lock behavior lives in `scripts/_manifest-lock.sh` and is consumed by `scripts/start-work.sh` via `jq_update_manifest_locked` and `with_manifest_lock`.
- In flock mode, lock files are created as real `*.lock` files (`200>"$lock_file"`), so cleanup must be explicit after releasing the lock to avoid residue in tracked repos.
- `scripts/regenerate-docs.sh` currently writes `* Last updated: $(date -u ...)` on every run; this causes timestamp churn even when manifests are unchanged. Prefer a deterministic value (for example derived from manifest `updatedAt`) or skip rewriting that line when content is unchanged.
- Keep failure semantics intact: lock cleanup must not swallow the original error code from manifest updates.

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
