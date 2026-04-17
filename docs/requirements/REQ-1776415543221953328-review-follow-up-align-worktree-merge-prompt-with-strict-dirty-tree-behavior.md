# Review follow-up: align worktree-merge prompt with strict dirty-tree behavior

**ID**: REQ-1776415543221953328  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-17T08:45:43Z  

## Description

Source: code-review of delegated REQ flow. Severity: HIGH. Evidence: .github/prompts/worktree-merge.prompt.md says dirty working trees are auto-committed/stashed, but scripts/worktree-merge.sh aborts immediately when dirty. Required outcome: align prompt/docs with actual strict clean-tree guard and document exact pre-merge cleanup steps.

## Success Criteria

- [x] `.github/prompts/worktree-merge.prompt.md` no longer claims auto-commit/stash behavior for dirty trees
- [x] Prompt constraints explicitly state strict clean-tree gating and user remediation steps before retry
- [x] Command reference docs align with strict clean-tree merge behavior

## Technical Notes

- Decision confirmed on 2026-04-17: strict clean-tree merge behavior is the source of truth.
- Updated files: `.github/prompts/worktree-merge.prompt.md`, `README.md`, `copilot-instructions.md`.
- Keep `scripts/worktree-merge.sh` as the behavioral authority; prompt/docs must not describe auto-stash or auto-commit fallback.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776415543221953328-review-follow-up-align-worktree-merge-prompt-with-strict-dirty-tree-behavior.md`.
   - **Summary**: Source: code-review of delegated REQ flow. Severity: HIGH. Evidence: .github/pro
   - **Key criteria**: - [x] `.github/prompts/worktree-merge.prompt.md` no longer claims auto-commit/stash behavior for dir
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - Decision confirmed on 2026-04-17: strict clean-tree merge behavior is the source of truth.
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776415543221953328` and verify success criteria are met.

**Last updated**: 2026-04-17T09:17:22Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
