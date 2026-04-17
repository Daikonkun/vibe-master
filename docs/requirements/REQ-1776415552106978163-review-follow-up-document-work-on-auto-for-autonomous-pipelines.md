# Review follow-up: document work-on --auto for autonomous pipelines

**ID**: REQ-1776415552106978163  
**Status**: PROPOSED  
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

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
