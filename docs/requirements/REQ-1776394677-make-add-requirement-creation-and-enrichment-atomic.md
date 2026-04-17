# Make add-requirement creation and enrichment atomic

**ID**: REQ-1776394677  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-17T02:57:57Z  

## Description

Source: code-review of agent concurrency flow. Severity: MEDIUM. Evidence: The /add-requirement prompt workflow is a three-phase non-atomic sequence: (1) create-requirement.sh runs and auto-commits at line 101, (2) the agent enriches spec placeholder sections and updates manifest notes field, (3) regenerate-docs.sh runs. If the agent is interrupted between phases, the manifest contains a committed but unenriched requirement with placeholder criteria, the notes field is empty, and docs are stale. A concurrent agent reading the manifest may see the incomplete record. Required outcome: (1) create-requirement.sh defers its git commit so the agent can enrich before committing. (2) Alternatively, the prompt workflow performs a single atomic commit after all enrichment is done. (3) If interrupted mid-enrichment, no partial commit is left on main.

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
