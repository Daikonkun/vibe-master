# Review follow-up: prevent /upgrade from overwriting manifest history

**ID**: REQ-1776671113723590863  
**Status**: MERGED  
**Priority**: HIGH  
**Created**: 2026-04-20T07:45:13Z  

## Description

Source: code-review of REQ-1776670068095886474. Severity: HIGH. Evidence: scripts/upgrade.sh applies template files using rsync --delete while excluding only .git and .upgrade-template, which allows template .requirement-manifest.json and .worktree-manifest.json to overwrite project requirement/worktree history in the upgrade worktree before merge. README's Replace vs Merge Guide says these manifests must be merged, not replaced. Required outcome: update /upgrade apply behavior to preserve manifest data (exclude manifest files from blanket replace and provide explicit merge path), and add a regression check that verifies manifest records survive upgrade apply.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Update upgrade apply behavior in `scripts/upgrade.sh` so the template sync excludes `.requirement-manifest.json` and `.worktree-manifest.json` from any blanket replace path.
2. Add an explicit manifest-preservation/merge path in `scripts/upgrade.sh` (or a helper it calls) so upgrade metadata can be incorporated without overwriting existing requirement and worktree history.
3. Add a regression check script at `scripts/check-upgrade-manifest-history.sh` that seeds manifest history, runs the upgrade apply path against a fixture/template, and fails if historical requirement/worktree entries are lost.
4. Wire the new regression into validation flow by invoking `bash scripts/check-upgrade-manifest-history.sh` from local verification and any existing upgrade-related checks.
5. Regenerate and verify docs with `bash scripts/regenerate-docs.sh` and `bash scripts/show-requirement.sh REQ-1776671113723590863`, then confirm `docs/STATUS.md` and manifests still show the requirement/worktree state correctly.

**Last updated**: 2026-04-20T07:55:16Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Branch**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Merged**: Yes
* **Deployed**: No
