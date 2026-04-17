# auto-compacting

**ID**: REQ-1776233067  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-15T06:04:27Z  

## Description

add a feature of auto-compacting context when the context window is about to reach the limit of the working LLM

## Success Criteria

- [x] Context compaction triggers automatically when token usage exceeds a configurable threshold (e.g., 80% of the LLM's context window limit)
- [x] Compacted context preserves critical information: active requirement IDs, current task state, and recent tool outputs, while discarding redundant or low-priority history
- [x] A compaction event is logged with a timestamp, pre/post token counts, and a summary of what was compacted, enabling auditability
- [x] The user is notified (via a status message or inline note) when auto-compaction occurs, with an option to review the compacted summary
- [x] Auto-compaction does not break ongoing multi-step workflows (e.g., a running `/start-work` or `/code-review` session continues correctly after compaction)

## Technical Notes

**Approach**: Implement a context-monitoring layer that tracks approximate token usage before each LLM call. When usage exceeds the threshold, invoke a compaction routine that:
1. Serializes the current conversation/tool history into a structured summary.
2. Replaces verbose history with the compacted summary while preserving the system prompt, active requirement context, and the last N turns.
3. Resumes the session with the reduced context.

**Affected areas**:
- `scripts/` — new `compact-context.sh` integrated into orchestrator scripts
- `.github/skills/` — debug and code-review skills updated with compaction awareness
- `.github/prompts/` — work-on and start-work prompts updated with `{{compacted_summary}}` placeholder
- `copilot-instructions.md` — auto-compaction behavior documented

**Risks**:
- Over-aggressive compaction may lose important context mid-workflow, causing incorrect actions.
- Token counting is approximate; the threshold must have a safety margin.
- Compaction itself consumes tokens; the routine must be lightweight or run outside the main context window.
- Different LLMs have different context limits; the threshold should be configurable per model.


## Development Plan

1. **Create `scripts/compact-context.sh`** — ✅ Done. Core compaction routine with check/compact modes, token estimation, threshold comparison, history serialization, and event logging.
2. **Add threshold configuration** — ✅ Done. `.vibe-config.json` with `contextWindowLimit`, `compactionThreshold`, `preservedTurns`, `model`, and `modelOverrides` per model. Schema in `.vibe-config.schema.json`.
3. **Integrate compaction into orchestrator scripts** — ✅ Done. Compaction check hooks added to `scripts/start-work.sh` and `scripts/create-requirement.sh`.
4. **Update skills and prompts** — ✅ Done. Compaction awareness added to `debug/SKILL.md` and `code-review/SKILL.md`. `{{compacted_summary}}` placeholder added to `work-on.prompt.md` and `start-work.prompt.md`. Auto-compaction section added to `copilot-instructions.md`.
5. **Validate end-to-end** — ✅ Done. Tested with small input (no compaction needed) and large input (compaction triggered, 508K→11K tokens, 997 turns compacted, log written, notification displayed).

**Last updated**: 2026-04-15T06:30:00Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776233067-auto-compacting
* **Branch**: feature/REQ-1776233067-auto-compacting
* **Merged**: Yes
* **Deployed**: Yes
