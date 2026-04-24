# Review follow-up: stop swallowing lifecycle commit failures that later block /worktree-merge

**ID**: REQ-1777018133999709609  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-24T08:08:54Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/start-work.sh, scripts/update-requirement-status.sh, and scripts/worktree-merge.sh all ignore commit failures with '... || true' (around lines ~151, ~339, ~371), so status/docs changes can remain uncommitted and then trigger /worktree-merge dirty-tree refusal (line ~158). Required outcome: detect and surface commit failures explicitly (or provide deterministic fallback), and ensure successful lifecycle commands do not silently leave staged/unstaged manifest/doc changes that block merge.

## Success Criteria

- [ ] `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, and `scripts/worktree-merge.sh` no longer suppress lifecycle commit failures.
- [ ] Lifecycle auto-commit is treated as mandatory: command exits non-zero when required lifecycle/doc commit cannot be created.
- [ ] Error output includes actionable remediation so operators can resolve commit blockers and rerun safely.

## Technical Notes

- Decision (2026-04-24): **lifecycle scripts auto-commit is mandatory**.
- Remove `|| true` suppression around lifecycle commit steps and fail fast with explicit diagnostics.
- Keep repository state predictable by preventing silent success when lifecycle metadata is uncommitted.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge.md`.
   - **Summary**: Source: code-review. Severity: HIGH. Evidence: scripts/start-work.sh, scripts/up
   - **Key criteria**: - [ ] `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, and `scripts/worktree-merge.s
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - Decision (2026-04-24): **lifecycle scripts auto-commit is mandatory**.
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777018133999709609` and verify success criteria are met.

**Last updated**: 2026-04-24T08:31:16Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge
* **Branch**: feature/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge
* **Merged**: No
* **Deployed**: No
