---
name: "e2e-test"
description: "Run an end-to-end test for a vibe-master project. Inventories skills, orchestrates available test steps, and proposes new skill REQs when gaps are found."
argument-hint: "[scope]"
agent: "Vibe Agent Orchestrator"
---

Perform an end-to-end test of a vibe-master project, leveraging existing skills and surfacing gaps.

Workflow:
1. **Parse scope**: Accept an optional `[scope]` argument — a requirement ID (e.g., `REQ-1234567890`), a feature area name, or nothing (implies whole project). If scope is a requirement ID, validate it exists in `.requirement-manifest.json`.
2. **Inventory skills**: Read every `.github/skills/*/SKILL.md` file and collect each skill's `name` and `description` from the YAML frontmatter. Build a capability list from these descriptions.
3. **Define e2e test requirements**: An end-to-end test needs these capabilities:
   - **Build / lint**: compile or lint the project source
   - **Test execution**: run unit, integration, or e2e test suites
   - **Code review**: static analysis and pattern review
   - **Requirement validation**: verify that acceptance criteria from the spec are met
   - **Manual / docs check**: confirm documentation is up to date
4. **Gap analysis**: Compare the capability list (step 2) against the e2e test requirements (step 3). Classify each requirement as **covered** or **missing**.
5. **If all capabilities are covered** — orchestrate the full e2e cycle:
   a. Invoke the build/lint skill to compile or lint the project source.
   b. Invoke the test-execution skill to run the test suite.
   c. Run `/code-review [scope]` to perform a code review.
   d. If scope is a requirement ID, read its spec and verify each Success Criterion is satisfied.
   e. Report a **pass / fail** summary with evidence for each step.
6. **If any capability is missing** — for each gap:
   a. Explain what capability is missing and why it blocks e2e testing.
   b. Construct a concrete `/add-requirement` invocation that would create a new skill to fill the gap. Example:
      ```
      /add-requirement "test-runner skill" "Create a test-runner skill for vibe master that can discover and execute unit/integration/e2e test suites, report results, and integrate with the e2e-test command." HIGH
      ```
   c. Present the proposed `/add-requirement` to the user for approval. Do not auto-create.
7. **Summarize**: Report which capabilities were covered, which had gaps, what tests passed/failed, and any proposed new REQs.

Constraints:
- Never assume a test framework exists — verify by checking for config files (e.g., `jest.config.*`, `pytest.ini`, `vitest.config.*`, `package.json` scripts) before attempting to run tests.
- If scope is ambiguous or the project type is unclear, ask the user to clarify rather than guessing.
- Do not auto-create requirements for missing skills — always present proposals and wait for approval.
- Surface any failures with exact error output.
- When a gap is found, the proposed `/add-requirement` must include a clear description with acceptance criteria so the resulting REQ is actionable.
