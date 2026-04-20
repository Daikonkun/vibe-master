# Review follow-up: include working tree evidence in work-on no-op guard

**ID**: REQ-1776668079797649000  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-20T06:54:39Z  

## Description

Source: code-review of REQ-1776655671293288695. Severity: HIGH. Evidence: .github/prompts/work-on.prompt.md step 7 uses git -C <worktree-path> diff --name-status <base-branch>...HEAD as the no-op signal, which ignores unstaged/staged working-tree changes and can falsely classify active implementation as no-op. Required outcome: no-op detection must account for both commit diff and working tree/index changes before allowing or blocking CODE_REVIEW advancement, and must avoid forcing override reasons when real uncommitted changes exist.

## Success Criteria

- [x] `/work-on` no-op detection evaluates tracked working-tree deltas (`staged` + `unstaged`) in addition to `<base>...HEAD` commit diff evidence.
- [x] Untracked files do not count as implementation evidence for no-op detection.
- [x] The `/work-on` contract and inline diagnostics explicitly state the tracked-only evidence rule.

## Technical Notes

- OQ decision (2026-04-20): only tracked staged/unstaged deltas count for no-op evidence.
- Keep commit-diff evidence (`<base>...HEAD`) and tracked working-tree evidence as separate signals; block only when both are empty.
- Use tracked-only inspection (`git status --porcelain --untracked-files=no`) to avoid false positives from generated/untracked artifacts.


## Development Plan

1. Update step 7 in `.github/prompts/work-on.prompt.md` so no-op evidence is computed from two tracked signals: commit diff (`git -C <worktree-path> diff --name-status <base-branch>...HEAD`) and tracked working-tree/index diff (`git -C <worktree-path> status --porcelain --untracked-files=no`).
2. Update the constraints and diagnostics text in `.github/prompts/work-on.prompt.md` to state the tracked-only rule explicitly: staged/unstaged tracked deltas count as implementation evidence, untracked files do not.
3. Add regression coverage in `scripts/check-work-on-no-op-guard.sh` to assert the prompt contains both evidence commands and tracked-only semantics, then make it executable with `chmod +x scripts/check-work-on-no-op-guard.sh`.
4. Run validation commands from repo root: `scripts/check-work-on-no-op-guard.sh`, `scripts/check-docs-sync.sh`, and `scripts/regenerate-docs.sh`.
5. Re-open the requirement with `scripts/show-requirement.sh REQ-1776668079797649000`, update Success Criteria checkboxes in this spec file as items are satisfied, and advance with `/work-on REQ-1776668079797649000 CODE_REVIEW` when evidence checks pass.

**Last updated**: 2026-04-20T07:06:08Z

## Dependencies

- REQ-1776655671293288695

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776668079797649000-review-follow-up-include-working-tree-evidence-in-work-on-no-op-guard
* **Branch**: feature/REQ-1776668079797649000-review-follow-up-include-working-tree-evidence-in-work-on-no-op-guard
* **Merged**: No
* **Deployed**: No
