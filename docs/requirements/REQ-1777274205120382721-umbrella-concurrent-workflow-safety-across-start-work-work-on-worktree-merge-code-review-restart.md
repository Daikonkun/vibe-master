# Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review (restart)

**ID**: REQ-1777274205120382721  
**Status**: CODE_REVIEW  
**Priority**: CRITICAL  
**Created**: 2026-04-27T07:16:45Z  

## Description

Restarted from REQ-1777257357997508079. Define and implement end-to-end concurrency safety for simultaneous sessions running /start-work, /work-on, /worktree-merge, and /code-review. Cover manifest transaction boundaries, read-then-act race windows, docs regeneration serialization, and regression tests.

## Success Criteria

- [x] Concurrent workflow regression covers same-REQ and cross-REQ `/start-work` races and validates lifecycle/worktree consistency through `/worktree-merge`.
- [x] Concurrency coverage explicitly includes docs-regeneration serialization as a proxy for `/code-review` side effects.
- [x] Regression checks fail on stale manifest lock fallback artifacts left after concurrent operations.

## Technical Notes

- `scripts/check-concurrent-workflows.sh` now launches two parallel `scripts/regenerate-docs.sh` runs and asserts both complete successfully.
- The same regression now checks `$(git rev-parse --git-common-dir)/.manifest-locks` for stale `*.lock.d` directories after concurrent docs regeneration.
- Existing workflow checks (same-REQ race, cross-REQ progression, concurrent status advancement, merge lifecycle integrity) were preserved; docs regeneration now has explicit race coverage in the same test flow.

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777274205120382721-umbrella-concurrent-workflow-safety-across-start-work-work-on-worktree-merge-code-review-restart
* **Branch**: feature/REQ-1777274205120382721-umbrella-concurrent-workflow-safety-across-start-work-work-on-worktree-merge-code-review-restart
* **Merged**: No
* **Deployed**: No
