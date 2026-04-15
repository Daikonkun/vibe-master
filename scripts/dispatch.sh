#!/bin/bash
# Cross-platform dispatch layer for Vibe Master scripts
# Detects the OS and calls the appropriate script variant (.sh on Linux/macOS, .ps1 on Windows)
# Usage: ./scripts/dispatch.sh <script-name> [args...]

set -euo pipefail

SCRIPT_NAME="${1:?Error: script name required}"
shift || true

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    # Windows: prefer .ps1, fall back to .sh
    if [ -f "$SCRIPTS_DIR/$SCRIPT_NAME.ps1" ]; then
        powershell -ExecutionPolicy Bypass -File "$SCRIPTS_DIR/$SCRIPT_NAME.ps1" "$@"
        exit $?
    fi
    if [ -f "$SCRIPTS_DIR/$SCRIPT_NAME.sh" ]; then
        bash "$SCRIPTS_DIR/$SCRIPT_NAME.sh" "$@"
        exit $?
    fi
else
    # Linux/macOS: prefer .sh, fall back to .ps1
    if [ -f "$SCRIPTS_DIR/$SCRIPT_NAME.sh" ]; then
        bash "$SCRIPTS_DIR/$SCRIPT_NAME.sh" "$@"
        exit $?
    fi
    if [ -f "$SCRIPTS_DIR/$SCRIPT_NAME.ps1" ] && command -v pwsh &>/dev/null; then
        pwsh -File "$SCRIPTS_DIR/$SCRIPT_NAME.ps1" "$@"
        exit $?
    fi
fi

echo "Error: Script not found: $SCRIPT_NAME" >&2
exit 1
