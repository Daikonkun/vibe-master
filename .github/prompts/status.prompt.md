---
name: "status"
description: "Regenerate and display the current project requirement dashboard. Use when: checking requirement lifecycle progress and blockers."
argument-hint: "[refresh]"
agent: "Vibe Agent Orchestrator"
---

**Platform Note**: On Windows, use `scripts/dispatch.ps1 <name>` instead of `scripts/<name>.sh`. On Linux/macOS, use `scripts/dispatch.sh <name>`.

Show the current requirement dashboard for this workspace.

Workflow:
1. Run `scripts/dispatch.ps1 status` (or `scripts/dispatch.sh status` on Linux/macOS) from the project root.
2. Return a concise summary with:
   - total requirement count
   - outstanding requirement count (excluding MERGED, DEPLOYED, CANCELLED)
   - completed count (MERGED + DEPLOYED)
3. Include the outstanding REQ IDs grouped by status.
4. Include a separate Completed section with MERGED and DEPLOYED counts only (no ID lists).

Constraints:
- If the script fails, show the exact error and stop.
- Do not invent requirement IDs or counts.
