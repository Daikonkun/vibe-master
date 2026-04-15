# Review follow-up: fix compaction check hook in orchestrator scripts

**ID**: REQ-1776235649  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-04-15T06:47:29Z  

## Description

Source: code-review REQ-1776233067. Severity: HIGH. Evidence: start-work.sh and create-requirement.sh call compact-context.sh check without providing stdin input, so the check reads nothing (0 tokens) and always reports OK — the hook is a no-op. Impact: compaction check never detects when context is near limit during script execution. Required outcome: redesign the check hook so it works meaningfully in the bash script context — either pass an explicit empty input and accept the no-op behavior as informational, or have the AI agent call compact-context.sh directly rather than embedding it in bash scripts. The script-based hook should at minimum not hang on stdin.

## Success Criteria

- [x] The compaction check hook in `scripts/start-work.sh` and `scripts/create-requirement.sh` does not hang waiting for stdin input
- [x] The hook either (a) passes explicit empty input so it exits cleanly as a no-op, or (b) is removed from bash scripts entirely with guidance that the AI agent should call `compact-context.sh` directly
- [x] `copilot-instructions.md` documents the recommended way to invoke compaction checks (agent-driven vs script-embedded)
- [x] Running `scripts/start-work.sh` or `scripts/create-requirement.sh` without any piped input completes without hanging or error

## Technical Notes

**Recommended approach**: Remove the compaction check hook from bash scripts (start-work.sh, create-requirement.sh) since they don't have access to the LLM's conversation context. Instead, document in `copilot-instructions.md` that the AI agent should call `scripts/compact-context.sh check` and `scripts/compact-context.sh compact` directly when it detects its context is growing large. The agent has access to the conversation JSON and can pipe it to the script.

**Affected files**:
- `scripts/start-work.sh` — remove compaction check block
- `scripts/create-requirement.sh` — remove compaction check block
- `copilot-instructions.md` — add agent-driven compaction guidance

**Risks**: None — the current hook is already a no-op, so removing it changes no behavior.


## Development Plan

1. **Remove compaction check hook from `scripts/start-work.sh`** — Delete the `# Auto-compaction check (REQ-1776233067)` block (lines that call `compact-context.sh check`). The hook is a no-op since bash scripts don't have conversation context.
2. **Remove compaction check hook from `scripts/create-requirement.sh`** — Delete the same compaction check block from this script.
3. **Verify `copilot-instructions.md` already has agent-driven compaction guidance** — The "Agent-Driven Compaction" subsection was added in the parent feature's LOW fix commit. Confirm it's present and sufficient; if not, enhance it.
4. **Test both scripts** — Run `scripts/start-work.sh` and `scripts/create-requirement.sh` to confirm they no longer call compact-context.sh and don't hang on stdin.
5. **Regenerate docs** — Run `scripts/regenerate-docs.sh` and verify with `scripts/show-requirement.sh REQ-1776235649`.

**Last updated**: 2026-04-15T07:02:37Z

## Dependencies

REQ-1776233067 (auto-compacting — parent feature)

## Worktree

feature/REQ-1776235649-review-follow-up-fix-compaction-check-hook-in-orchestrator-scripts

---

* **Linked Worktree**: /Users/bluoaa/Desktop/Work/Vibe Coding Stuff/feature/REQ-1776235649-review-follow-up-fix-compaction-check-hook-in-orchestrator-scripts
* **Branch**: feature/REQ-1776235649-review-follow-up-fix-compaction-check-hook-in-orchestrator-scripts
* **Merged**: No
* **Deployed**: No
