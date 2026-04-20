# Review follow-up: prevent /upgrade from overwriting manifest history

**ID**: REQ-1776671113723590863  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-20T07:45:13Z  

## Description

Source: code-review of REQ-1776670068095886474. Severity: HIGH. Evidence: scripts/upgrade.sh applies template files using rsync --delete while excluding only .git and .upgrade-template, which allows template .requirement-manifest.json and .worktree-manifest.json to overwrite project requirement/worktree history in the upgrade worktree before merge. README's Replace vs Merge Guide says these manifests must be merged, not replaced. Required outcome: update /upgrade apply behavior to preserve manifest data (exclude manifest files from blanket replace and provide explicit merge path), and add a regression check that verifies manifest records survive upgrade apply.

## Success Criteria

- [x] `scripts/upgrade.sh` does not blanket-replace `.requirement-manifest.json` or `.worktree-manifest.json` during `--apply`.
- [x] Upgrade apply path uses an explicit manifest merge flow that preserves local requirement/worktree history entries.
- [x] A regression check proves manifest history survives upgrade apply and is included in upgrade validation guidance.

## Technical Notes

- `scripts/upgrade.sh` now excludes both manifest files from both preview diff scope and rsync apply scope.
- `scripts/upgrade.sh` now runs explicit, JSON-validated merge logic for `.requirement-manifest.json` and `.worktree-manifest.json`, while refusing merges that would reduce history entry counts.
- Added `scripts/check-upgrade-manifest-history.sh`, which seeds manifest history, runs `scripts/upgrade.sh --apply` against a stub template, and asserts history entries/counts are preserved.
- Wired regression coverage into upgrade validation guidance in `README.md` and `.github/prompts/upgrade.prompt.md`.

## Development Plan

1. Update upgrade apply behavior in `scripts/upgrade.sh` so template sync excludes `.requirement-manifest.json` and `.worktree-manifest.json` from blanket replacement. Completed.
2. Add explicit manifest-preservation merge logic in `scripts/upgrade.sh` so upgrade metadata can be applied without overwriting local requirement/worktree history. Completed.
3. Add `scripts/check-upgrade-manifest-history.sh` to seed history and verify `scripts/upgrade.sh --apply` preserves records. Completed.
4. Wire regression command into upgrade validation flow in `README.md` and `.github/prompts/upgrade.prompt.md`. Completed.
5. Validate with `bash scripts/check-upgrade-manifest-history.sh` and `bash scripts/upgrade.sh --check-only --command-name upgrade`. Completed.

**Last updated**: 2026-04-20T08:02:00Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Branch**: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* **Merged**: No
* **Deployed**: No
