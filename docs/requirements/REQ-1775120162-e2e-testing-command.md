# e2e testing command

**ID**: REQ-1775120162  
**Status**: DEPLOYED  
**Priority**: MEDIUM  
**Created**: 2026-04-02T08:56:02Z  

## Description

add a /e2e-test command to perform an end-to-end test for a project developed by vibe master. if existing skills are not enough to perform one, propose to the user that an additional skill for vibe master should be developed as a new REQ.

## Success Criteria

- [ ] A `/e2e-test` slash command exists backed by a prompt file at `.github/prompts/e2e-test.prompt.md`
- [ ] Running `/e2e-test [scope]` inventories the project's existing skills (`code-review`, `debug`, `worktree-manager`, `update-manual`, `requirement-tracker`, `agent-customization`) and evaluates whether they provide sufficient coverage to test the target scope end-to-end
- [ ] When existing skills are sufficient, the command orchestrates a full end-to-end test cycle: build/lint → run tests → code-review → validate requirement criteria — and reports pass/fail with evidence
- [ ] When existing skills are insufficient (e.g., no test runner skill, no integration-test skill), the command clearly identifies the gap, explains what capability is missing, and proposes creating a new REQ for the missing skill via `/add-requirement`
- [ ] The command supports an optional `[scope]` argument to target a specific requirement ID, feature area, or the entire project

## Technical Notes

- **Prompt file**: Create `.github/prompts/e2e-test.prompt.md` following the established pattern (see `start-work.prompt.md`, `work-on.prompt.md` for YAML frontmatter and workflow structure).
- **Skill inventory**: The prompt should read the list of available skills from `.github/skills/*/SKILL.md` and map their capabilities against what an e2e test requires (build, lint, test execution, coverage analysis, etc.).
- **Gap analysis**: Compare required testing capabilities against available skill descriptions. Current skills cover: code review, debugging, worktree management, manual updates, requirement tracking, and agent customization — none provide test execution or integration testing.
- **Fallback to REQ creation**: When a gap is found, construct a concrete `/add-requirement` invocation with a name and description for the missing skill, presenting it to the user for approval.
- **Affected files**: `.github/prompts/e2e-test.prompt.md` (new), `copilot-instructions.md` (add `/e2e-test` to the slash-command table and registry paragraph).
- **Risk**: The definition of "end-to-end" varies by project — the prompt should ask the user to clarify scope if ambiguous rather than assuming a specific test strategy.


## Development Plan

1. **Create `.github/prompts/e2e-test.prompt.md`** — Write the prompt file with YAML frontmatter (`name`, `description`, `argument-hint`, `agent`) and a workflow that: parses optional `[scope]`, inventories skills from `.github/skills/*/SKILL.md`, maps capabilities to e2e testing needs, orchestrates test steps when skills suffice, and proposes `/add-requirement` for missing skills.
2. **Register `/e2e-test` in `copilot-instructions.md`** — Add a row to the slash-command table and append to the prompt-file registry paragraph.
3. **Run `./scripts/regenerate-docs.sh`** — Keep REQUIREMENTS.md and docs in sync.
4. **Verify all success criteria** — Read back the prompt file and `copilot-instructions.md` to confirm all 5 acceptance criteria are met.

**Last updated**: 2026-04-02T08:57:16Z

## Dependencies

None

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1775120162-e2e-testing-command
* **Branch**: feature/REQ-1775120162-e2e-testing-command
* **Merged**: Yes
* **Deployed**: Yes
