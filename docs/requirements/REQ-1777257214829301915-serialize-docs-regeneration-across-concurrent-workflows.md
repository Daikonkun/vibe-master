# Serialize docs regeneration across concurrent workflows

**ID**: REQ-1777257214829301915  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-27T02:33:34Z  

## Description

Add lock/serialization around scripts/regenerate-docs.sh and callers so concurrent sessions do not race-write REQUIREMENTS.md and docs/*.md. Ensure deterministic outputs and safe retries when two sessions run status/work-on/merge concurrently.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Audit doc-regeneration entry points and shared side effects in `scripts/regenerate-docs.sh`, `scripts/status.sh`, `scripts/work-on.sh`, and `scripts/worktree-merge.sh` to identify all concurrent write paths to `REQUIREMENTS.md` and `docs/*.md`.
2. Add a single lock-protected critical section around docs generation in `scripts/regenerate-docs.sh` (using `scripts/_manifest-lock.sh` conventions) so only one session can regenerate docs at a time while others wait/retry safely.
3. Update direct callers (`scripts/status.sh`, `scripts/work-on.sh`, `scripts/worktree-merge.sh`, and any other scripts invoking regeneration) to use the serialized path consistently and avoid nested lock misuse or duplicate regeneration.
4. Add/extend regression coverage in `scripts/check-docs-sync.sh` and a focused concurrent scenario script (or existing concurrency checks) to assert deterministic outputs under parallel invocations.
5. Validate end-to-end by running `./scripts/regenerate-docs.sh`, `./scripts/status.sh`, and targeted checks, then confirm `docs/STATUS.md`, `docs/ROADMAP.md`, and `REQUIREMENTS.md` remain consistent and unchanged across repeated concurrent runs.

**Last updated**: 2026-04-27T03:27:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777257214829301915-serialize-docs-regeneration-across-concurrent-workflows
* **Branch**: feature/REQ-1777257214829301915-serialize-docs-regeneration-across-concurrent-workflows
* **Merged**: No
* **Deployed**: No
