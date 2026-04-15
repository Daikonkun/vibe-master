# init-project script enhancement

**ID**: REQ-1776238348  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-15T07:32:28Z  

## Description

some DEPLOYED REQs still exists when I run the init command to start a new project. also the REQ docs in requirements are not cleared after running the init for the other project. fix this carefully, do not clear the current vibe master project.

## Success Criteria

- [ ] Running `init-project.sh` on a cloned/copied Vibe Master repo clears ALL existing REQs from `.requirement-manifest.json` (both `origin: "vibe-master"` and `origin: "project"`), leaving an empty requirements array
- [ ] All REQ spec files in `docs/requirements/` are removed for every cleared requirement, not just those with `origin: "vibe-master"`
- [ ] The `.vibe-master-source` guard in `init-project.sh` continues to prevent running init on the actual Vibe Master source repository
- [ ] The EXAMPLE-REQ spec file (`EXAMPLE-REQ-1704067200-user-auth.md`) is preserved as a template reference
- [ ] After init, `REQUIREMENTS.md`, `docs/STATUS.md`, `docs/ROADMAP.md`, and `docs/DEPENDENCIES.md` are regenerated with no stale REQ entries

## Technical Notes

**Root cause**: `init-project.sh` (lines 44–65) filters REQs by `select(.origin == "vibe-master")`. REQs created with `create-requirement.sh` get `"origin": "project"` (line 45 of that script), so they survive the init filter. Additionally, the file cleanup loop only deletes spec files for IDs matched by the vibe-master filter — project-origin spec files are never touched.

**Approach**: Change the init logic to remove ALL requirements from the manifest when initializing a new project (the `.vibe-master-source` guard already prevents accidental runs on Vibe Master itself). Correspondingly, extend the spec file cleanup to remove all `REQ-*` files from `docs/requirements/` except the `EXAMPLE-REQ-*` template.

**Affected files**:
- `scripts/init-project.sh` — main fix: replace origin-based filter with full clear
- No changes needed to `create-requirement.sh` or the `.vibe-master-source` guard

**Risks**: If a user has already created project-specific REQs before running init, those will be lost. This is acceptable because init is intended to be run once at the start of a new project. Add a confirmation prompt or document this behavior.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776238348-init-project-script-enhancement.md`.
   - **Summary**: some DEPLOYED REQs still exists when I run the init command to start a new proje
   - **Key criteria**: - [ ] Running `init-project.sh` on a cloned/copied Vibe Master repo clears ALL existing REQs from `.
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: **Root cause**: `init-project.sh` (lines 44–65) filters REQs by `select(.origin == "vibe-master")`. 
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776238348` and verify success criteria are met.

**Last updated**: 2026-04-15T07:34:45Z

## Dependencies

- REQ-1775141920 (add-init-command) — the init command this requirement fixes

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
