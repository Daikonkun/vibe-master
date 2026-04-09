# rollback function

**ID**: REQ-1775721596  
**Status**: IN_PROGRESS  
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

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1775721596-rollback-function.md`.
   - **Summary**: add a rolling back command to allow users to restore the project code to the poi
   - **Key criteria**: - [ ] A new `scripts/rollback-requirement.sh` script accepts a REQ ID and reverts the corresponding 
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - **Approach**: Create `scripts/rollback-requirement.sh` that identifies the merge commit for a give
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1775721596` and verify success criteria are met.

**Last updated**: 2026-04-09T08:06:36Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
