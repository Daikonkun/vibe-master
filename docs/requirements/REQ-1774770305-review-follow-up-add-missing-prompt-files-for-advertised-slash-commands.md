# Review follow-up: add missing prompt files for advertised slash commands

**ID**: REQ-1774770305  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-03-29T07:45:05Z  

## Description

Source: code-review. Severity: HIGH. Evidence: copilot-instructions.md lists /worktree-create and /worktree-prune as available slash commands, and worktree-manager/SKILL.md advertises /worktree-status, but no corresponding .prompt.md files exist. REQ-1774628144 (DEPLOYED) was supposed to align commands but missed these three. Required outcome: either create worktree-create.prompt.md, worktree-prune.prompt.md, and worktree-status.prompt.md, or remove these commands from copilot-instructions.md and SKILL.md.

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
