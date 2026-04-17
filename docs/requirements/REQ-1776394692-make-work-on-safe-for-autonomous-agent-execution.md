# Make work-on safe for autonomous agent execution

**ID**: REQ-1776394692  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:58:12Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: (1) work-on.prompt.md step 7 requires interactive user confirmation before advancing status (line 40: Ask the user for confirmation exactly once), which blocks unattended agent pipelines. (2) When a PROPOSED requirement has no worktree, work-on auto-invokes /start-work (line 23) — two parallel /work-on agents targeting the same REQ can both trigger /start-work simultaneously, racing on branch creation and manifest updates. Required outcome: (1) Add an --auto or agent-mode flag that skips the confirmation gate when the caller is a trusted orchestrator agent. (2) Add a check-and-set guard so only the first /work-on invocation triggers /start-work; the second detects the in-flight worktree creation and waits or fails gracefully. (3) Document the autonomous execution contract in the prompt file.

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
