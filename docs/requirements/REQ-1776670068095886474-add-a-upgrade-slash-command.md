# add a /upgrade slash command

**ID**: REQ-1776670068095886474  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-20T07:27:48Z  

## Description

add a slash command, i.e. /upgrade (check if it conflicts with native VS code or copilot command), the purpose is for user to upgrade their vibe master from the latest github repo, while not affecting any working files of the project being edited by vibe master.

## Success Criteria

- [ ] A prompt file exists at `.github/prompts/upgrade.prompt.md`, and invoking `/upgrade` in Copilot Chat follows that prompt workflow.
- [ ] The `/upgrade` workflow performs a preflight command-name conflict check (project slash commands plus known native/Copilot slash names); if a conflict is detected, it exits with a clear rename recommendation.
- [ ] Upgrade execution runs in an isolated location (for example, a sibling git worktree) rather than the currently edited project tree, and the active repo remains unchanged after completion (`git status --short` shows no upgrade-induced edits).
- [ ] The workflow fetches the latest Vibe Master template from GitHub, presents a reviewable diff before applying changes, and requires explicit user confirmation before any replace/merge step.
- [ ] Usage and safety/rollback guidance for `/upgrade` is documented in `README.md`, including post-upgrade validation via `jq` manifest checks and `scripts/regenerate-docs.sh`.

## Technical Notes

Implement `/upgrade` as a new prompt wrapper at `.github/prompts/upgrade.prompt.md`, following the command patterns already used in `.github/prompts/init.prompt.md` and `.github/prompts/start-work.prompt.md`.

Use the existing upgrade process in `README.md` as the baseline execution model: create a dedicated upgrade worktree (`git worktree add`), clone latest template into `.upgrade-template/latest`, compare with `diff -ruN`, and only then apply selected file updates. This keeps the user's active project files isolated from upgrade operations.

Concrete affected areas:
- `.github/prompts/upgrade.prompt.md` (new slash command workflow)
- `README.md` (command discovery + upgraded safety workflow alignment)
- Optional helper script such as `scripts/upgrade.sh` for deterministic preflight checks and repeatable shell steps

Primary risks and mitigations:
- Command collision with native/Copilot slash commands: maintain a checked list and fail fast with fallback naming guidance.
- Accidental overwrite of local project state: enforce isolated worktree execution and require a clean-state check before apply.
- Manifest/docs drift after workflow changes: run `scripts/regenerate-docs.sh` after updates and include verification checks in the command output.

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
