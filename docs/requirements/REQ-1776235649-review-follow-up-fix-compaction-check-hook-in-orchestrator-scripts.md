# Review follow-up: fix compaction check hook in orchestrator scripts

**ID**: REQ-1776235649  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-15T06:47:29Z  

## Description

Source: code-review REQ-1776233067. Severity: HIGH. Evidence: start-work.sh and create-requirement.sh call compact-context.sh check without providing stdin input, so the check reads nothing (0 tokens) and always reports OK — the hook is a no-op. Impact: compaction check never detects when context is near limit during script execution. Required outcome: redesign the check hook so it works meaningfully in the bash script context — either pass an explicit empty input and accept the no-op behavior as informational, or have the AI agent call compact-context.sh directly rather than embedding it in bash scripts. The script-based hook should at minimum not hang on stdin.

## Success Criteria

- [ ] The compaction check hook in `scripts/start-work.sh` and `scripts/create-requirement.sh` does not hang waiting for stdin input
- [ ] The hook either (a) passes explicit empty input so it exits cleanly as a no-op, or (b) is removed from bash scripts entirely with guidance that the AI agent should call `compact-context.sh` directly
- [ ] `copilot-instructions.md` documents the recommended way to invoke compaction checks (agent-driven vs script-embedded)
- [ ] Running `scripts/start-work.sh` or `scripts/create-requirement.sh` without any piped input completes without hanging or error

## Technical Notes

**Recommended approach**: Remove the compaction check hook from bash scripts (start-work.sh, create-requirement.sh) since they don't have access to the LLM's conversation context. Instead, document in `copilot-instructions.md` that the AI agent should call `scripts/compact-context.sh check` and `scripts/compact-context.sh compact` directly when it detects its context is growing large. The agent has access to the conversation JSON and can pipe it to the script.

**Affected files**:
- `scripts/start-work.sh` — remove compaction check block
- `scripts/create-requirement.sh` — remove compaction check block
- `copilot-instructions.md` — add agent-driven compaction guidance

**Risks**: None — the current hook is already a no-op, so removing it changes no behavior.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776235649-review-follow-up-fix-compaction-check-hook-in-orchestrator-scripts.md`.
   - **Summary**: Source: code-review REQ-1776233067. Severity: HIGH. Evidence: start-work.sh and 
   - **Key criteria**: - [ ] The compaction check hook in `scripts/start-work.sh` and `scripts/create-requirement.sh` does 
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: **Recommended approach**: Remove the compaction check hook from bash scripts (start-work.sh, create-
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776235649` and verify success criteria are met.

**Last updated**: 2026-04-15T07:02:37Z

## Dependencies

REQ-1776233067 (auto-compacting — parent feature)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
