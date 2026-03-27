#!/bin/bash
# Show project requirement status with optional doc refresh

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REQ_MANIFEST="$PROJECT_ROOT/.requirement-manifest.json"
REFRESH="${1:-}"

if [ ! -f "$REQ_MANIFEST" ]; then
  echo "Error: .requirement-manifest.json not found" >&2
  exit 1
fi

if [ "$REFRESH" != "--no-refresh" ]; then
  "$PROJECT_ROOT/scripts/regenerate-docs.sh" >/dev/null
fi

echo "=== Project Status ==="
echo "Manifest: $REQ_MANIFEST"

echo "Total: $(jq '.requirements | length' "$REQ_MANIFEST")"
echo "In Progress: $(jq '[.requirements[] | select(.status == "IN_PROGRESS")] | length' "$REQ_MANIFEST")"
echo "Blocked: $(jq '[.requirements[] | select(.status == "BLOCKED")] | length' "$REQ_MANIFEST")"
echo "Deployed: $(jq '[.requirements[] | select(.status == "DEPLOYED")] | length' "$REQ_MANIFEST")"

echo ""
echo "IN_PROGRESS items:"
jq -r '.requirements[] | select(.status == "IN_PROGRESS") | "- \(.id): \(.name) (priority: \(.priority))"' "$REQ_MANIFEST"

echo ""
echo "Status board: docs/STATUS.md"
