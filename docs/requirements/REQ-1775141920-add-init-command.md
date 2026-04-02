# add /init command

**ID**: REQ-1775141920  
**Status**: MERGED  
**Priority**: MEDIUM  
**Created**: 2026-04-02T14:58:40Z  

## Description

the previous trial on assuming agents can automatically clear history of Vibe Agent REQs does not work out. add a /init command to let the agent clear Vibe Master related REQs in a new project. strictly limit the clear happens to Vibe-Master related REQs, do not clear any project-related REQs even /init is used in the middle of developing a project. do not clear this current master source of Vibe Master as well

## Success Criteria

- [ ] A `/init` slash command exists backed by a prompt file at `.github/prompts/init.prompt.md`
- [ ] Running `/init [project-name]` in a new or existing project clears only Vibe-Master-internal REQs (those that shipped with the template) from `.requirement-manifest.json` and removes their corresponding `docs/requirements/REQ-*.md` spec files
- [ ] Project-specific REQs (those created by the user after initialization) are preserved — even if `/init` is run in the middle of active development
- [ ] The command does not modify the Vibe Master source repository itself (the template origin); it only operates on the target project workspace
- [ ] After clearing, the command reinitializes empty manifests (`.requirement-manifest.json`, `.worktree-manifest.json`) with the project name, regenerates docs, and commits the result

## Technical Notes

- **Distinguishing Vibe Master REQs from project REQs**: The safest approach is to tag REQs with an `origin` field (e.g., `"origin": "vibe-master"` vs `"origin": "project"`) in `.requirement-manifest.json`. The `/init` command deletes only entries where `origin == "vibe-master"`. Alternatively, maintain a static list of known Vibe Master REQ IDs baked into the script — but this is fragile and harder to maintain.
- **Existing `init-project.sh`**: Currently wipes all REQs indiscriminately (resets manifest to empty, deletes all `docs/requirements/REQ-*.md`). This script needs to be updated or a new companion script created to support selective clearing.
- **Self-protection**: The command must detect if it's running inside the Vibe Master source repo (e.g., by checking `git remote` or a sentinel file) and refuse to execute.
- **Prompt file**: Create `.github/prompts/init.prompt.md` following the existing pattern. The prompt should invoke the updated `init-project.sh` (or a new `init-clear.sh`).
- **Affected files**: `.github/prompts/init.prompt.md` (new), `scripts/init-project.sh` (update or new script), `copilot-instructions.md` (add `/init` to slash-command table), `.requirement-manifest.json` schema (potentially add `origin` field).
- **Risk**: If the `origin` tagging is not applied retroactively to existing Vibe Master REQs, the first `/init` in a cloned project won't know which REQs to clear. The migration path needs to handle this.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1775141920-add-init-command.md`.
   - **Summary**: he previous trial on assuming agents can automatically clear history of Vibe Age
   - **Key criteria**: - [ ] A `/init` slash command exists backed by a prompt file at `.github/prompts/init.prompt.md` - [
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - **Distinguishing Vibe Master REQs from project REQs**: The safest approach is to tag REQs with an 
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1775141920` and verify success criteria are met.

**Last updated**: 2026-04-02T15:00:36Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
