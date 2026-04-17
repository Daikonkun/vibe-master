# Harden lifecycle enforcement in start-work and worktree-merge

**ID**: REQ-1776394663  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:57:43Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: (1) start-work.sh sets status to IN_PROGRESS unconditionally (line 92) without checking current status — a MERGED, DEPLOYED, or CANCELLED requirement can be reopened. (2) worktree-merge.sh only warns when requirement is not in CODE_REVIEW (line 97-98) then proceeds to set MERGED/DEPLOYED anyway, allowing merge before review. (3) orchestrator.agent.md declares Any to BACKLOG and Any to CANCELLED (lines 116-117) but update-requirement-status.sh has a narrower transition table — DEPLOYED only allows CANCELLED, CODE_REVIEW does not allow BACKLOG. Required outcome: (1) start-work.sh validates current status is PROPOSED or BACKLOG before proceeding; reject otherwise. (2) worktree-merge.sh requires CODE_REVIEW by default and only allows IN_PROGRESS or other non-CODE_REVIEW states when `--force` is explicitly passed. (3) Align orchestrator.agent.md state transition docs with the actual allowed_transitions() function in update-requirement-status.sh.

## Success Criteria

- [x] `start-work.sh` checks current requirement status before setting IN_PROGRESS; only PROPOSED and BACKLOG are allowed; any other status causes a non-zero exit with a clear error message
- [x] `worktree-merge.sh` checks linked requirement status before merging; CODE_REVIEW is required by default, and IN_PROGRESS/other statuses cause a non-zero exit unless `--force` is passed
- [x] `orchestrator.agent.md` state transition documentation matches the `allowed_transitions()` function in `update-requirement-status.sh` exactly (no "Any → BACKLOG" or "Any → CANCELLED" that the script does not support)
- [x] `work-on.prompt.md` lifecycle map is updated to reflect the corrected transitions
- [x] An agent that attempts `/start-work` on a DEPLOYED requirement receives an error, not a silent reopening
- [x] An agent that attempts `/worktree-merge` on an IN_PROGRESS requirement (skipping review) gets blocked unless `--force` is used

## Technical Notes

- **start-work.sh guard**: After the existing worktree check (line 42), add: `CURRENT_STATUS=$(jq -r ...)` and validate it is `PROPOSED` or `BACKLOG`. Exit 1 otherwise. This prevents reopening terminal-state requirements.
- **worktree-merge.sh guard**: After resolving `REQ_IDS` (line 60), loop through linked requirements and enforce `CODE_REVIEW` before merge. If status is `IN_PROGRESS` (or any other non-`CODE_REVIEW` state), print an error and exit unless `--force` is explicitly provided.
- **Doc alignment**: The orchestrator declares `Any → BACKLOG` and `Any → CANCELLED`, but `update-requirement-status.sh` only allows BACKLOG from PROPOSED, IN_PROGRESS, CODE_REVIEW, BLOCKED. CANCELLED is allowed from any state via the shortcut at line 131. Update the agent doc to reflect the actual per-state BACKLOG rules, and note that CANCELLED is the only truly universal transition.
- **Affected files**: `scripts/start-work.sh`, `scripts/worktree-merge.sh`, `.github/agents/orchestrator.agent.md`, `.github/prompts/work-on.prompt.md`.

## Development Plan

1. [x] Inspect lifecycle enforcement in `scripts/start-work.sh`, `scripts/worktree-merge.sh`, and `scripts/update-requirement-status.sh` to anchor behavior to the canonical transition table.
2. [x] Add a status gate to `scripts/start-work.sh` so only `PROPOSED` and `BACKLOG` can transition into `IN_PROGRESS`.
3. [x] Add pre-merge lifecycle enforcement to `scripts/worktree-merge.sh` so non-`CODE_REVIEW` states fail by default and require explicit `--force` override.
4. [x] Align transition documentation in `.github/agents/orchestrator.agent.md` and `.github/prompts/work-on.prompt.md` with `allowed_transitions()`.
5. [x] Validate behavior with targeted checks for `/start-work` on `DEPLOYED` and `/worktree-merge` on `IN_PROGRESS` with and without `--force`.

## Dependencies

None

## Worktree

feature/REQ-1776394663-harden-lifecycle-enforcement-in-start-work-and-worktree-merge

---

* **Linked Worktree**: feature/REQ-1776394663-harden-lifecycle-enforcement-in-start-work-and-worktree-merge
* **Branch**: feature/REQ-1776394663-harden-lifecycle-enforcement-in-start-work-and-worktree-merge
* **Merged**: No
* **Deployed**: No
