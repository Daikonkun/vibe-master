# enlarge /worktree-merge scope

**ID**: REQ-1776999531888370737  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-24T02:58:51Z  

## Description

also allow /worktree-merge to accept REQ number as the parameter. currently it accepts branch by default

## Success Criteria

- [ ] `/worktree-merge REQ-1776999531888370737` resolves the mapped worktree branch for that requirement and merges it successfully when preconditions pass.
- [ ] Existing branch-based invocation remains supported; `/worktree-merge feature/<branch-name>` behavior is unchanged.
- [ ] If a provided REQ ID does not exist in `.requirement-manifest.json` or has no mapped worktree entry in `.worktree-manifest.json`, the command fails with a clear actionable error.
- [ ] If the REQ maps to a non-mergeable state (for example no active feature branch found), the command exits non-zero and does not perform partial merge side effects.
- [ ] Command docs/help text are updated so users can see both accepted parameter forms (REQ ID or branch).

## Technical Notes

- Primary touchpoints are `scripts/worktree-merge.sh` (argument parsing and resolution), `.github/prompts/worktree-merge.prompt.md` (usage contract), and generated docs (`REQUIREMENTS.md` + `docs/*`) after regeneration.
- Add a resolver path: detect `^REQ-[0-9]+$` input, then look up the requirement/worktree mapping from `.requirement-manifest.json` and `.worktree-manifest.json` to derive target branch; otherwise treat input as branch (current behavior).
- Preserve current merge safety checks (clean tree, lifecycle guards, `--force` behavior for unmapped merges) and ensure REQ-ID mode reuses the same downstream merge flow once branch is resolved.
- Error handling should be explicit for: unknown REQ, REQ without mapped worktree, missing branch, and ambiguous/multiple mappings (if encountered).
- Regression checks should cover both invocation modes and failures (REQ not found, REQ unmapped) to avoid breaking existing branch-first workflows.

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
