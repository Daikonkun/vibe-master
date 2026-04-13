# enhance e2e test skill

**ID**: REQ-1776062513  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-13T06:41:53Z  

## Description

introduce screenshot-based cross-border test capability for /e2e-test skill

## Success Criteria

- [x] The `/e2e-test` prompt (`.github/prompts/e2e-test.prompt.md`) includes a workflow step that captures screenshots at key UI boundaries (e.g., page transitions, dialog opens, form submissions) during orchestrated test runs
- [x] A "cross-border" test phase is defined in the e2e workflow: after each skill invocation that modifies UI state, a screenshot is taken and compared against a baseline (or stored as a new baseline) to detect visual regressions across view boundaries
- [x] The e2e-test prompt specifies how screenshots are stored (e.g., `docs/e2e-screenshots/{REQ-ID}/`) and how baseline mismatches are reported in the pass/fail summary
- [x] When the project lacks a screenshot-capable test runner (e.g., Playwright, Cypress with screenshot plugin), the gap-analysis step surfaces this and proposes a `/add-requirement` for the missing capability
- [x] The existing e2e-test workflow (build/lint → test → code-review → validate criteria) remains intact; screenshot capture is an additive phase, not a replacement

## Technical Notes

- **Approach**: Extend `.github/prompts/e2e-test.prompt.md` workflow step 5 (the full e2e cycle) to insert a "screenshot capture & cross-border validation" sub-step between skill invocations that change UI state. The prompt should instruct the agent to use the project's test runner screenshot API (Playwright `page.screenshot()`, Cypress `cy.screenshot()`, etc.) and store outputs under `docs/e2e-screenshots/{scope}/`.
- **Cross-border definition**: A "border" is any UI transition point — navigation between pages, opening/closing modals, form submission redirects, or component boundary crossings in SPAs. The prompt should enumerate common border types and instruct the agent to identify project-specific borders from the codebase (e.g., route definitions, modal triggers).
- **Baseline management**: On first run, screenshots become baselines. On subsequent runs, new screenshots are diffed against baselines. The prompt should describe how to flag visual drift (pixel-diff threshold or manual review) without requiring a specific diff tool — the agent should propose the appropriate tool based on the project stack.
- **Affected files**: `.github/prompts/e2e-test.prompt.md` (primary), `copilot-instructions.md` (update `/e2e-test` description if needed), `docs/e2e-screenshots/` (new directory convention).
- **Risks**: (1) Screenshot baselines are environment-dependent (OS, browser, resolution) — the prompt should note this and recommend consistent CI environments. (2) Not all vibe-master projects have a UI — the screenshot phase should be conditional, skipped when no UI framework is detected. (3) Large screenshot sets may bloat the repo — consider `.gitignore` patterns or artifact storage.


## Development Plan

1. **Extend `.github/prompts/e2e-test.prompt.md` — add screenshot & cross-border workflow steps** — Insert a new step 3b "Detect UI framework" (check for Playwright/Cypress/Selenium config or UI framework packages; if none found, mark screenshot phase as skipped). Insert a new step 5b "Screenshot capture & cross-border validation" between steps 5a and 5c: after build/lint and test execution, capture screenshots at identified UI borders, store under `docs/e2e-screenshots/{scope}/`, diff against baselines, and report mismatches. Update step 4 gap analysis to include "screenshot-capable test runner" as a required capability. Update step 6 to propose `/add-requirement` for a screenshot tool when missing.
2. **Add baseline management & storage conventions to the prompt** — Define the `docs/e2e-screenshots/{scope}/` directory structure (baselines/ and current/ subdirs), naming convention (`{border-name}-{timestamp}.png`), and the diff reporting format in the pass/fail summary. Add a constraint about environment-dependent baselines and recommending consistent CI. Add a `.gitignore` note for large screenshot sets.
3. **Update `copilot-instructions.md`** — Update the `/e2e-test` description in the slash-command table to mention "screenshot-based cross-border testing" capability.
4. **Run `./scripts/regenerate-docs.sh`** — Keep REQUIREMENTS.md, STATUS.md, and other docs in sync.
5. **Validate all 5 success criteria** — Re-read `.github/prompts/e2e-test.prompt.md` and verify each criterion is satisfied: screenshot step exists, cross-border phase defined, storage convention specified, gap-analysis covers screenshot tooling, original workflow intact.

**Last updated**: 2026-04-13T06:42:49Z

## Dependencies

REQ-1775120162 (e2e testing command — deployed; this is the base skill being enhanced)

## Worktree

feature/REQ-1776062513-enhance-e2e-test-skill

---

* **Linked Worktree**: feature/REQ-1776062513-enhance-e2e-test-skill
* **Path**: /Users/bluoaa/Desktop/Work/Vibe Coding Stuff/feature/REQ-1776062513-enhance-e2e-test-skill
* **Branch**: feature/REQ-1776062513-enhance-e2e-test-skill
* **Merged**: No
* **Deployed**: No
