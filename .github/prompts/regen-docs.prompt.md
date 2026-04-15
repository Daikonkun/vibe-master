---
name: "regen-docs"
description: "Force regeneration of requirement documentation artifacts. Use when: manifests changed and docs need synchronization."
argument-hint: "(no arguments)"
agent: "Vibe Agent Orchestrator"
---

**Platform Note**: On Windows, use `scripts/dispatch.ps1 <name>` instead of `scripts/<name>.sh`. On Linux/macOS, use `scripts/dispatch.sh <name>`.

Regenerate all requirement documentation files.

Workflow:
1. Run `scripts/dispatch.ps1 regenerate-docs` (or `scripts/dispatch.sh regenerate-docs` on Linux/macOS).
2. Confirm generated artifacts were updated.
3. Provide a concise success summary.

Constraints:
- Return exact script failures if regeneration does not complete.
- Do not claim generated files unless script confirms success.
