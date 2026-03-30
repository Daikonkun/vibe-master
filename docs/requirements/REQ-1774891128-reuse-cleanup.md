# reuse cleanup

**ID**: REQ-1774891128  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-03-30T17:18:48Z  

## Description

for users who clone the repo to inititate their project, they may not wish to see the REQ and Roadmap history of Vibe Master. this will be confusing. consider either cleanup the github repo or add an instruction for agents/users on not loading the historical REQs

## Success Criteria

- [ ] After cloning/forking Vibe Master, a user or agent can run a single command (or documented step) to remove all historical REQ records from `.requirement-manifest.json` and `docs/requirements/`
- [ ] `scripts/init-project.sh` (or a new cleanup script) purges existing `docs/requirements/REQ-*.md` files and resets the manifest's `requirements` array to empty
- [ ] Generated docs (`REQUIREMENTS.md`, `docs/STATUS.md`, `docs/ROADMAP.md`, `docs/DEPENDENCIES.md`) are regenerated clean after cleanup, containing no historical Vibe Master entries
- [ ] `README.md` Quick Start section includes a clear instruction about running the cleanup step before submitting the first requirement
- [ ] The example requirement file (`EXAMPLE-REQ-*`) is preserved as a reference while real historical REQ files are removed

## Technical Notes

- **Approach**: Two viable options — (A) enhance `scripts/init-project.sh` to also delete `docs/requirements/REQ-*.md` (excluding `EXAMPLE-*`) and call `scripts/regenerate-docs.sh`, or (B) create a dedicated `scripts/cleanup-history.sh` for users who want explicit control. Option A is simpler and aligns with the existing init workflow.
- **Affected files**: `scripts/init-project.sh`, `README.md` (Quick Start section), `docs/requirements/REQ-*.md`, `.requirement-manifest.json`, `docs/STATUS.md`, `docs/ROADMAP.md`, `docs/DEPENDENCIES.md`
- **Current gap**: `init-project.sh` resets `.requirement-manifest.json` and `.worktree-manifest.json` to empty state but does NOT remove files under `docs/requirements/` — those historical spec files persist after init.
- **The `README.md` Quick Start** tells users to `git clone` and `git remote remove origin` but never mentions running `init-project.sh` or cleaning up existing REQ files — this is the main source of confusion.
- **Risk**: Users who have already started adding their own REQs alongside historical ones need a safe path — cleanup should only target REQs predating their project's first init timestamp or provide an interactive confirmation.
- **Pattern note**: `EXAMPLE-REQ-*` and `EXAMPLE-STATUS.md` already establish a convention for template examples vs real data; the cleanup should preserve these.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1774891128-reuse-cleanup.md`.
   - **Summary**: for users who clone the repo to inititate their project, they may not wish to se
   - **Key criteria**: - [ ] After cloning/forking Vibe Master, a user or agent can run a single command (or documented ste
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - **Approach**: Two viable options — (A) enhance `scripts/init-project.sh` to also delete `docs/requ
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1774891128` and verify success criteria are met.

**Last updated**: 2026-03-30T17:22:13Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
