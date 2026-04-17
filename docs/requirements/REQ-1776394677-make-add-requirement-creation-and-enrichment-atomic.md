# Make add-requirement creation and enrichment atomic

**ID**: REQ-1776394677  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:57:57Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: The /add-requirement prompt workflow is a three-phase non-atomic sequence: (1) create-requirement.sh runs and auto-commits at line 101, (2) the agent enriches spec placeholder sections and updates manifest notes field, (3) regenerate-docs.sh runs. If the agent is interrupted between phases, the manifest contains a committed but unenriched requirement with placeholder criteria, the notes field is empty, and docs are stale. A concurrent agent reading the manifest may see the incomplete record. Required outcome: (1) create-requirement.sh defers its git commit so the agent can enrich before committing. (2) Alternatively, the prompt workflow performs a single atomic commit after all enrichment is done. (3) If interrupted mid-enrichment, no partial commit is left on main.

## Success Criteria

- [ ] `create-requirement.sh` accepts a `--no-commit` flag that skips the `git add` + `git commit` at the end, allowing the calling agent to enrich spec files before committing
- [ ] The `/add-requirement` prompt workflow performs a single `git add` + `git commit` after all enrichment (spec sections + manifest notes field + regenerate-docs) is complete
- [ ] If the agent is interrupted after `create-requirement.sh --no-commit` but before the final commit, the changes remain unstaged/uncommitted — no partial commit lands on main
- [ ] Existing behavior (running `create-requirement.sh` without `--no-commit`) is preserved for backward compatibility and standalone script usage
- [ ] The code-review skill's REQ thread creation pattern (`create-requirement.sh` invocations in skill docs) is updated to document the `--no-commit` option

## Technical Notes

- **Flag implementation**: Add a `--no-commit` argument parser to `create-requirement.sh`. When set, skip the `git add` and `git commit` blocks at lines 93-101. The prompt workflow in `add-requirement.prompt.md` would then call `create-requirement.sh "$NAME" "$DESC" "$PRIORITY" --no-commit`, perform enrichment, then issue the commit itself.
- **Prompt workflow change**: Update `add-requirement.prompt.md` step 3 to pass `--no-commit`, and add a new step 5b that runs `git add .requirement-manifest.json docs/requirements/ REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md && git commit -m "chore: create requirement $REQ_ID"`.
- **Interruption safety**: Since `--no-commit` leaves files as unstaged modifications, an interrupted agent's partial work is visible via `git status` and easily cleaned with `git checkout -- .`.
- **Affected files**: `scripts/create-requirement.sh`, `.github/prompts/add-requirement.prompt.md`.
- **Risk**: If the agent crashes after writing the manifest but before committing, another agent reading the on-disk manifest will see the new requirement. This is tolerable since it is no worse than today's committed-but-unenriched state.

## Dependencies

REQ-1776394634 (locking ensures the manifest read-modify-write during enrichment is safe)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
