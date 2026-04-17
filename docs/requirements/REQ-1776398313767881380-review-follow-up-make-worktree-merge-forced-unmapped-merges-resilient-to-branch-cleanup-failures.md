# Review follow-up: make worktree-merge forced unmapped merges resilient to branch cleanup failures

**ID**: REQ-1776398313767881380  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-17T03:58:33Z  

## Description

Source: code-review of REQ-1776394648. Severity: HIGH. Evidence: in scripts/worktree-merge.sh, the forced unmapped-branch path proceeds to merge but still runs 'git branch -d' under set -e without fallback; if the feature branch is checked out in another worktree or cannot be deleted, the script exits non-zero after merge and does not reliably emit completion/status-skipped messaging. Required outcome: (1) in forced unmapped mode, treat branch/worktree cleanup as best-effort warnings instead of fatal errors, (2) ensure success messaging still states that no requirement statuses were updated, and (3) add a regression check covering forced unmapped merge with undeletable branch.

## Success Criteria

- [x] In `scripts/worktree-merge.sh`, forced unmapped merges (`--force` with no worktree-manifest mapping) complete even when branch/worktree cleanup fails; cleanup failures are warnings, not fatal exits
- [x] Forced unmapped merge output always includes an explicit message that no requirement status was updated
- [x] A repeatable regression check exists and passes for the undeletable-branch forced-unmapped path (`scripts/check-worktree-merge-unmapped-force.sh`)

## Technical Notes

- Added argument parsing for `--force` and explicit unmapped-branch detection in `scripts/worktree-merge.sh`.
- Introduced `UNMAPPED_FORCE_MODE` so merge cleanup (`git worktree remove`, `git branch -d`) is best-effort only in forced unmapped mode; normal mapped merges still fail fast on cleanup errors.
- Added explicit end-of-run messaging: `Completed forced unmapped merge. No requirement statuses were updated.`
- Added regression harness `scripts/check-worktree-merge-unmapped-force.sh` that creates a disposable git repo, forces branch deletion to fail via a second worktree, runs merge with `--force`, and asserts merge success plus required warning/status output.


## Development Plan

1. Add `--force` option support and unmapped-branch detection in `scripts/worktree-merge.sh`.
2. In forced unmapped mode, convert branch/worktree cleanup failures to warnings while preserving fail-fast behavior for mapped merges.
3. Ensure merge completion logs explicitly state requirement status updates were skipped for forced unmapped merges.
4. Add `scripts/check-worktree-merge-unmapped-force.sh` to reproduce undeletable-branch cleanup failure and assert successful forced-unmapped merge behavior.
5. Validate using `bash -n scripts/worktree-merge.sh`, `bash -n scripts/check-worktree-merge-unmapped-force.sh`, and `scripts/check-worktree-merge-unmapped-force.sh`.

**Last updated**: 2026-04-17T05:24:23Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
