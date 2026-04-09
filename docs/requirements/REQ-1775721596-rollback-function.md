# rollback function

**ID**: REQ-1775721596  
**Status**: MERGED  
**Priority**: MEDIUM  
**Created**: 2026-04-09T07:59:56Z  

## Description

add a rolling back command to allow users to restore the project code to the point where a REQ is not yet merged

## Success Criteria

- [ ] A new `scripts/rollback-requirement.sh` script accepts a REQ ID and reverts the corresponding merge commit on the base branch
- [ ] After rollback, the requirement's status in `.requirement-manifest.json` is set back to `IN_PROGRESS` (or `CODE_REVIEW`) and `deployedAt`/`mergedAt` timestamps are cleared
- [ ] The worktree manifest (`.worktree-manifest.json`) is updated to reflect the re-opened worktree state (status reverted from `MERGED` to `ACTIVE`)
- [ ] The rollback is safe: it refuses to operate if there are subsequent merge commits that depend on the target merge, and warns the user accordingly
- [ ] Running `regenerate-docs.sh` after rollback correctly reflects the reverted status in `REQUIREMENTS.md`, `STATUS.md`, and `ROADMAP.md`

## Technical Notes

- **Approach**: Create `scripts/rollback-requirement.sh` that identifies the merge commit for a given REQ branch (using the branch name pattern `feature/REQ-{id}-{slug}` from the worktree manifest) and runs `git revert -m 1 <merge-commit>` to cleanly undo it.
- **Affected files**:
  - New script: `scripts/rollback-requirement.sh`
  - Manifest updates: `.requirement-manifest.json` (revert status, clear `deployedAt`), `.worktree-manifest.json` (revert worktree status from `MERGED` to `ACTIVE`, clear `mergedAt`)
  - Docs regeneration via `scripts/regenerate-docs.sh`
  - Potential new prompt file under `.github/prompts/` for a `/rollback` slash command
- **State transition**: This introduces a reverse transition (`MERGED → IN_PROGRESS` or `DEPLOYED → IN_PROGRESS`) not currently in `scripts/update-requirement-status.sh`. The rollback script should bypass normal transition validation or use `--force`, or the valid-transitions map should be extended.
- **Risks**: Reverting a merge that other later merges depend on can cause conflicts. The script should detect if newer commits exist on the base branch after the target merge and warn or abort. Worktree recreation (`git worktree add`) may fail if the branch was deleted by `worktree-merge.sh`; the script should recreate the branch from the reverted state.


## Development Plan

1. **Create `scripts/rollback-requirement.sh`** — Accept a `REQ-ID` argument. Look up the branch name from `.worktree-manifest.json` (pattern `feature/REQ-{id}-{slug}`). Find the merge commit on the base branch via `git log --merges --grep="Merge $BRANCH"`. Run `git revert -m 1 <merge-sha>` to undo it. Before reverting, check whether newer merge commits exist after the target and abort with a warning if so.
2. **Revert manifest state** — In the same script, use `jq` to update `.requirement-manifest.json`: set requirement status back to `IN_PROGRESS`, clear `deployedAt`, and update `updatedAt`. Also update `.worktree-manifest.json`: set worktree status from `MERGED` back to `ACTIVE` and clear `mergedAt`.
3. **Recreate the worktree branch** — After reverting, recreate the feature branch (`git branch feature/REQ-{id}-{slug} HEAD`) and re-add the worktree (`git worktree add <path> <branch>`) so the developer can resume work. Handle the case where the branch was deleted by `scripts/worktree-merge.sh`.
4. **Regenerate docs & commit** — Call `scripts/regenerate-docs.sh` to sync `REQUIREMENTS.md`, `docs/STATUS.md`, `docs/ROADMAP.md`, and `docs/DEPENDENCIES.md`. Stage and commit the manifest + doc changes.
5. **Add `/rollback` prompt file** — Create `.github/prompts/rollback.prompt.md` that documents the slash command interface, parsing the `REQ-ID` argument and invoking `scripts/rollback-requirement.sh`.

**Last updated**: 2026-04-09T08:06:36Z

## Dependencies

None

## Worktree

feature/REQ-1775721596-rollback-function

---

* **Linked Worktree**: feature/REQ-1775721596-rollback-function
* **Branch**: feature/REQ-1775721596-rollback-function
* **Merged**: No
* **Deployed**: No
