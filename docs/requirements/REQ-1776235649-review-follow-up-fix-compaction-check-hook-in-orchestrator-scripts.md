# Review follow-up: fix compaction check hook in orchestrator scripts

**ID**: REQ-1776235649  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-15T06:47:29Z  

## Description

Source: code-review REQ-1776233067. Severity: HIGH. Evidence: start-work.sh and create-requirement.sh call compact-context.sh check without providing stdin input, so the check reads nothing (0 tokens) and always reports OK — the hook is a no-op. Impact: compaction check never detects when context is near limit during script execution. Required outcome: redesign the check hook so it works meaningfully in the bash script context — either pass an explicit empty input and accept the no-op behavior as informational, or have the AI agent call compact-context.sh directly rather than embedding it in bash scripts. The script-based hook should at minimum not hang on stdin.

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
