# reuse cleanup

**ID**: REQ-1774891128  
**Status**: DEPLOYED  
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

1. **Add history cleanup to `scripts/init-project.sh`** — After the manifest reset, add a step that removes `docs/requirements/REQ-*.md` (preserving `EXAMPLE-REQ-*`), then calls `scripts/regenerate-docs.sh` to rebuild `REQUIREMENTS.md`, `docs/STATUS.md`, `docs/ROADMAP.md`, and `docs/DEPENDENCIES.md` from the now-empty manifest.
2. **Update `README.md` Quick Start** — Insert a step between "Clone This Template" and "Initialize in VS Code" instructing users to run `bash scripts/init-project.sh "My Project"` to reset manifests and purge historical REQ files. Explain that this clears Vibe Master's own development history.
3. **Preserve example files** — Verify the cleanup glob in `init-project.sh` explicitly excludes `EXAMPLE-REQ-*` and `EXAMPLE-STATUS.md`. Add a guard/test.
4. **End-to-end validation** — In the worktree, simulate the user flow: run `init-project.sh`, confirm `docs/requirements/` contains only `EXAMPLE-*`, confirm `.requirement-manifest.json` has an empty `requirements` array, and confirm generated docs have no historical entries.
5. **Commit and regenerate docs** — Run `scripts/regenerate-docs.sh`, commit changes, and verify with `scripts/show-requirement.sh REQ-1774891128`.

**Last updated**: 2026-03-31T00:00:00Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1774891128-reuse-cleanup
* **Branch**: feature/REQ-1774891128-reuse-cleanup
* **Merged**: Yes
* **Deployed**: Yes
