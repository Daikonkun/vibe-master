# Review follow-up: include working tree evidence in work-on no-op guard

**ID**: REQ-1776668079797649000  
**Status**: PROPOSED  
**Priority**: HIGH  
**Created**: 2026-04-20T06:54:39Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: HIGH. Evidence: .github/prompts/work-on.prompt.md step 7 uses git -C <worktree-path> diff --name-status <base-branch>...HEAD as the no-op signal, which ignores unstaged/staged working-tree changes and can falsely classify active implementation as no-op. Required outcome: no-op detection must account for both commit diff and working tree/index changes before allowing or blocking CODE_REVIEW advancement, and must avoid forcing override reasons when real uncommitted changes exist.

## Success Criteria

- [ ] `/work-on` no-op detection evaluates tracked working-tree deltas (`staged` + `unstaged`) in addition to `<base>...HEAD` commit diff evidence.
- [ ] Untracked files do not count as implementation evidence for no-op detection.
- [ ] The `/work-on` contract and inline diagnostics explicitly state the tracked-only evidence rule.

## Technical Notes

- OQ decision (2026-04-20): only tracked staged/unstaged deltas count for no-op evidence.
- Keep commit-diff evidence (`<base>...HEAD`) and tracked working-tree evidence as separate signals; block only when both are empty.
- Use tracked-only inspection (`git status --porcelain --untracked-files=no`) to avoid false positives from generated/untracked artifacts.

## Dependencies

- REQ-1776655671293288695

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
