# Harden lifecycle enforcement in start-work and worktree-merge

**ID**: REQ-1776394663  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:57:43Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: (1) start-work.sh sets status to IN_PROGRESS unconditionally (line 92) without checking current status — a MERGED, DEPLOYED, or CANCELLED requirement can be reopened. (2) worktree-merge.sh only warns when requirement is not in CODE_REVIEW (line 97-98) then proceeds to set MERGED/DEPLOYED anyway, allowing merge before review. (3) orchestrator.agent.md declares Any to BACKLOG and Any to CANCELLED (lines 116-117) but update-requirement-status.sh has a narrower transition table — DEPLOYED only allows CANCELLED, CODE_REVIEW does not allow BACKLOG. Required outcome: (1) start-work.sh validates current status is PROPOSED or BACKLOG before proceeding; reject otherwise. (2) worktree-merge.sh rejects merge unless requirement is CODE_REVIEW or IN_PROGRESS; add --force flag for override. (3) Align orchestrator.agent.md state transition docs with the actual allowed_transitions() function in update-requirement-status.sh.

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
