# Review follow-up: block no-op work-on status advancement without scoped changes

**ID**: REQ-1776655671293288695  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-20T03:27:51Z  

## Description

Source: code-review of REQ-1776415552106978163. Severity: HIGH. Evidence: linked worktree feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines has no diff versus main (git diff --name-status main...HEAD is empty), yet the workflow advanced status from IN_PROGRESS to CODE_REVIEW. Required outcome: add a /work-on no-op guard that blocks lifecycle advancement when no requirement-scoped implementation evidence exists, unless an explicit override reason is provided and recorded.

## Success Criteria

- [x] `/work-on` blocks status advancement to `CODE_REVIEW` when requirement-scoped diff evidence is empty by default.
- [x] A verification-only override path is supported for no-diff transitions, but only when the target transition is to `CODE_REVIEW`.
- [x] Override usage requires an explicit reason and persists that reason in requirement artifacts for auditability.

## Technical Notes

- Product decision (2026-04-20): verification-only requirements may advance with zero diff evidence when explicitly justified.
- Scope limit (2026-04-20): this exception must be limited to transitions targeting `CODE_REVIEW`; all other transitions keep strict evidence requirements.
- Suggested implementation path: add a dedicated guarded override in `.github/prompts/work-on.prompt.md` and mirror constraints in user-facing docs.

## Development Plan

1. Add a no-op evidence guard to `.github/prompts/work-on.prompt.md` so `IN_PROGRESS -> CODE_REVIEW` is blocked when requirement-scoped diff evidence is empty.
2. Add a verification-only override contract in `.github/prompts/work-on.prompt.md` with `--no-diff-reason "<reason>"`, restricted to no-diff transitions targeting `CODE_REVIEW`.
3. Extend `scripts/update-requirement-status.sh` to accept `--reason "text"` and persist transition audit data in `.requirement-manifest.json`.
4. Update `.requirement-manifest.schema.json`, `README.md`, and `copilot-instructions.md` so the persisted reason and `/work-on` command contract stay aligned.
5. Validate with `bash -n scripts/update-requirement-status.sh`, `./scripts/show-requirement.sh REQ-1776655671293288695`, and `./scripts/regenerate-docs.sh`.

**Last updated**: 2026-04-20T06:46:49Z

## Dependencies

- REQ-1776415552106978163

## Worktree

(Implementation tracked in dedicated feature worktree)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
