# Add manifest file locking and collision-resistant REQ IDs

**ID**: REQ-1776394634  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-17T02:57:14Z  

## Description

Source: code-review of agent concurrency flow. Severity: HIGH. Evidence: All manifest-mutating scripts (create-requirement.sh, start-work.sh, update-requirement-status.sh, worktree-merge.sh, regenerate-docs.sh, generate-plan.sh) use lockless read-modify-write via a shared .tmp suffix, causing last-writer-wins data loss under concurrency. REQ IDs use second-resolution timestamps (date +%s) which collide when two agents create requirements in the same second. Required outcome: (1) All scripts that mutate .requirement-manifest.json or .worktree-manifest.json acquire an advisory file lock (flock) before read-modify-write and use unique temp filenames (mktemp). (2) REQ ID generation uses sub-second or UUID-based uniqueness to prevent collisions. (3) JSON schema adds a uniqueItems constraint or scripts validate ID uniqueness before insertion.

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
