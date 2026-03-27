---
name: "start-work"
description: "Create a dedicated git worktree for a requirement and move it to IN_PROGRESS. Use when: beginning implementation for a tracked requirement."
argument-hint: "<REQ-ID> [base-branch]"
agent: "Vibe Agent Orchestrator"
---

Start implementation work for a requirement in an isolated git worktree.

Workflow:
1. Parse required `REQ-ID` and optional base branch (default `main`).
2. Run `scripts/start-work.sh` with those arguments.
3. Confirm the created worktree ID and filesystem path.
4. Confirm requirement status was updated to `IN_PROGRESS`.
5. Recommend the next action: open the worktree and begin coding.

Constraints:
- Never create multiple worktrees for the same requirement unless explicitly requested.
- If the requirement already has an active worktree, report it and stop.
- Surface script failures exactly.
