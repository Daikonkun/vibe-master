# compatibility with Codex plugin

**ID**: REQ-1777449658730618520  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-29T08:00:58Z  

## Description

I want to make the slash commands available in Codex plugin inside VS Code

## Success Criteria

- [ ] All documented slash commands used by Vibe Master have a corresponding prompt/entrypoint file that the Codex plugin can invoke in VS Code.
- [ ] Running a representative command set in Codex plugin (for example `/add-requirement`, `/status`, `/start-work`, `/work-on`) successfully routes to the expected workflow without manual command translation.
- [ ] Command discoverability docs are updated so users can find and run the same slash commands in Codex plugin and Copilot Chat contexts.
- [ ] `scripts/check-command-entrypoints.sh` (or equivalent command-entrypoint validation) passes with no missing command mappings after compatibility updates.
- [ ] A manual smoke test in VS Code with Codex plugin confirms command execution parity for requirement creation and worktree lifecycle flows.

## Technical Notes

Primary approach: standardize slash-command definitions around prompt files under `.github/prompts/` and keep advertised commands synchronized in `copilot-instructions.md` and `docs/COMMAND_MAP.md`, so Codex plugin can resolve the same entrypoints already used by this project.

Likely affected areas: prompt filenames and argument contracts, command documentation, and validation scripts (especially `scripts/check-command-entrypoints.sh`) that ensure every documented slash command maps to a concrete prompt/skill path.

Risks: command alias drift between Copilot and Codex naming, stale docs that advertise unsupported commands, and workflow regressions if orchestrator-specific commands are not recognized uniformly. Mitigate with command-map normalization and scripted entrypoint checks in CI/local validation.

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
