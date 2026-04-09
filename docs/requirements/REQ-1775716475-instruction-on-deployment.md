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

1. **Add `requiresDeployment` flag to manifest and init script**
   - Add `"requiresDeployment": true` top-level field to `.requirement-manifest.json` (default `true` for backward-compat).
   - Update `scripts/init-project.sh` to include the flag in newly created manifests.

2. **Update `scripts/worktree-merge.sh` to be deployment-aware**
   - After merge, read `requiresDeployment` from `.requirement-manifest.json`.
   - If `false`: set linked requirement status to `DEPLOYED` (terminal) and print "✅ Requirement complete (no deployment required)."
   - If `true` (default): keep status as `MERGED` and print "⚠️ Requirement merged but not yet deployed. Run deployment, then update status to DEPLOYED."

3. **Update `scripts/status.sh` completion logic**
   - Read `requiresDeployment` flag. When `false`, treat `MERGED` as a completed/terminal state in counts and messaging (alongside `DEPLOYED`).
   - When `true`, keep existing behavior (only `DEPLOYED` is terminal).

4. **Audit `scripts/regenerate-docs.sh` and `scripts/update-requirement-status.sh`**
   - In `regenerate-docs.sh`: adjust progress percentage calculation to respect `requiresDeployment`.
   - In `update-requirement-status.sh`: when `requiresDeployment` is `false`, skip or warn on `MERGED → DEPLOYED` transitions since they happen automatically.

5. **Validate end-to-end**
   - Run `scripts/regenerate-docs.sh` and `scripts/status.sh` to confirm correct output.
   - Verify `scripts/show-requirement.sh REQ-1775716475` reflects the updated spec.
   - Confirm messaging in both deployment and non-deployment scenarios.

**Last updated**: 2026-04-09T06:38:00Z

## Dependencies

None

## Worktree

feature/REQ-1775716475-instruction-on-deployment

---

* **Linked Worktree**: feature/REQ-1775716475-instruction-on-deployment
* **Branch**: feature/REQ-1775716475-instruction-on-deployment
* **Merged**: No
* **Deployed**: No
