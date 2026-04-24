# Review follow-up: stop swallowing lifecycle commit failures that later block /worktree-merge

**ID**: REQ-1777018133999709609  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
