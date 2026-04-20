# Review follow-up: include working tree evidence in work-on no-op guard

**ID**: REQ-1776668079797649000  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-20T06:54:39Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: HIGH. Evidence: .github/prompts/work-on.prompt.md step 7 uses git -C <worktree-path> diff --name-status <base-branch>...HEAD as the no-op signal, which ignores unstaged/staged working-tree changes and can falsely classify active implementation as no-op. Required outcome: no-op detection must account for both commit diff and working tree/index changes before allowing or blocking CODE_REVIEW advancement, and must avoid forcing override reasons when real uncommitted changes exist.

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
