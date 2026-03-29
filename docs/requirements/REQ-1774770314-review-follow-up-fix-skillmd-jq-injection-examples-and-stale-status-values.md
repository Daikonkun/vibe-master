# Review follow-up: fix SKILL.md jq injection examples and stale status values

**ID**: REQ-1774770314  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-03-29T07:45:14Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: (1) requirement-tracker/SKILL.md and worktree-manager/SKILL.md use direct shell variable interpolation in jq programs instead of --arg, creating injection risk in documentation examples. (2) requirement-tracker/SKILL.md lists REVERTED as a valid transition target but REVERTED is not in the manifest schema enum or update-requirement-status.sh. Required outcome: update all SKILL.md jq examples to use --arg parameterization and replace REVERTED with CANCELLED.

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
