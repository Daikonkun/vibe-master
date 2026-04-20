# Review follow-up: ensure /upgrade merges manifest metadata when only manifests differ

**ID**: REQ-1776672458915568759  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-20T08:07:38Z  

## Description

Source: code-review of REQ-1776671113723590863. Severity: HIGH. Evidence: scripts/upgrade.sh computes DIFF_HAS_CHANGES from a preview diff that excludes .requirement-manifest.json and .worktree-manifest.json, then apply_template returns early when DIFF_HAS_CHANGES=false before calling merge_upgrade_manifests; this skips the explicit manifest merge path when template changes are manifest-only. scripts/check-upgrade-manifest-history.sh currently copies the full repo into its template fixture, so it does not enforce the manifest-only branch. Required outcome: ensure --apply executes manifest merge logic even when non-manifest diff is empty, and add regression coverage that fails if manifest-only template updates bypass merge.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Update `scripts/upgrade.sh` so `--apply` always runs `merge_upgrade_manifests` after confirmation, even when non-manifest preview diff is empty (`DIFF_HAS_CHANGES=false`).
2. Keep non-manifest apply behavior explicit in `scripts/upgrade.sh`: only run `rsync` when non-manifest diff exists, but preserve/merge manifest metadata in all apply runs.
3. Strengthen `scripts/check-upgrade-manifest-history.sh` to include a manifest-only template-diff scenario that fails if manifest merge is skipped.
4. Re-run upgrade validations from repo root: `bash scripts/check-upgrade-manifest-history.sh` and `bash scripts/upgrade.sh --check-only --command-name upgrade`.
5. Regenerate and verify requirement state with `bash scripts/regenerate-docs.sh` and `bash scripts/show-requirement.sh REQ-1776672458915568759`.

**Last updated**: 2026-04-20T08:13:09Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Branch**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Merged**: No
* **Deployed**: No
