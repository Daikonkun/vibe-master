# Review follow-up: isolate concurrent-workflow check temp logs per run

**ID**: REQ-1777270332882776949  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-27T06:12:12Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/check-concurrent-workflows.sh writes diagnostics to fixed paths under /tmp (start-race-1.log, start-race-2.log, start-a.log, start-b.log, status-a.log, status-b.log, merge-a.log, merge-b.log). Parallel executions can overwrite each other's logs and misreport failures. Required outcome: Use per-run log paths rooted under the script's mktemp workspace and ensure cleanup removes them; keep failure output deterministic under concurrent invocations.

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
