---
name: "worktree-merge"
description: "Merge a feature branch into base branch, clean up worktree, and update manifests. Use when: completing a requirement branch."
argument-hint: "<branch> [base-branch]"
agent: "Vibe Agent Orchestrator"
---

Merge and clean up a completed worktree branch.

Workflow:
1. Parse required branch and optional base branch (default main).
2. Run scripts/worktree-merge.sh with the parsed arguments.
3. Report merge outcome, removed worktree path, and updated requirement IDs.

Constraints:
- This operation changes git history and manifests; do not run if arguments are missing.
- The script enforces a strict clean working tree. If dirty, stop and report the exact script error; recommend `git status --short`, then commit/stash/discard local changes before retrying `/worktree-merge`.
- Surface script failures exactly.
