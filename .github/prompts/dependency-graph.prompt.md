---
name: "dependency-graph"
description: "Regenerate docs and show requirement dependency graph. Use when: checking requirement relationships and blockers."
argument-hint: "(no arguments)"
agent: "Vibe Agent Orchestrator"
---

**Platform Note**: On Windows, use `scripts/dispatch.ps1 <name>` instead of `scripts/<name>.sh`. On Linux/macOS, use `scripts/dispatch.sh <name>`.

Show the latest requirement dependency graph.

Workflow:
1. Run `scripts/dispatch.ps1 dependency-graph` (or `scripts/dispatch.sh dependency-graph` on Linux/macOS).
2. Return the graph output and mention the source file docs/DEPENDENCIES.md.

Constraints:
- If regeneration fails, return the exact script error.
- Do not fabricate missing dependencies.
