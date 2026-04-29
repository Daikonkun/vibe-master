# compatibility with Codex plugin

**ID**: REQ-1777449658730618520  
**Status**: CODE_REVIEW  
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


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777449658730618520-compatibility-with-codex-plugin.md`.
   - **Summary**: I want to make the slash commands available in Codex plugin inside VS Code
   - **Key criteria**: - [ ] All documented slash commands used by Vibe Master have a corresponding prompt/entrypoint file 
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: Primary approach: standardize slash-command definitions around prompt files under `.github/prompts/`
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777449658730618520` and verify success criteria are met.

**Last updated**: 2026-04-29T08:02:24Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777449658730618520-compatibility-with-codex-plugin
* **Branch**: feature/REQ-1777449658730618520-compatibility-with-codex-plugin
* **Merged**: No
* **Deployed**: No
