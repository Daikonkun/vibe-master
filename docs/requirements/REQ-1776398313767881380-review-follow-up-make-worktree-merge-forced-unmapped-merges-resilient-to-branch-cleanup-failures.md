# Review follow-up: make worktree-merge forced unmapped merges resilient to branch cleanup failures

**ID**: REQ-1776398313767881380  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-17T03:58:33Z  

## Description

Source: code-review of REQ-1776394648. Severity: HIGH. Evidence: in scripts/worktree-merge.sh, the forced unmapped-branch path proceeds to merge but still runs 'git branch -d' under set -e without fallback; if the feature branch is checked out in another worktree or cannot be deleted, the script exits non-zero after merge and does not reliably emit completion/status-skipped messaging. Required outcome: (1) in forced unmapped mode, treat branch/worktree cleanup as best-effort warnings instead of fatal errors, (2) ensure success messaging still states that no requirement statuses were updated, and (3) add a regression check covering forced unmapped merge with undeletable branch.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
