# Add concurrency regression suite for parallel sessions

**ID**: REQ-1777257221458997051  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-27T02:33:41Z  

## Description

Introduce regression tests that simulate simultaneous /start-work, /work-on status advancement, and /worktree-merge execution across two REQs. Cover same-REQ race, cross-REQ parallel progression, and manifest/docs consistency under concurrent runs.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Audit concurrency-sensitive paths for `/start-work`, `/work-on`, and `/worktree-merge` by tracing lock boundaries and manifest/doc writes in `scripts/start-work.sh`, `scripts/worktree-merge.sh`, and `scripts/regenerate-docs.sh`; document any uncovered race windows in `## Technical Notes`.
2. Add a same-REQ and cross-REQ parallel regression harness (new `scripts/check-concurrent-workflows.sh`) that launches concurrent workflow commands, then asserts no duplicate/invalid worktree mappings in `.worktree-manifest.json` and lifecycle consistency in `.requirement-manifest.json`.
3. Extend existing regression coverage by wiring targeted checks for concurrent lifecycle progression and merge cleanup behavior into `scripts/check-start-work-clean.sh`, `scripts/check-work-on-no-op-guard.sh`, and `scripts/check-worktree-merge-atomic-cleanup.sh`.
4. Ensure docs consistency under concurrent runs by asserting synchronized output in `REQUIREMENTS.md` and `docs/STATUS.md` (via `scripts/check-docs-sync.sh`) after parallel harness execution.
5. Run the full validation pass (`bash scripts/check-concurrent-workflows.sh && bash scripts/check-manifest-lock-race.sh && bash scripts/regenerate-docs.sh`) and confirm requirement state/worktree linkage with `bash scripts/show-requirement.sh REQ-1777257221458997051` and `bash scripts/status.sh`.

**Last updated**: 2026-04-27T04:00:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777257221458997051-add-concurrency-regression-suite-for-parallel-sessions
* **Branch**: feature/REQ-1777257221458997051-add-concurrency-regression-suite-for-parallel-sessions
* **Merged**: No
* **Deployed**: No
