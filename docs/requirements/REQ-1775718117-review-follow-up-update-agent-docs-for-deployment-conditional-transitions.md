# Review follow-up: update agent docs for deployment-conditional transitions

**ID**: REQ-1775718117  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-09T07:01:57Z  

## Description

Source: code-review of REQ-1775716475. Severity: MEDIUM. Evidence: (1) work-on.prompt.md lifecycle map hard-codes MERGED→DEPLOYED without noting that MERGED is terminal when requiresDeployment=false — /work-on would erroneously try to advance past a terminal state. (2) orchestrator.agent.md state transitions show MERGED→DEPLOYED unconditionally. Required outcome: add deployment-conditional notes to both files so agents know MERGED can be terminal when requiresDeployment=false.

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
