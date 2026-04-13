# enhance e2e test skill

**ID**: REQ-1776062513  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-13T06:41:53Z  

## Description

introduce screenshot-based cross-border test capability for /e2e-test skill

## Success Criteria

- [ ] The `/e2e-test` prompt (`.github/prompts/e2e-test.prompt.md`) includes a workflow step that captures screenshots at key UI boundaries (e.g., page transitions, dialog opens, form submissions) during orchestrated test runs
- [ ] A "cross-border" test phase is defined in the e2e workflow: after each skill invocation that modifies UI state, a screenshot is taken and compared against a baseline (or stored as a new baseline) to detect visual regressions across view boundaries
- [ ] The e2e-test prompt specifies how screenshots are stored (e.g., `docs/e2e-screenshots/{REQ-ID}/`) and how baseline mismatches are reported in the pass/fail summary
- [ ] When the project lacks a screenshot-capable test runner (e.g., Playwright, Cypress with screenshot plugin), the gap-analysis step surfaces this and proposes a `/add-requirement` for the missing capability
- [ ] The existing e2e-test workflow (build/lint → test → code-review → validate criteria) remains intact; screenshot capture is an additive phase, not a replacement

## Technical Notes

- **Approach**: Extend `.github/prompts/e2e-test.prompt.md` workflow step 5 (the full e2e cycle) to insert a "screenshot capture & cross-border validation" sub-step between skill invocations that change UI state. The prompt should instruct the agent to use the project's test runner screenshot API (Playwright `page.screenshot()`, Cypress `cy.screenshot()`, etc.) and store outputs under `docs/e2e-screenshots/{scope}/`.
- **Cross-border definition**: A "border" is any UI transition point — navigation between pages, opening/closing modals, form submission redirects, or component boundary crossings in SPAs. The prompt should enumerate common border types and instruct the agent to identify project-specific borders from the codebase (e.g., route definitions, modal triggers).
- **Baseline management**: On first run, screenshots become baselines. On subsequent runs, new screenshots are diffed against baselines. The prompt should describe how to flag visual drift (pixel-diff threshold or manual review) without requiring a specific diff tool — the agent should propose the appropriate tool based on the project stack.
- **Affected files**: `.github/prompts/e2e-test.prompt.md` (primary), `copilot-instructions.md` (update `/e2e-test` description if needed), `docs/e2e-screenshots/` (new directory convention).
- **Risks**: (1) Screenshot baselines are environment-dependent (OS, browser, resolution) — the prompt should note this and recommend consistent CI environments. (2) Not all vibe-master projects have a UI — the screenshot phase should be conditional, skipped when no UI framework is detected. (3) Large screenshot sets may bloat the repo — consider `.gitignore` patterns or artifact storage.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776062513-enhance-e2e-test-skill.md`.
   - **Summary**: introduce screenshot-based cross-border test capability for /e2e-test skill
   - **Key criteria**: - [ ] The `/e2e-test` prompt (`.github/prompts/e2e-test.prompt.md`) includes a workflow step that ca
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - **Approach**: Extend `.github/prompts/e2e-test.prompt.md` workflow step 5 (the full e2e cycle) to 
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776062513` and verify success criteria are met.

**Last updated**: 2026-04-13T06:42:49Z

## Dependencies

REQ-1775120162 (e2e testing command — deployed; this is the base skill being enhanced)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
