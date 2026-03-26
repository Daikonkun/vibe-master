# Vibe Agent Orchestrator

A VS Code AI-driven development orchestrator for managing requirements, git worktrees, and parallel development in "vibe coding" projects (AI-only development driven through VS Code).

## 🚀 Quick Start

### 1. Clone This Template
```bash
git clone <this-repo-url> my-vibe-project
cd my-vibe-project
git remote remove origin  # Detach from template
git remote add origin <your-new-repo>
```

### 2. Initialize in VS Code
Open the project in VS Code. The orchestrator agent will auto-load from `.github/agents/orchestrator.agent.md`.

### 3. Submit Your First Requirement
```
/add-requirement "User Authentication" "Implement email/password authentication system"
```

The agent will:
- Create requirement record (unique ID: `REQ-{timestamp}`)
- Create detailed spec file (`docs/requirements/REQ-XXX-user-authentication.md`)
- Update `REQUIREMENTS.md` summary
- Suggest creating a git worktree

### 4. Start Work
```
/start-work REQ-001
```

The agent will:
- Create a git worktree: `feature/REQ-001-user-authentication`
- Update requirement status to `IN_PROGRESS`
- Provide context on what to build

### 5. Check Status Anytime
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
│   ├── instructions/
│   ├── skills/
│   │   ├── worktree-manager/SKILL.md      # Git worktree management
│   │   └── requirement-tracker/SKILL.md   # Requirement lifecycle
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
    ├── create-requirement.sh               # CLI: create new requirement
    └── regenerate-docs.sh                  # CLI: regenerate all docs
```

---

## 🎯 Core Workflows

### Adding a Requirement
Best via slash command for interactive guidance:
```
/add-requirement "<Feature name>" "<Description>" "[CRITICAL|HIGH|MEDIUM|LOW]"
```

Or CLI:
```bash
./scripts/create-requirement.sh "User Authentication" "Email/password login system" HIGH
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
project-root/
├── .git/
├── (main branch files)
└── ..

../feature/REQ-001-auth-system/
├── .git (worktree)
├── (feature files)

../feature/REQ-002-dashboard/
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

### `REQUIREMENTS.md`
Table of all requirements with status, priority, dates

### `docs/STATUS.md`
Kanban board showing requirements grouped by status

### `docs/ROADMAP.md`
Timeline view ordered by priority

### `docs/DEPENDENCIES.md`
Graph showing which requirements depend on others

**Regenerate manually**:
```bash
./scripts/regenerate-docs.sh
```

---

## 🛠 Key Slash Commands

| Command | Purpose |
|---------|---------|
| `/add-requirement` | Submit new requirement |
| `/start-work <req-id>` | Begin work (create worktree) |
| `/status` | Show current dashboard |
| `/show-requirement <req-id>` | View requirement details |
| `/list-requirements [status]` | List requirements by status |
| `/worktree-list` | Show all active worktrees |
| `/worktree-merge <branch>` | Merge and cleanup |
| `/dependency-graph` | Visualize dependencies |
| `/roadmap` | Show timeline |
| `/regen-docs` | Force doc regeneration |

---

## 🧠 Agent Capabilities

The orchestrator can:

1. **Create & manage requirements** — record, track, update lifecycle
2. **Create & manage git worktrees** — auto-create, detect conflicts, cleanup
3. **Execute development workflows** — scaffold code, run tests, create PRs
4. **Generate documentation** — auto-update dashboards, timelines, graphs
5. **Detect conflicts** — warn if multiple requirements modify same files
6. **Suggest sequencing** — recommend order for dependent requirements

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

To use sequential IDs instead, modify `scripts/create-requirement.sh`:
```bash
# Current: REQ-$(date +%s)
# Alternative: REQ-$(printf "%03d" $COUNT)
```

### Add Custom Status Types
Edit:
- `.requirement-manifest.json` (enum values)
- `copilot-instructions.md` (state transitions)

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
      "path": "../feature/REQ-1704067200-user-auth",
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
- Ensure agent contextis fresh (close/reopen chat)

**Worktree creation failed?**
- Check git is initialized: `git status`
- Ensure no other process is holding the directory
- Run `git worktree prune` to clean stale worktrees

**Documentation not updating?**
- Manually regenerate: `./scripts/regenerate-docs.sh`
- Or use: `/regen-docs` slash command

**Manifest files out of sync?**
- Both are authoritative sources; if conflicted, prefer `.requirement-manifest.json`
- Manually fix `.worktree-manifest.json` if entries are stale

---

## 📚 Resources

- Agent docs: `.github/agents/orchestrator.agent.md`
- Requirement skill: `.github/skills/requirement-tracker/SKILL.md`
- Worktree skill: `.github/skills/worktree-manager/SKILL.md`
- Global instructions: `copilot-instructions.md`

---

## 📄 License

This template is open source. Customize freely for your projects.

---

**Happy vibe coding! 🎉**
