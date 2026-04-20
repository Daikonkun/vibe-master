# Review follow-up: ensure /upgrade merges manifest metadata when only manifests differ

**ID**: REQ-1776672458915568759  
**Status**: MERGED  
**Priority**: HIGH  
**Created**: 2026-04-20T08:07:38Z  

## Description

Source: code-review of REQ-1776671113723590863. Severity: HIGH. Evidence: scripts/upgrade.sh computes DIFF_HAS_CHANGES from a preview diff that excludes .requirement-manifest.json and .worktree-manifest.json, then apply_template returns early when DIFF_HAS_CHANGES=false before calling merge_upgrade_manifests; this skips the explicit manifest merge path when template changes are manifest-only. scripts/check-upgrade-manifest-history.sh currently copies the full repo into its template fixture, so it does not enforce the manifest-only branch. Required outcome: ensure --apply executes manifest merge logic even when non-manifest diff is empty, and add regression coverage that fails if manifest-only template updates bypass merge.

## Success Criteria

- [x] `scripts/upgrade.sh --apply` executes manifest merge logic even when non-manifest preview diff is empty.
- [x] Non-manifest template replacement remains explicit (`rsync` runs only when non-manifest differences are present).
- [x] Regression coverage fails if manifest-only updates bypass merge and passes when history-preserving merge executes.

## Technical Notes

- `scripts/upgrade.sh` now computes preview diffs excluding manifest files, applies non-manifest files conditionally, and always runs `merge_upgrade_manifests` during `--apply` after confirmation.
- `scripts/upgrade.sh` now excludes `.requirement-manifest.json` and `.worktree-manifest.json` from blanket `rsync` replacement, then merges manifest metadata separately while preserving local history arrays.
- `scripts/upgrade.sh` merge logic uses portable `jq --slurpfile` loading to avoid environment-specific `--argfile` failures.
- Added `scripts/check-upgrade-manifest-history.sh` to enforce a manifest-only fixture and verify both metadata merge execution and history preservation.

## Development Plan

1. Update `scripts/upgrade.sh` so `--apply` always runs `merge_upgrade_manifests` after confirmation, even when non-manifest preview diff is empty (`DIFF_HAS_CHANGES=false`). Completed.
2. Keep non-manifest apply behavior explicit in `scripts/upgrade.sh`: only run `rsync` when non-manifest diff exists, but preserve/merge manifest metadata in all apply runs. Completed.
3. Strengthen `scripts/check-upgrade-manifest-history.sh` to include a manifest-only template-diff scenario that fails if manifest merge is skipped. Completed.
4. Re-run upgrade validations from repo root: `bash scripts/check-upgrade-manifest-history.sh` and `bash scripts/upgrade.sh --check-only --command-name upgrade`. Completed.
5. Regenerate and verify requirement state with `bash scripts/regenerate-docs.sh` and `bash scripts/show-requirement.sh REQ-1776672458915568759`. Completed.

**Last updated**: 2026-04-20T08:20:28Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Branch**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Merged**: Yes
* **Deployed**: No
