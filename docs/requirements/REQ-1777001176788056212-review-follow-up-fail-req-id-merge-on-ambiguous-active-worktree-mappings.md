# Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings

**ID**: REQ-1777001176788056212  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-24T03:26:16Z  

## Description

Source: code-review of REQ-1777000250213162367. Severity: HIGH. Evidence: scripts/worktree-merge.sh resolves REQ-ID lookups with jq pipelines ending in head -1, so if manifest drift yields multiple ACTIVE worktrees linked to the same REQ (by stale worktreeId or duplicate requirementIds), the script silently picks one branch instead of failing. Required outcome: detect and reject ambiguous ACTIVE matches for REQ-ID resolution with explicit diagnostics listing conflicting worktree ids/branches, and add regression coverage for duplicate-match scenarios.

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings.md`.
   - **Summary**: Source: code-review of REQ-1777000250213162367. Severity: HIGH. Evidence: script
   - **Key criteria**: - [ ] Criterion 1 - [ ] Criterion 2
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: (Add implementation notes here)
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1777001176788056212` and verify success criteria are met.

**Last updated**: 2026-04-24T03:35:16Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Branch**: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* **Merged**: No
* **Deployed**: No
