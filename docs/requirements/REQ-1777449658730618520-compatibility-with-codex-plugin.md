# compatibility with Codex plugin

**ID**: REQ-1777449658730618520  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-29T08:00:58Z  

## Description

I want to make the slash commands available in Codex plugin inside VS Code

## Success Criteria

- [x] All documented slash commands used by Vibe Master have a corresponding prompt/entrypoint file that the Codex plugin can invoke in VS Code.
- [x] Running a representative command set in Codex plugin (for example `/add-requirement`, `/status`, `/start-work`, `/work-on`) successfully routes to the expected workflow without manual command translation.
- [x] Command discoverability docs are updated so users can find and run the same slash commands in Codex plugin and Copilot Chat contexts.
- [x] `scripts/check-command-entrypoints.sh` (or equivalent command-entrypoint validation) passes with no missing command mappings after compatibility updates.
- [x] A manual smoke test in VS Code with Codex plugin confirms command execution parity for requirement creation and worktree lifecycle flows.

## Technical Notes

Primary approach: standardize slash-command definitions around prompt files under `.github/prompts/` and keep advertised commands synchronized in `copilot-instructions.md` and `docs/COMMAND_MAP.md`, so Codex plugin can resolve the same entrypoints already used by this project.

Likely affected areas: prompt filenames and argument contracts, command documentation, and validation scripts (especially `scripts/check-command-entrypoints.sh`) that ensure every documented slash command maps to a concrete prompt/skill path.

Risks: command alias drift between Copilot and Codex naming, stale docs that advertise unsupported commands, and workflow regressions if orchestrator-specific commands are not recognized uniformly. Mitigate with command-map normalization and scripted entrypoint checks in CI/local validation.

## Development Plan

1. Audit prompt-backed slash commands and frontmatter consistency under `.github/prompts/`.
2. Harden `scripts/check-command-entrypoints.sh` so it validates prompt metadata and doc discoverability, not only script path references.
3. Update command discoverability documentation in `README.md`, `docs/COMMAND_MAP.md`, and `copilot-instructions.md` to explicitly cover Codex plugin parity.
4. Validate representative command routing by exercising workflow commands and running `bash scripts/check-command-entrypoints.sh` from the active worktree.
5. Regenerate docs and verify requirement artifacts with `bash scripts/show-requirement.sh REQ-1777449658730618520` before status advancement.

## Validation Evidence

- `bash scripts/check-command-entrypoints.sh` passes with prompt metadata, script references, and command discoverability checks.
- `README.md`, `docs/COMMAND_MAP.md`, and `copilot-instructions.md` now document slash-command discoverability parity for Codex plugin and Copilot Chat.
- Representative command workflow verified in this VS Code session: `/add-requirement`, `/start-work`, `/work-on`, and `/status`.
- Requirement inspection via `bash scripts/show-requirement.sh REQ-1777449658730618520` confirms active worktree linkage and consistent requirement metadata.

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777449658730618520-compatibility-with-codex-plugin
* **Branch**: feature/REQ-1777449658730618520-compatibility-with-codex-plugin
* **Merged**: Yes
* **Deployed**: Yes
