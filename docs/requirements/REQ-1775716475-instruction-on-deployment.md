# instruction on deployment

**ID**: REQ-1775716475  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-09T06:34:35Z  

## Description

correctly prompt users when a project does not require deployment, REQ threads are completed at merged. and when a project needs deployment, /worktree-merge will notify the user that they still need to complete until deployed.

## Success Criteria

- [ ] A project-level configuration flag (e.g., `requiresDeployment` in `.requirement-manifest.json`) controls whether deployment is part of the requirement lifecycle
- [ ] When `requiresDeployment` is `false`, `/worktree-merge` automatically transitions linked requirements to their terminal state (DEPLOYED) so the REQ thread is fully closed at merge time
- [ ] When `requiresDeployment` is `true`, `/worktree-merge` sets status to MERGED and prints a clear reminder that the requirement is not yet complete and deployment is still required
- [ ] The `/status` command accurately reflects completion based on the deployment configuration (non-deployment projects treat MERGED as done)
- [ ] Users receive clear, actionable messaging in both paths explaining what "done" means for their project

## Technical Notes

- **`scripts/worktree-merge.sh`**: Currently hard-codes status to `MERGED` for all linked requirements. Needs to read the project-level deployment flag and conditionally set status to `DEPLOYED` (no-deploy projects) or `MERGED` with a user-facing reminder (deploy-required projects).
- **`.requirement-manifest.json`**: Add a top-level `"requiresDeployment"` boolean field (default `true` for backward-compatibility). The `init-project.sh` script and manifest schema should be updated accordingly.
- **`scripts/status.sh`**: Groups completed items as `MERGED + DEPLOYED`. For non-deployment projects, `MERGED` alone should count as complete; messaging should adjust.
- **`scripts/update-requirement-status.sh`**: Valid transitions include `MERGED → DEPLOYED`. For non-deployment projects, this transition may be skipped entirely; guard logic may be needed.
- **Agent mode (orchestrator)**: The state-transition documentation in the mode instructions references `MERGED → DEPLOYED`. Add a note that this step is conditional on deployment config.
- **Risk**: Changing terminal-state semantics could affect downstream tooling (e.g., `regenerate-docs.sh` progress calculations). Audit all scripts that reference `DEPLOYED`.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1775716475-instruction-on-deployment.md`.
   - **Summary**: correctly prompt users when a project does not require deployment, REQ threads a
   - **Key criteria**: - [ ] A project-level configuration flag (e.g., `requiresDeployment` in `.requirement-manifest.json`
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - **`scripts/worktree-merge.sh`**: Currently hard-codes status to `MERGED` for all linked requiremen
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1775716475` and verify success criteria are met.

**Last updated**: 2026-04-09T06:36:49Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
