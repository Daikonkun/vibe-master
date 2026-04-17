# Isolate worktree-merge git side-effects from concurrent agents

**ID**: REQ-1776394648  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-17T02:57:28Z  

## Description

Source: code-review of agent concurrency flow. Severity: HIGH. Evidence: worktree-merge.sh runs git add -A (line 33) which stages ALL dirty files including other agents in-flight edits, then commits them as auto-commit manifest and docs. It also stashes remaining untracked changes (line 42). When an unmapped branch is merged (no worktree-manifest entry), requirement status updates are silently skipped (lines 60-92). Required outcome: (1) Replace git add -A with explicit file list matching only the current merge operation files. (2) Refuse to stash if unrelated dirty files exist — surface an error instead. (3) When branch is not mapped in worktree manifest, warn and require --force or explicit confirmation before proceeding. (4) Never auto-commit files that do not belong to the current merge operation.

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
