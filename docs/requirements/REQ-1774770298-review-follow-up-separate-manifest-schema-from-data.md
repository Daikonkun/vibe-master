# Review follow-up: separate manifest schema from data

**ID**: REQ-1774770298  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-03-29T07:44:58Z  

## Description

Source: code-review. Severity: HIGH. Evidence: .requirement-manifest.json and .worktree-manifest.json both embed JSON Schema keywords (properties, type, title, description) alongside actual data arrays at the same level. This fails JSON Schema validation and causes semantic ambiguity with the required keyword. Required outcome: move schema definitions to separate .schema.json files referenced by a top-level dollar-schema key, keeping manifests as pure data files.

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
