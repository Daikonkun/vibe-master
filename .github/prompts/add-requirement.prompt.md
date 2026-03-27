---
name: "add-requirement"
description: "Create a new product requirement, regenerate requirement docs, and suggest the next worktree step. Use when: submitting a new requirement via slash command."
argument-hint: "\"Feature name\" \"Detailed description\" [CRITICAL|HIGH|MEDIUM|LOW]"
agent: "Vibe Agent Orchestrator"
---

Create a new requirement in the current workspace.

Workflow:
1. Parse the arguments as `name`, `description`, and optional `priority` with a default of `MEDIUM`.
2. Validate that `name` and `description` are present and that `priority` is one of `CRITICAL`, `HIGH`, `MEDIUM`, or `LOW`.
3. Run [create-requirement.sh](../../scripts/create-requirement.sh) with the parsed arguments.
4. Run [regenerate-docs.sh](../../scripts/regenerate-docs.sh) so [REQUIREMENTS.md](../../REQUIREMENTS.md) and the docs remain in sync.
5. Summarize the created requirement ID, the generated spec path, and the next recommended step.

Constraints:
- Do not invent a requirement ID; use the script output.
- If validation fails, explain what argument is missing or invalid.
- If a script fails, surface the exact failure and stop.
- Keep the final response concise and action-oriented.