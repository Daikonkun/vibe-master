# Review follow-up: enforce docs-to-prompt parity in command guard

**ID**: REQ-1777450596380408287  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-29T08:16:36Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/check-command-entrypoints.sh only verifies prompt files appear in docs by iterating .github/prompts and checking grep in docs, but it does not enumerate documented slash commands and verify corresponding prompt files exist, so ghost commands can be documented without detection. Required outcome: extend command-entrypoint guard to parse documented slash commands from docs/COMMAND_MAP.md and copilot-instructions.md, validate prompt backing (or explicit skill-only allowlist), and fail when docs advertise unsupported commands.

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
