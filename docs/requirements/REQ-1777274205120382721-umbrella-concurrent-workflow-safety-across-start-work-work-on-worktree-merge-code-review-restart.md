# Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review (restart)

**ID**: REQ-1777274205120382721  
**Status**: MERGED  
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


## Development Plan

1. Inventory current concurrency guards and race windows in `scripts/start-work.sh`, `scripts/work-on.sh`, `scripts/worktree-merge.sh`, and the `/code-review` prompt flow under `.github/prompts/`; capture findings in `## Technical Notes` for this spec.
2. Implement missing serialization/locking and read-then-act protections in the affected scripts, reusing `scripts/_manifest-lock.sh` patterns where possible and keeping lifecycle updates atomic across `.requirement-manifest.json` and `.worktree-manifest.json`.
3. Extend and/or add regression checks for parallel-session behavior in `scripts/check-concurrent-workflows.sh` and related race-focused checks (for example `scripts/check-start-work-clean.sh` and `scripts/check-worktree-merge-atomic-cleanup.sh`).
4. Regenerate and validate requirement dashboards with `./scripts/regenerate-docs.sh`, then confirm lifecycle/worktree coherence with `./scripts/reconcile-lifecycle-invariants.sh`.
5. Validate completion evidence with `./scripts/show-requirement.sh REQ-1777274205120382721` and targeted script runs, then update the Success Criteria checklist in this spec to reflect what is satisfied.

**Last updated**: 2026-04-27T07:18:28Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777274205120382721-umbrella-concurrent-workflow-safety-across-start-work-work-on-worktree-merge-code-review-restart
* **Branch**: feature/REQ-1777274205120382721-umbrella-concurrent-workflow-safety-across-start-work-work-on-worktree-merge-code-review-restart
* **Merged**: Yes
* **Deployed**: No
