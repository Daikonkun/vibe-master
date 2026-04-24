# Review follow-up: stop swallowing lifecycle commit failures that later block /worktree-merge

**ID**: REQ-1777018133999709609  
**Status**: DEPLOYED  
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

1. Inspect current lifecycle auto-commit paths in `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, and `scripts/worktree-merge.sh`; identify all `git commit ... || true` suppressions and classify expected hard-fail vs no-op commit behavior.
2. Update each lifecycle script to treat required lifecycle/doc commits as mandatory: remove failure suppression, surface clear diagnostics on commit failure, and keep existing no-op handling only where no staged lifecycle changes exist.
3. Add or update shell checks around commit execution (exit-code propagation + operator guidance) so failed lifecycle commits return non-zero with remediation hints, especially for dirty index/worktree blockers.
4. Validate behavior with targeted script-level checks: run `scripts/check-start-work-clean.sh`, `scripts/check-requirement-worktree-lifecycle.sh`, and `scripts/check-worktree-merge-req-fallback.sh` to ensure lifecycle transitions and merge preconditions remain correct.
5. Regenerate and verify requirement docs/state with `scripts/regenerate-docs.sh` and `scripts/show-requirement.sh REQ-1777018133999709609`, confirming success criteria alignment before moving status to `CODE_REVIEW`.

**Last updated**: 2026-04-24T08:31:16Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge
* **Branch**: feature/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge
* **Merged**: Yes
* **Deployed**: Yes
