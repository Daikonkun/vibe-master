# Command Map (Canonical)

Canonical source of truth for slash-command entrypoints.

- **Prompt-backed command**: implemented by `.github/prompts/<name>.prompt.md`.
- **Script entrypoint**: a single `scripts/*.sh` file that is the command's primary shell entrypoint.
- **`none (prompt-driven)`** means there is intentionally no dedicated `scripts/<name>.sh` wrapper.

| Command | Prompt File | Script Entrypoint | Notes |
|---|---|---|---|
| `/add-requirement` | `.github/prompts/add-requirement.prompt.md` | `scripts/create-requirement.sh` | Regenerates docs via `scripts/regenerate-docs.sh` |
| `/bug-fix` | `.github/prompts/bug-fix.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
| `/code-review` | `.github/prompts/code-review.prompt.md` | none (prompt-driven) | May run `scripts/regenerate-docs.sh` |
| `/dependency-graph` | `.github/prompts/dependency-graph.prompt.md` | `scripts/dependency-graph.sh` |  |
| `/e2e-test` | `.github/prompts/e2e-test.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
| `/init` | `.github/prompts/init.prompt.md` | `scripts/init-project.sh` |  |
| `/list-requirements` | `.github/prompts/list-requirements.prompt.md` | `scripts/list-requirements.sh` |  |
| `/regen-docs` | `.github/prompts/regen-docs.prompt.md` | `scripts/regenerate-docs.sh` |  |
| `/roadmap` | `.github/prompts/roadmap.prompt.md` | `scripts/roadmap.sh` |  |
| `/rollback` | `.github/prompts/rollback.prompt.md` | `scripts/rollback-requirement.sh` |  |
| `/show-requirement` | `.github/prompts/show-requirement.prompt.md` | `scripts/show-requirement.sh` |  |
| `/start-work` | `.github/prompts/start-work.prompt.md` | `scripts/start-work.sh` |  |
| `/status` | `.github/prompts/status.prompt.md` | `scripts/status.sh` |  |
| `/update-manual` | `.github/prompts/update-manual.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
| `/update-requirement` | `.github/prompts/update-requirement.prompt.md` | `scripts/update-requirement-status.sh` |  |
| `/upgrade` | `.github/prompts/upgrade.prompt.md` | `scripts/upgrade.sh` | Uses `scripts/check-upgrade-manifest-history.sh` and `scripts/regenerate-docs.sh` |
| `/work-on` | `.github/prompts/work-on.prompt.md` | none (prompt-driven) | Uses `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, `scripts/regenerate-docs.sh`, `scripts/worktree-list.sh` inside workflow; **do not call a dedicated work-on shell wrapper** |
| `/worktree-create` | `.github/prompts/worktree-create.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
| `/worktree-list` | `.github/prompts/worktree-list.prompt.md` | `scripts/worktree-list.sh` |  |
| `/worktree-merge` | `.github/prompts/worktree-merge.prompt.md` | `scripts/worktree-merge.sh` |  |
| `/worktree-prune` | `.github/prompts/worktree-prune.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
| `/worktree-status` | `.github/prompts/worktree-status.prompt.md` | none (prompt-driven) | Workflow-oriented prompt |
