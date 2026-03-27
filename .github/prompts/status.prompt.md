---
name: "status"
description: "Regenerate and display the current project requirement dashboard. Use when: checking requirement lifecycle progress and blockers."
argument-hint: "[refresh]"
agent: "Vibe Agent Orchestrator"
---

Show the current requirement dashboard for this workspace.

Workflow:
1. Run `scripts/status.sh` from the project root.
2. Return a concise summary with:
   - total requirement count
   - in-progress count
   - blocked count
   - deployed count
3. Highlight the first 3 active IN_PROGRESS items by ID and name.

Constraints:
- If the script fails, show the exact error and stop.
- Do not invent requirement IDs or counts.
