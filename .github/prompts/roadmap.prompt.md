---
name: "roadmap"
description: "Regenerate docs and display roadmap grouped by priority and status. Use when: reviewing delivery sequencing."
argument-hint: "(no arguments)"
agent: "Vibe Agent Orchestrator"
---

**Platform Note**: On Windows, use `scripts/dispatch.ps1 <name>` instead of `scripts/<name>.sh`. On Linux/macOS, use `scripts/dispatch.sh <name>`.

Show the latest roadmap for requirements.

Workflow:
1. Run `scripts/dispatch.ps1 roadmap` (or `scripts/dispatch.sh roadmap` on Linux/macOS).
2. Return the roadmap output and mention the source file docs/ROADMAP.md.

Constraints:
- If regeneration fails, return the exact script error.
- Preserve the roadmap ordering from script output.
