# Review follow-up: harden work-on no-op guard against manifest context drift

**ID**: REQ-1776668089944983961  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-20T06:54:49Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: MEDIUM. Evidence: .github/prompts/work-on.prompt.md step 7 requires resolving active worktree path from .worktree-manifest.json, but linked feature worktrees can have stale local manifests with no self-entry, causing guard resolution failures in feature-worktree execution contexts. Required outcome: define canonical manifest lookup for /work-on and add a fallback resolver based on current repository path/branch when local worktree mapping is absent, with clear diagnostics.

## Success Criteria

- [ ] `/work-on` resolves requirement/worktree lifecycle state from the canonical tracker manifests in the project root (source of truth).
- [ ] When canonical mapping is unavailable or stale, `/work-on` falls back to resolving by current repository path/branch identity.
- [ ] If both canonical and fallback resolution fail, `/work-on` exits with a clear, actionable diagnostic that includes next-step commands.

## Technical Notes

- OQ decision (2026-04-20): prefer canonical project-root manifests for lifecycle and worktree mapping because they are the source of truth for status transitions.
- Best-practice fallback: if canonical lookup cannot map the active REQ/worktree, infer context from current repository root and checked-out branch, then re-validate against manifests.
- Keep strict failure behavior when resolution remains ambiguous; do not guess mappings silently.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift.md`.
   - **Summary**: Source: code-review of REQ-1776655671293288695. Severity: MEDIUM. Evidence: .git
   - **Key criteria**: - [ ] `/work-on` resolves requirement/worktree lifecycle state from the canonical tracker manifests 
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - OQ decision (2026-04-20): prefer canonical project-root manifests for lifecycle and worktree mappi
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776668089944983961` and verify success criteria are met.

**Last updated**: 2026-04-21T02:15:01Z

## Dependencies

- REQ-1776655671293288695

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift
* **Branch**: feature/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift
* **Merged**: No
* **Deployed**: No
