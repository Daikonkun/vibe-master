# Review follow-up: document work-on --auto for autonomous pipelines

**ID**: REQ-1776415552106978163  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-17T08:45:52Z  

## Description

Source: code-review of delegated REQ flow. Severity: HIGH. Evidence: .github/prompts/work-on.prompt.md defines --auto to skip confirmation, but README.md and copilot-instructions.md advertise /work-on without --auto; autonomous runs can pause at confirmation unexpectedly. Required outcome: update command tables and execution guidance to include --auto usage, trust constraints, and recommended autonomous invocation patterns.

## Success Criteria

- [x] `/work-on` command docs include `--auto|--no-auto` and describe trusted orchestrator default-auto behavior
- [x] `.github/prompts/work-on.prompt.md` defines default auto mode for trusted orchestrator calls with explicit `--no-auto` opt-out
- [x] Untrusted-caller safeguards for `--auto` remain explicit in prompt constraints

## Technical Notes

- Decision confirmed on 2026-04-17: orchestrator-invoked `/work-on` defaults to auto mode.
- Updated files: `.github/prompts/work-on.prompt.md`, `README.md`, `copilot-instructions.md`, `.github/agents/orchestrator.agent.md`.
- Behavior contract: default auto for trusted orchestrator callers, `--no-auto` to force confirmation, and untrusted callers cannot enable auto mode.


## Development Plan

1. Audit current `/work-on` contract across all source-of-truth docs.
   - Review `README.md`, `copilot-instructions.md`, `.github/prompts/work-on.prompt.md`, and `.github/agents/orchestrator.agent.md` for argument syntax and trust rules.
   - Use `grep -n "work-on" README.md copilot-instructions.md .github/prompts/work-on.prompt.md .github/agents/orchestrator.agent.md` and `grep -n -- "--auto" README.md copilot-instructions.md .github/prompts/work-on.prompt.md .github/agents/orchestrator.agent.md` to capture all references before edits.
2. Align end-user slash-command documentation with autonomous behavior.
   - Update `README.md` command docs to include `/work-on <requirement-id> [target-status] [--no-auto]` and explain trusted default-auto execution.
   - Update `copilot-instructions.md` slash-command guidance to mirror the same `--auto`/`--no-auto` behavior contract.
3. Align prompt and orchestrator guidance with the same execution semantics.
   - Update `.github/prompts/work-on.prompt.md` so trusted orchestrator calls default to auto mode and `--no-auto` explicitly forces confirmation.
   - Update `.github/agents/orchestrator.agent.md` command examples and notes so they match prompt behavior exactly.
4. Regenerate and verify requirement documentation consistency.
   - Run `bash scripts/show-requirement.sh REQ-1776415552106978163` to re-check Description, Success Criteria, and Technical Notes.
   - Run `bash scripts/regenerate-docs.sh` and confirm generated status/roadmap docs stay in sync with the manifest.
5. Perform final validation and prepare handoff in the worktree.
   - Re-open `docs/requirements/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines.md` to confirm the Development Plan remains idempotent and accurate.
   - Run `bash scripts/status.sh` to verify lifecycle placement after documentation updates, then proceed from step 2 in the worktree.

**Last updated**: 2026-04-20T03:07:45Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines
* **Branch**: feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines
* **Merged**: No
* **Deployed**: No
