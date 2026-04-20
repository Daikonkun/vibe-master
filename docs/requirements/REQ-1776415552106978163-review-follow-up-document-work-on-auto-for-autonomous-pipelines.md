# Review follow-up: document work-on --auto for autonomous pipelines

**ID**: REQ-1776415552106978163  
**Status**: IN_PROGRESS  
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

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines.md`.
   - **Summary**: Source: code-review of delegated REQ flow. Severity: HIGH. Evidence: .github/pro
   - **Key criteria**: - [x] `/work-on` command docs include `--auto|--no-auto` and describe trusted orchestrator default-a
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - Decision confirmed on 2026-04-17: orchestrator-invoked `/work-on` defaults to auto mode.
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776415552106978163` and verify success criteria are met.

**Last updated**: 2026-04-20T03:03:24Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines
* **Branch**: feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines
* **Merged**: No
* **Deployed**: No
