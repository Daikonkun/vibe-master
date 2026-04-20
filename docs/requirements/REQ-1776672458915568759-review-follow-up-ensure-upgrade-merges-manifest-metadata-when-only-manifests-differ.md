# Review follow-up: ensure /upgrade merges manifest metadata when only manifests differ

**ID**: REQ-1776672458915568759  
**Status**: IN_PROGRESS  
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

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ.md`.
   - **Summary**: Source: code-review of REQ-1776671113723590863. Severity: HIGH. Evidence: script
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776672458915568759` and verify success criteria are met.

**Last updated**: 2026-04-20T08:12:36Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Branch**: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* **Merged**: No
* **Deployed**: No
