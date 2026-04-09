#!/bin/bash
# Initialize a new vibe project by clearing Vibe-Master-internal REQs
# while preserving any project-specific REQs.

set -e

echo "🚀 Vibe Agent Orchestrator - Project Initialization"
echo "===================================================="
echo ""

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROJECT_NAME="${1:-My Vibe Project}"

echo "📦 Project: $PROJECT_NAME"
echo "📍 Location: $PROJECT_ROOT"
echo ""

# Self-protection: refuse to run on the Vibe Master source repo
if [ -f "$PROJECT_ROOT/.vibe-master-source" ]; then
  echo "❌ Error: This is the Vibe Master source repository."
  echo "   The /init command cannot run here to protect the template's own REQ history."
  echo "   Clone or copy this repo to a new directory first."
  exit 1
fi

# Initialize git if needed
if [ ! -d .git ]; then
  echo "🔧 Initializing git repository..."
  git init
  git config user.email "ai@vibe.local"
  git config user.name "Vibe Agent"
fi

# Make scripts executable
chmod +x scripts/*.sh

# Create docs/requirements directory
mkdir -p docs/requirements

# --- Selective REQ clearing ---
# Only remove REQs with origin "vibe-master". Preserve project REQs.

if [ -f "$PROJECT_ROOT/.requirement-manifest.json" ]; then
  # Collect IDs of vibe-master-origin REQs to delete their spec files
  VM_IDS=$(jq -r '.requirements[] | select(.origin == "vibe-master") | .id' "$PROJECT_ROOT/.requirement-manifest.json" 2>/dev/null || true)

  # Remove spec files for vibe-master REQs only
  CLEANED=0
  if [ -n "$VM_IDS" ]; then
    while IFS= read -r reqId; do
      [ -z "$reqId" ] && continue
      for f in docs/requirements/${reqId}-*.md; do
        [ -f "$f" ] || continue
        rm "$f"
        CLEANED=$((CLEANED + 1))
      done
    done <<< "$VM_IDS"
  fi

  echo "🧹 Cleared $CLEANED Vibe Master REQ spec file(s)"

  # Remove vibe-master REQs from manifest, keep project REQs
  KEPT=$(jq '[.requirements[] | select(.origin != "vibe-master")] | length' "$PROJECT_ROOT/.requirement-manifest.json")
  jq --arg name "$PROJECT_NAME" '
    .projectName = $name |
    .requirements = [.requirements[] | select(.origin != "vibe-master")]
  ' "$PROJECT_ROOT/.requirement-manifest.json" > "$PROJECT_ROOT/.requirement-manifest.json.tmp" && \
    mv "$PROJECT_ROOT/.requirement-manifest.json.tmp" "$PROJECT_ROOT/.requirement-manifest.json"

  echo "   Preserved $KEPT project REQ(s)"
else
  echo "📋 Initializing requirement manifest..."
  cat > "$PROJECT_ROOT/.requirement-manifest.json" << 'JSON'
{
  "$schema": ".requirement-manifest.schema.json",
  "version": "1.0",
  "projectName": "",
  "requiresDeployment": true,
  "requirements": []
}
JSON
  jq --arg name "$PROJECT_NAME" '.projectName = $name' "$PROJECT_ROOT/.requirement-manifest.json" > "$PROJECT_ROOT/.requirement-manifest.json.tmp" && \
    mv "$PROJECT_ROOT/.requirement-manifest.json.tmp" "$PROJECT_ROOT/.requirement-manifest.json"
fi

# Selectively clear worktree manifest — remove entries linked to cleared vibe-master REQs
echo "📋 Cleaning worktree manifest..."
if [ -f "$PROJECT_ROOT/.worktree-manifest.json" ] && [ -n "$VM_IDS" ]; then
  # Build a jq filter that removes worktrees whose requirementIds overlap with cleared REQ IDs
  jq --argjson vmIds "$(echo "$VM_IDS" | jq -R -s 'split("\n") | map(select(length > 0))')" '
    .worktrees = [.worktrees[]? | select(
      [.requirementIds[]?] | any(. as $rid | $vmIds | index($rid)) | not
    )]
  ' "$PROJECT_ROOT/.worktree-manifest.json" > "$PROJECT_ROOT/.worktree-manifest.json.tmp" && \
    mv "$PROJECT_ROOT/.worktree-manifest.json.tmp" "$PROJECT_ROOT/.worktree-manifest.json"
else
  cat > "$PROJECT_ROOT/.worktree-manifest.json" << 'JSON'
{
  "$schema": ".worktree-manifest.schema.json",
  "version": "1.0",
  "worktrees": []
}
JSON
fi

# Regenerate docs
if [ -f scripts/regenerate-docs.sh ]; then
  echo "📄 Regenerating docs..."
  bash scripts/regenerate-docs.sh
fi

# Create initial commit
git add -A
git commit -m "chore: init project $PROJECT_NAME" --no-verify 2>/dev/null || true

echo ""
echo "✅ Initialization complete!"
echo ""
echo "Next steps:"
echo "  1. Create your first requirement: /add-requirement \"Feature\" \"Description\""
echo "  2. Check status: /status"
echo "  3. Start work: /start-work REQ-XXXXX"
echo ""
echo "Configuration complete. Open in VS Code to begin!"
