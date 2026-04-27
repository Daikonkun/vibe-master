# Review follow-up: exercise manifest lock fallback path in concurrency check

**ID**: REQ-1777275195454105151  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-27T07:33:15Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/check-concurrent-workflows.sh lines 323-349 added concurrent docs regeneration and stale *.lock.d checks, but scripts/_manifest-lock.sh only uses the mkdir fallback when flock is unavailable or MANIFEST_LOCK_FORCE_MKDIR=1; on this environment command -v flock resolves /opt/homebrew/bin/flock, so the new fallback-artifact assertion does not exercise the fallback path it claims to protect. Required outcome: update the regression to force MANIFEST_LOCK_FORCE_MKDIR=1 for the docs-regeneration fallback-artifact scenario, or add an equivalent dedicated fallback-mode test that fails on stale *.lock.d artifacts.

## Success Criteria

- [x] Concurrent docs-regeneration regression explicitly forces mkdir fallback mode with `MANIFEST_LOCK_FORCE_MKDIR=1`.
- [x] Regression still validates that no stale `*.lock.d` directories remain after the concurrent run.
- [x] Updated regression passes locally via `scripts/check-concurrent-workflows.sh`.

## Technical Notes

Updated `scripts/check-concurrent-workflows.sh` to run the concurrent docs regeneration pair with `MANIFEST_LOCK_FORCE_MKDIR=1`, ensuring fallback lock cleanup assertions are exercised on environments where `flock` is available.

## Development Plan

1. Update the fallback-artifact regression in `scripts/check-concurrent-workflows.sh` so the targeted scenario explicitly runs with `MANIFEST_LOCK_FORCE_MKDIR=1`, ensuring the mkdir lock path is exercised even when `flock` exists.
2. Confirm the test setup/cleanup in `scripts/check-concurrent-workflows.sh` still asserts no stale `*.lock.d` artifacts remain after concurrent docs regeneration.
3. If helper behavior needs alignment, adjust `scripts/_manifest-lock.sh` only as required to preserve fallback behavior and cleanup guarantees under forced mkdir mode.
4. Run `./scripts/check-concurrent-workflows.sh` and verify the fallback-path assertion passes reliably on this environment.
5. Run `./scripts/regenerate-docs.sh`, then validate requirement state and linkage with `./scripts/show-requirement.sh REQ-1777275195454105151`.

**Last updated**: 2026-04-27T07:43:30Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777275195454105151-review-follow-up-exercise-manifest-lock-fallback-path-in-concurrency-check
* **Branch**: feature/REQ-1777275195454105151-review-follow-up-exercise-manifest-lock-fallback-path-in-concurrency-check
* **Merged**: Yes
* **Deployed**: Yes
