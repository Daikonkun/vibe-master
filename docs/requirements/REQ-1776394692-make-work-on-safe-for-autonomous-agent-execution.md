# Make work-on safe for autonomous agent execution

**ID**: REQ-1776394692  
**Status**: CODE_REVIEW  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:58:12Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: (1) work-on.prompt.md step 7 requires interactive user confirmation before advancing status (line 40: Ask the user for confirmation exactly once), which blocks unattended agent pipelines. (2) When a PROPOSED requirement has no worktree, work-on auto-invokes /start-work (line 23) — two parallel /work-on agents targeting the same REQ can both trigger /start-work simultaneously, racing on branch creation and manifest updates. Required outcome: (1) Add an --auto or agent-mode flag that skips the confirmation gate when the caller is a trusted orchestrator agent. (2) Add a check-and-set guard so only the first /work-on invocation triggers /start-work; the second detects the in-flight worktree creation and waits or fails gracefully. (3) Document the autonomous execution contract in the prompt file.

## Success Criteria

- [x] `work-on.prompt.md` documents an `--auto` mode that, when present, skips the interactive confirmation gate at step 7 and advances status immediately after all success criteria are met
- [x] The `--auto` flag is only honored when the caller is the orchestrator agent (enforced via the `agent:` frontmatter field or explicit caller check)
- [x] When `/work-on` auto-invokes `/start-work` for a PROPOSED requirement, it first re-reads the manifest to check if a worktree was concurrently created; if one already exists, it skips `/start-work` and proceeds to implementation
- [x] Two parallel `/work-on` calls for the same REQ-ID do not both successfully create worktrees; the second one detects the existing worktree and either waits or fails with a clear message
- [x] The autonomous execution contract (when `--auto` is used, what guarantees apply, what is skipped) is documented in the prompt file constraints section

## Technical Notes

- **Confirmation skip**: In `work-on.prompt.md` step 7, add: "If `--auto` was passed, skip this confirmation and proceed directly to step 8." The flag is parsed in step 1 alongside `REQ-ID` and `target-status`.
- **Race guard for auto-start**: In step 4, after deciding to auto-invoke `/start-work`, re-read `.worktree-manifest.json` and `.requirement-manifest.json` to check if `worktreeId` is already set. If set, skip to step 5. This is a check-then-act pattern; combined with REQ-1776394634 locking it becomes safe.
- **start-work.sh idempotency**: `start-work.sh` already exits with error if worktree exists (line 42), so the worst case for a race is a clear failure message from the second invocation. The prompt should catch this error and proceed to step 5 instead of failing the entire `/work-on` flow.
- **Affected files**: `.github/prompts/work-on.prompt.md`.
- **Risk**: `--auto` removes a human safety gate. Misbehaving agents could advance status prematurely. Mitigated by requiring all success criteria to be checked before advancing, and by the lifecycle enforcement in REQ-1776394663.


## Development Plan

1. Update argument parsing and trust checks in `.github/prompts/work-on.prompt.md`.
   - Parse `REQ-ID`, optional target status, and optional `--auto` in step 1.
   - Enforce that `--auto` is accepted only for trusted orchestrator callers (for example by checking `agent:` metadata or an explicit caller guard).
2. Implement confirmation-gate behavior in `.github/prompts/work-on.prompt.md` step 7.
   - If trusted `--auto` is present, skip the user confirmation prompt and continue directly to status advancement.
   - Keep existing interactive confirmation unchanged when `--auto` is absent.
3. Add race-safe auto-start logic around the `/start-work` path in `.github/prompts/work-on.prompt.md`.
   - Re-read `.requirement-manifest.json` and `.worktree-manifest.json` immediately before invoking `/start-work`.
   - If a worktree already exists for the requirement, skip `/start-work` and continue.
   - If `/start-work` returns an already-exists style error, treat it as non-fatal and continue with the discovered worktree.
4. Document the autonomous execution contract in the constraints section of `.github/prompts/work-on.prompt.md`.
   - Define exactly what `--auto` skips, what checks remain mandatory, and that lifecycle enforcement still depends on `scripts/start-work.sh` and `scripts/update-requirement-status.sh`.
5. Validate behavior with repository scripts after edits.
   - Run `scripts/show-requirement.sh REQ-1776394692` and `scripts/status.sh` to confirm consistent status and worktree reporting.
   - Re-read the updated prompt file to confirm one confirmation path for interactive mode and one explicit fast path for trusted `--auto` mode.

**Last updated**: 2026-04-17T08:15:15Z

## Dependencies

REQ-1776394634 (manifest locking for safe concurrent worktree creation checks)
REQ-1776394663 (lifecycle enforcement ensures premature status advances are blocked)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
