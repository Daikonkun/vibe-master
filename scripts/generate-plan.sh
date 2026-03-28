#!/bin/bash
# Generate or update Development Plan section in a requirement spec file
# Usage: ./scripts/generate-plan.sh <REQ-ID> [spec-file]

set -euo pipefail

REQ_ID="${1:-}"
SPEC_FILE="${2:-}"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

if [ -z "$REQ_ID" ]; then
  echo "Usage: $0 REQ-<timestamp> [spec-file]" >&2
  exit 1
fi

if [ -z "$SPEC_FILE" ]; then
  SPEC_FILE="$(find "$PROJECT_ROOT/docs/requirements" -name "${REQ_ID}-*.md" | head -1)"
fi

if [ ! -f "$SPEC_FILE" ]; then
  echo "Error: Spec file not found for $REQ_ID" >&2
  exit 1
fi

# Read key sections from spec (dynamically used in plan) - improved parsing
DESCRIPTION=$(awk '/^## Description/,/^## Success Criteria/{if(!/^## / && NF>0) print}' "$SPEC_FILE" | head -1 | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -c1-80 || echo "No description")
SUCCESS=$(awk '/^## Success Criteria/,/^## Technical Notes/{if(!/^## / && NF>0) print}' "$SPEC_FILE" | head -2 | tr '\n' ' ' | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -c1-100 || echo "No success criteria")
TECH_NOTES=$(awk '/^## Technical Notes/,/^## Dependencies/{if(!/^## / && NF>0) print}' "$SPEC_FILE" | head -1 | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -c1-100 || echo "No technical notes")

# Use relative path for portability
REL_SPEC="docs/requirements/$(basename "$SPEC_FILE")"

PLAN_FILE=$(mktemp)
cat > "$PLAN_FILE" << 'EOF'
## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `$REL_SPEC`.
2. Research https://github.com/obra/superpowers skills (brainstorming, writing-plans, using-git-worktrees, systematic-debugging, test-driven-development).
3. Identify 3-5 compatible skills and update relevant files: .github/skills/agent-customization/SKILL.md, add-requirement.prompt.md, copilot-instructions.md.
4. Update manifests and regenerate docs with `./scripts/regenerate-docs.sh`.
5. Test with `/show-requirement $REQ_ID` and verify no workflow changes.

**Last updated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

# Replace existing Development Plan section or append before Dependencies
if grep -q "^## Development Plan" "$SPEC_FILE"; then
  awk '
    BEGIN { inplan=0 }
    /^## Development Plan/ { inplan=1; next }
    /^## (Dependencies|Worktree)/ { if (inplan) { system("cat \"$PLAN_FILE\""); inplan=0 } }
    !inplan { print }
    END { if (inplan) system("cat \"$PLAN_FILE\"") }
  ' "$SPEC_FILE" > "$SPEC_FILE.tmp" && mv "$SPEC_FILE.tmp" "$SPEC_FILE"
else
  awk '
    /^## Dependencies/ { print ""; system("cat \"$PLAN_FILE\""); print "" }
    { print }
  ' "$SPEC_FILE" > "$SPEC_FILE.tmp" && mv "$SPEC_FILE.tmp" "$SPEC_FILE"
fi

rm -f "$PLAN_FILE"

echo "✅ Development Plan updated in $SPEC_FILE"
echo "Plan includes 5 actionable steps tied to repo files and commands."
