# Review follow-up: block no-op work-on status advancement without scoped changes

**ID**: REQ-1776655671293288695  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-20T03:27:51Z  

## Description

Source: code-review of REQ-1776415552106978163. Severity: HIGH. Evidence: linked worktree feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines has no diff versus main (git diff --name-status main...HEAD is empty), yet the workflow advanced status from IN_PROGRESS to CODE_REVIEW. Required outcome: add a /work-on no-op guard that blocks lifecycle advancement when no requirement-scoped implementation evidence exists, unless an explicit override reason is provided and recorded.

## Success Criteria

- [ ] `/work-on` blocks status advancement to `CODE_REVIEW` when requirement-scoped diff evidence is empty by default.
- [ ] A verification-only override path is supported for no-diff transitions, but only when the target transition is to `CODE_REVIEW`.
- [ ] Override usage requires an explicit reason and persists that reason in requirement artifacts for auditability.

## Technical Notes

- Product decision (2026-04-20): verification-only requirements may advance with zero diff evidence when explicitly justified.
- Scope limit (2026-04-20): this exception must be limited to transitions targeting `CODE_REVIEW`; all other transitions keep strict evidence requirements.
- Suggested implementation path: add a dedicated guarded override in `.github/prompts/work-on.prompt.md` and mirror constraints in user-facing docs.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776655671293288695-review-follow-up-block-no-op-work-on-status-advancement-without-scoped-changes.md`.
   - **Summary**: Source: code-review of REQ-1776415552106978163. Severity: HIGH. Evidence: linked
   - **Key criteria**: - [ ] `/work-on` blocks status advancement to `CODE_REVIEW` when requirement-scoped diff evidence is
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - Product decision (2026-04-20): verification-only requirements may advance with zero diff evidence 
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776655671293288695` and verify success criteria are met.

**Last updated**: 2026-04-20T04:02:53Z

## Dependencies

- REQ-1776415552106978163

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776655671293288695-review-follow-up-block-no-op-work-on-status-advancement-without-scoped-changes
* **Branch**: feature/REQ-1776655671293288695-review-follow-up-block-no-op-work-on-status-advancement-without-scoped-changes
* **Merged**: No
* **Deployed**: No
