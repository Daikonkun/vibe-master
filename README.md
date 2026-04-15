# Vibe Agent Orchestrator — Windows Edition

A VS Code AI-driven development orchestrator for managing requirements, git worktrees, and parallel development in "vibe coding" projects (AI-only development driven through VS Code). This is the **Windows-adapted edition** — all scripts run natively in PowerShell 5.1+ with no external dependencies.

## 🚀 Quick Start

### 1. Clone This Template
```powershell
git clone <this-repo-url> my-vibe-project
cd my-vibe-project
git remote remove origin  # Detach from template
git remote add origin <your-new-repo>
```

### 2. Initialize Your Project
```powershell
powershell -ExecutionPolicy Bypass -File scripts\init-project.ps1 -ProjectName "My Project Name"
```

This will:
- Reset `.requirement-manifest.json` and `.worktree-manifest.json` to empty
- Remove historical `REQ-*.md` files from `docs/requirements/` (example files are preserved)
- Regenerate clean `REQUIREMENTS.md`, `STATUS.md`, `ROADMAP.md`, and `DEPENDENCIES.md`

### 3. Open in VS Code
Open the project in VS Code. The orchestrator agent will auto-load from `.github/agents/orchestrator.agent.md`.

### 4. Submit Your First Requirement
```
/add-requirement "User Authentication" "Implement email/password authentication system"
```

This slash command is provided by `.github/prompts/add-requirement.prompt.md`. The agent will:
- Create requirement record (unique ID: `REQ-{timestamp}`)
- Create detailed spec file (`docs/requirements/REQ-XXX-user-authentication.md`)
- Update `REQUIREMENTS.md` summary
- Suggest creating a git worktree

### 5. Start Work
```
/start-work REQ-001
```

The agent will:
- Create a git worktree: `feature/REQ-001-user-authentication`
- Update requirement status to `IN_PROGRESS`
- Provide development context

### 6. Check Status Anytime
```
/status
```

Shows current dashboard with all requirements, worktrees, and progress.

---

## 📁 Project Structure

```
.
├── .github/
│   ├── agents/
│   │   └── orchestrator.agent.md          # Main orchestrator agent
│   ├── prompts/
│   │   ├── add-requirement.prompt.md      # Slash command for requirement creation
│   │   ├── bug-fix.prompt.md              # Wrapper prompt for debug workflow skill
│   │   ├── code-review.prompt.md          # Wrapper prompt for review skill
│   │   ├── dependency-graph.prompt.md     # Slash command for dependency visualization
│   │   ├── e2e-test.prompt.md             # Slash command for end-to-end testing
│   │   ├── init.prompt.md                 # Slash command for project initialization
│   │   ├── list-requirements.prompt.md    # Slash command for requirement listings
│   │   ├── regen-docs.prompt.md           # Slash command for manual doc regeneration
│   │   ├── roadmap.prompt.md              # Slash command for roadmap view
│   │   ├── rollback.prompt.md             # Slash command for reverting a merged requirement
│   │   ├── show-requirement.prompt.md     # Slash command for requirement details
│   │   ├── start-work.prompt.md           # Slash command for worktree start
│   │   ├── status.prompt.md               # Slash command for status dashboard
│   │   ├── update-manual.prompt.md        # Wrapper prompt for manual update skill
│   │   ├── update-requirement.prompt.md   # Slash command for lifecycle status transitions
│   │   ├── work-on.prompt.md              # Slash command for iterative requirement work
│   │   ├── worktree-create.prompt.md      # Slash command for manual worktree creation
│   │   ├── worktree-list.prompt.md        # Slash command for active worktrees
│   │   ├── worktree-merge.prompt.md       # Slash command for merge and cleanup
│   │   ├── worktree-prune.prompt.md       # Slash command for orphan worktree cleanup
│   │   └── worktree-status.prompt.md      # Slash command for worktree dashboard
│   ├── instructions/
│   ├── skills/
│   │   ├── agent-customization/SKILL.md    # Agent/prompt/skill file maintenance
│   │   ├── code-review/SKILL.md            # Code review + REQ thread creation
│   │   ├── debug/SKILL.md                  # Structured debugging workflow
│   │   ├── requirement-tracker/SKILL.md    # Requirement lifecycle
│   │   ├── update-manual/SKILL.md          # User manual generation/refresh
│   │   └── worktree-manager/SKILL.md       # Git worktree management
│
├── copilot-instructions.md                 # Global agent instructions
│
├── REQUIREMENTS.md                         # Summary of all requirements
├── .requirement-manifest.json              # Structured requirement data
├── .worktree-manifest.json                 # Worktree-to-requirement mapping
│
├── docs/
│   ├── requirements/                       # Detailed requirement specs
│   ├── STATUS.md                          # Auto-generated kanban board
│   ├── ROADMAP.md                         # Timeline view
│   └── DEPENDENCIES.md                    # Dependency graph
│
└── scripts/
    ├── create-requirement.ps1              # CLI: create new requirement
    ├── dependency-graph.ps1                # CLI: regenerate + show dependency graph
    ├── generate-plan.ps1                   # CLI: generate/update Development Plan in a spec
    ├── init-project.ps1                    # CLI: initialize project from template
    ├── list-requirements.ps1              # CLI: list requirements by optional status
    ├── regenerate-docs.ps1                 # CLI: regenerate all docs
    ├── roadmap.ps1                         # CLI: regenerate + show roadmap
    ├── rollback-requirement.ps1            # CLI: revert a merged requirement
    ├── show-requirement.ps1                # CLI: display requirement details
    ├── start-work.ps1                      # CLI: create worktree + set IN_PROGRESS
    ├── status.ps1                          # CLI: regenerate + show status summary
    ├── update-requirement-status.ps1       # CLI: validate and update requirement status
    ├── worktree-list.ps1                   # CLI: list active worktrees from manifest
    └── worktree-merge.ps1                  # CLI: merge branch + clean worktree
```

---

## 🎯 Core Workflows

### Adding a Requirement
Best via slash command for interactive guidance:
```
/add-requirement "<Feature name>" "<Description>" "[CRITICAL|HIGH|MEDIUM|LOW]"
```

Or CLI:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\create-requirement.ps1 -Name "User Authentication" -Description "Email/password login system" -Priority HIGH
```

### Starting Work on a Requirement
```
/start-work REQ-001
```

This:
1. Creates a git worktree: `feature/REQ-001-{slug}`
2. Sets requirement status to `IN_PROGRESS`
3. Provides development context

### Checking Project Status
```
/status
```

Displays:
- Kanban board (all requirements by status)
- Completion stats
- Active worktrees
- Blocked items

### Completing Work
```
/worktree-merge feature/REQ-001-user-authentication
```

This:
1. Merges the feature branch to `main`/`develop`
2. Updates requirement status to `MERGED`
3. Removes the worktree
4. Regenerates documentation

### Viewing Requirement Details
```
/show-requirement REQ-001
```

Shows manifest data + full specification from `docs/requirements/REQ-001-*.md`

---

## 🔄 Requirement Lifecycle

```
PROPOSED
  ↓
IN_PROGRESS (work started, worktree created)
  ↓
CODE_REVIEW (ready for review)
  ↓
MERGED (merged to main/develop)
  ↓
DEPLOYED (shipped to production)
```

Alternative paths:
- Any state → `BLOCKED` (with reason)
- Any state → `BACKLOG` (deprioritized)
- Any state → `CANCELLED` (abandoned)

---

## 🌿 Git Worktree Convention

Each requirement gets an isolated git worktree for parallel development:

```
project-root\
├── .git\
├── (main branch files)
└── ..

..\feature\REQ-001-auth-system\
├── .git (worktree)
├── (feature files)

..\feature\REQ-002-dashboard\
├── .git (worktree)
├── (feature files)
```

**Naming**: `{type}/{req-ids}-{slug}`
- Types: `feature`, `fix`, `refactor`, `docs`
- Example: `feature/REQ-001-user-auth`
- Grouped: `feature/REQ-003+REQ-004-related-features`

---

## 📊 Automated Documentation

The orchestrator auto-generates these files:

| File | Content |
|------|---------|
| `REQUIREMENTS.md` | Table of all requirements with status, priority, dates |
| `docs/STATUS.md` | Kanban board showing requirements grouped by status |
| `docs/ROADMAP.md` | Timeline view ordered by priority |
| `docs/DEPENDENCIES.md` | Graph showing which requirements depend on others |

**Regenerate manually**:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\regenerate-docs.ps1
```

---

## 🛠 Key Slash Commands

Slash commands only show up in chat when they are backed by a prompt file or by a valid skill definition. This template ships prompt files for every command listed below and loads workflow skills through valid lowercase-hyphenated skill names.

| Command | Purpose |
|---------|---------|
| `/add-requirement` | Submit new requirement |
| `/update-requirement <req-id> <new-status> [--force] [--no-refresh]` | Update requirement lifecycle status with transition validation |
| `/start-work <req-id>` | Begin work (create worktree + set IN_PROGRESS) |
| `/work-on <req-id> [target-status]` | Iteratively implement a requirement until next lifecycle status |
| `/status` | Show current dashboard |
| `/show-requirement <req-id>` | View requirement details |
| `/list-requirements [status]` | List requirements by status |
| `/init [project-name]` | Initialize a new project from the Vibe Master template |
| `/rollback <req-id> [base-branch]` | Roll back a merged/deployed requirement by reverting its merge commit |
| `/e2e-test [scope]` | Run end-to-end test; surfaces skill gaps as new REQs |
| `/worktree-list` | Show all active worktrees |
| `/worktree-merge <branch>` | Merge and cleanup |
| `/worktree-create <req-id> [base-branch]` | Create a worktree without changing requirement status |
| `/worktree-prune` | Remove orphaned worktrees and clean manifests |
| `/worktree-status` | Show comprehensive worktree status dashboard |
| `/dependency-graph` | Visualize dependencies |
| `/roadmap` | Show timeline |
| `/regen-docs` | Force doc regeneration |
| `/bug-fix "issue summary" [scope]` | Run structured debug workflow |
| `/update-manual [scope]` | Generate/update user manual content |
| `/code-review [scope]` | Review code and generate REQ follow-up threads |

---

## 🧠 Agent Capabilities

The orchestrator can:

1. **Create & manage requirements** — record, track, update lifecycle
2. **Create & manage git worktrees** — auto-create, detect conflicts, prune, cleanup
3. **Execute development workflows** — scaffold code, run tests, create PRs
4. **Work on requirements iteratively** — implement a req end-to-end via `/work-on`
5. **Run end-to-end tests** — validate features and surface missing skills via `/e2e-test`
6. **Roll back changes** — revert merged requirements via `/rollback`
7. **Generate documentation** — auto-update dashboards, timelines, graphs
8. **Detect conflicts** — warn if multiple requirements modify same files
9. **Suggest sequencing** — recommend order for dependent requirements

---

## 💡 Best Practices

1. **Be specific in requirements** — vague descriptions lead to rework
2. **Set priorities** — helps agent triage work
3. **Link dependencies** — prevents blocked work downstream
4. **Check `/status` regularly** — catch bottlenecks early
5. **One worktree per major feature** — avoid mixing independent work
6. **Group related features** — if tightly coupled, link them in one worktree
7. **Use meaningful branch names** — `feature/REQ-001-auth` not `feature/work1`
8. **Keep specs updated** — sync with actual implementation

---

## 🔧 Customization

### Change Default Base Branch
Edit `copilot-instructions.md` and `.github/agents/orchestrator.agent.md` to reference `develop` instead of `main`.

### Adjust Requirement ID Format
Currently uses timestamp: `REQ-{unix-timestamp}` (e.g., `REQ-1704067200`)

To use sequential IDs instead, modify `scripts/create-requirement.ps1`:
```powershell
# Current: REQ-$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
# Alternative: REQ-{0:D3} -f $COUNT
```

### Add Custom Status Types
Edit:
- `.requirement-manifest.json` (enum values)
- `copilot-instructions.md` (state transitions)

---

## 📝 PowerShell Script Parameters

All PowerShell scripts use named parameters. Here's a quick reference:

| Script | Parameters |
|--------|------------|
| `create-requirement.ps1` | `-Name <string>` `-Description <string>` `[-Priority MEDIUM]` |
| `start-work.ps1` | `-ReqId <string>` `[-BaseBranch main]` |
| `update-requirement-status.ps1` | `-ReqId <string>` `-NewStatus <string>` `[-Force]` `[-NoRefresh]` |
| `show-requirement.ps1` | `-ReqId <string>` |
| `list-requirements.ps1` | `[[-Status] <string>]` |
| `init-project.ps1` | `-ProjectName <string>` |
| `rollback-requirement.ps1` | `-ReqId <string>` `[-BaseBranch main]` |
| `worktree-merge.ps1` | `-Branch <string>` |
| `regenerate-docs.ps1` | *(no parameters)* |
| `status.ps1` | *(no parameters)* |
| `dependency-graph.ps1` | *(no parameters)* |
| `roadmap.ps1` | *(no parameters)* |
| `worktree-list.ps1` | *(no parameters)* |
| `generate-plan.ps1` | `-ReqId <string>` |

> **No `jq` required** — PowerShell scripts use native `ConvertFrom-Json`/`ConvertTo-Json` cmdlets, so no external dependencies are needed.

---

## 📝 Requirements Manifest Format

### `.requirement-manifest.json`
```json
{
  "version": "1.0",
  "projectName": "My Vibe Project",
  "requirements": [
    {
      "id": "REQ-1704067200",
      "name": "User Authentication",
      "description": "Email/password login system",
      "status": "IN_PROGRESS",
      "priority": "HIGH",
      "worktreeId": "feature/REQ-1704067200-user-auth",
      "dependsOn": [],
      "createdAt": "2024-01-01T12:00:00Z",
      "updatedAt": "2024-01-02T15:30:00Z",
      "notes": "Using bcrypt for password hashing"
    }
  ]
}
```

### `.worktree-manifest.json`
```json
{
  "version": "1.0",
  "worktrees": [
    {
      "id": "feature/REQ-1704067200-user-auth",
      "path": "..\\feature\\REQ-1704067200-user-auth",
      "branch": "feature/REQ-1704067200-user-auth",
      "baseBranch": "main",
      "requirementIds": ["REQ-1704067200"],
      "createdAt": "2024-01-01T12:00:00Z",
      "status": "ACTIVE"
    }
  ]
}
```

---

## 🚨 Troubleshooting

**Agent not responding to `/` commands?**
- Check that `copilot-instructions.md` is loaded (should be auto-loaded)
- Confirm the command has a backing prompt or skill file; command prompts live in `.github/prompts/`
- Ensure agent context is fresh (close/reopen chat)

**Worktree creation failed?**
- Check git is initialized: `git status`
- Ensure no other process is holding the directory
- Run `git worktree prune` to clean stale worktrees

**Documentation not updating?**
- Manually regenerate: `powershell -ExecutionPolicy Bypass -File scripts\regenerate-docs.ps1`
- Or use: `/regen-docs` slash command

**Manifest files out of sync?**
- Both are authoritative sources; if conflicted, prefer `.requirement-manifest.json`
- Manually fix `.worktree-manifest.json` if entries are stale

**PowerShell execution policy blocking scripts?**
- Run scripts with: `powershell -ExecutionPolicy Bypass -File scripts\<script>.ps1`
- Or set policy for current user: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

---

## 📚 Resources

- Agent docs: `.github/agents/orchestrator.agent.md`
- Requirement skill: `.github/skills/requirement-tracker/SKILL.md`
- Worktree skill: `.github/skills/worktree-manager/SKILL.md`
- Debug skill: `.github/skills/debug/SKILL.md`
- Manual updater skill: `.github/skills/update-manual/SKILL.md`
- Code review skill: `.github/skills/code-review/SKILL.md`
- Agent customization skill: `.github/skills/agent-customization/SKILL.md`
- Global instructions: `copilot-instructions.md`

---

## 📄 License

This template is open source. Customize freely for your projects.
