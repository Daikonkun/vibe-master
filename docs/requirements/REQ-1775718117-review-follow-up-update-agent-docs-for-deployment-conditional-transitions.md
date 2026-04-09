# Review follow-up: update agent docs for deployment-conditional transitions

**ID**: REQ-1775718117  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-09T07:01:57Z  

## Description

Source: code-review of REQ-1775716475. Severity: MEDIUM. Evidence: (1) work-on.prompt.md lifecycle map hard-codes MERGED→DEPLOYED without noting that MERGED is terminal when requiresDeployment=false — /work-on would erroneously try to advance past a terminal state. (2) orchestrator.agent.md state transitions show MERGED→DEPLOYED unconditionally. Required outcome: add deployment-conditional notes to both files so agents know MERGED can be terminal when requiresDeployment=false.

## Success Criteria

- [ ] `work-on.prompt.md` lifecycle map treats MERGED as terminal when `requiresDeployment=false` (reads flag from manifest before determining next status)
- [ ] `orchestrator.agent.md` state transition diagram annotates `MERGED → DEPLOYED` as conditional on `requiresDeployment=true`
- [ ] Both files remain accurate for the `requiresDeployment=true` (default) path

## Technical Notes

- **`.github/prompts/work-on.prompt.md`**: Step 3 lifecycle map needs a conditional: when `requiresDeployment=false`, MERGED should be listed as a terminal state (same as DEPLOYED/CANCELLED).
- **`.github/agents/orchestrator.agent.md`**: State transition block (line ~113) needs an annotation on `MERGED → DEPLOYED` noting it only applies when `requiresDeployment=true`.
- Small, doc-only change — no script modifications needed.

## Dependencies

REQ-1775716475

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
