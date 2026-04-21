# Review follow-up: harden work-on no-op guard against manifest context drift

**ID**: REQ-1776668089944983961  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-20T06:54:49Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: MEDIUM. Evidence: .github/prompts/work-on.prompt.md step 7 requires resolving active worktree path from .worktree-manifest.json, but linked feature worktrees can have stale local manifests with no self-entry, causing guard resolution failures in feature-worktree execution contexts. Required outcome: define canonical manifest lookup for /work-on and add a fallback resolver based on current repository path/branch when local worktree mapping is absent, with clear diagnostics.

## Success Criteria

- [x] `/work-on` resolves requirement/worktree lifecycle state from the canonical tracker manifests in the project root (source of truth).
- [x] When canonical mapping is unavailable or stale, `/work-on` falls back to resolving by current repository path/branch identity.
- [x] If both canonical and fallback resolution fail, `/work-on` exits with a clear, actionable diagnostic that includes next-step commands.

## Technical Notes

- OQ decision (2026-04-20): prefer canonical project-root manifests for lifecycle and worktree mapping because they are the source of truth for status transitions.
- Best-practice fallback: if canonical lookup cannot map the active REQ/worktree, infer context from current repository root and checked-out branch, then re-validate against manifests.
- Keep strict failure behavior when resolution remains ambiguous; do not guess mappings silently.


## Development Plan

1. Review the current `/work-on` flow and no-op guard contract in `.github/prompts/work-on.prompt.md`, focusing on step 7 and its constraints around active worktree resolution.
2. Implement canonical-manifest-first worktree/requirement resolution in the `/work-on` execution path, then add a fallback resolver based on current repository path and checked-out branch when local mapping is absent.
3. Preserve strict guard behavior by updating diagnostics for unresolved mappings so failures are actionable and include concrete recovery commands (`./scripts/start-work.sh <REQ-ID>` and `./scripts/worktree-list.sh`).
4. Extend and/or add focused validation in `scripts/check-work-on-no-op-guard.sh` (and adjacent no-op guard checks) to cover manifest-context drift scenarios where feature worktrees have stale local manifests.
5. Verify end-to-end behavior with `./scripts/check-work-on-no-op-guard.sh` and targeted requirement inspection via `./scripts/show-requirement.sh REQ-1776668089944983961`, then regenerate docs with `./scripts/regenerate-docs.sh` if requirement/status artifacts changed.

**Last updated**: 2026-04-21T02:15:01Z

## Dependencies

- REQ-1776655671293288695

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift
* **Branch**: feature/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift
* **Merged**: Yes
* **Deployed**: Yes
