# Review follow-up: exercise manifest lock fallback path in concurrency check

**ID**: REQ-1777275195454105151  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-27T07:33:15Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/check-concurrent-workflows.sh lines 323-349 added concurrent docs regeneration and stale *.lock.d checks, but scripts/_manifest-lock.sh only uses the mkdir fallback when flock is unavailable or MANIFEST_LOCK_FORCE_MKDIR=1; on this environment command -v flock resolves /opt/homebrew/bin/flock, so the new fallback-artifact assertion does not exercise the fallback path it claims to protect. Required outcome: update the regression to force MANIFEST_LOCK_FORCE_MKDIR=1 for the docs-regeneration fallback-artifact scenario, or add an equivalent dedicated fallback-mode test that fails on stale *.lock.d artifacts.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777275195454105151-review-follow-up-exercise-manifest-lock-fallback-path-in-concurrency-check.md`.
   - **Summary**: Source: code-review. Severity: MEDIUM. Evidence: scripts/check-concurrent-workfl
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777275195454105151` and verify success criteria are met.

**Last updated**: 2026-04-27T07:37:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777275195454105151-review-follow-up-exercise-manifest-lock-fallback-path-in-concurrency-check
* **Branch**: feature/REQ-1777275195454105151-review-follow-up-exercise-manifest-lock-fallback-path-in-concurrency-check
* **Merged**: No
* **Deployed**: No
