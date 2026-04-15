# auto-compacting

**ID**: REQ-1776233067  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-15T06:04:27Z  

## Description

add a feature of auto-compacting context when the context window is about to reach the limit of the working LLM

## Success Criteria

- [ ] Context compaction triggers automatically when token usage exceeds a configurable threshold (e.g., 80% of the LLM's context window limit)
- [ ] Compacted context preserves critical information: active requirement IDs, current task state, and recent tool outputs, while discarding redundant or low-priority history
- [ ] A compaction event is logged with a timestamp, pre/post token counts, and a summary of what was compacted, enabling auditability
- [ ] The user is notified (via a status message or inline note) when auto-compaction occurs, with an option to review the compacted summary
- [ ] Auto-compaction does not break ongoing multi-step workflows (e.g., a running `/start-work` or `/code-review` session continues correctly after compaction)

## Technical Notes

**Approach**: Implement a context-monitoring layer that tracks approximate token usage before each LLM call. When usage exceeds the threshold, invoke a compaction routine that:
1. Serializes the current conversation/tool history into a structured summary.
2. Replaces verbose history with the compacted summary while preserving the system prompt, active requirement context, and the last N turns.
3. Resumes the session with the reduced context.

**Affected areas**:
- `scripts/` — may need a new `compact-context.sh` or integration into existing orchestrator scripts that call LLMs.
- `.github/skills/` — skills that accumulate context (e.g., `debug`, `code-review`) should be aware of compaction events and re-emit essential state if needed.
- `.github/prompts/` — prompt templates may need a `{{compacted_summary}}` placeholder.
- `copilot-instructions.md` — document the auto-compaction behavior so the LLM agent knows it may occur.

**Risks**:
- Over-aggressive compaction may lose important context mid-workflow, causing incorrect actions.
- Token counting is approximate; the threshold must have a safety margin.
- Compaction itself consumes tokens; the routine must be lightweight or run outside the main context window.
- Different LLMs have different context limits; the threshold should be configurable per model.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776233067-auto-compacting.md`.
   - **Summary**: add a feature of auto-compacting context when the context window is about to rea
   - **Key criteria**: - [ ] Context compaction triggers automatically when token usage exceeds a configurable threshold (e
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: **Approach**: Implement a context-monitoring layer that tracks approximate token usage before each L
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776233067` and verify success criteria are met.

**Last updated**: 2026-04-15T06:07:11Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
