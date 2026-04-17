#!/bin/bash
# Verify/install required local CLI dependencies for orchestrator scripts.

set -euo pipefail

INSTALL_MODE="false"

usage() {
  cat << 'EOF'
Usage: bash scripts/bootstrap-deps.sh [--install]

Checks required local dependencies for manifest-mutating workflows.

Options:
  --install   Attempt installation when possible (macOS Homebrew only)
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "${1:-}" = "--install" ]; then
  INSTALL_MODE="true"
elif [ -n "${1:-}" ]; then
  echo "Error: Unknown option: $1" >&2
  usage >&2
  exit 1
fi

if command -v flock >/dev/null 2>&1; then
  echo "✅ flock is available: $(command -v flock)"
  exit 0
fi

echo "❌ Required dependency missing: flock" >&2

if [ "$INSTALL_MODE" = "true" ]; then
  if command -v brew >/dev/null 2>&1; then
    echo "Installing flock via Homebrew..."
    brew install flock
  else
    echo "Error: --install is only supported when Homebrew is available." >&2
    exit 1
  fi
fi

if command -v flock >/dev/null 2>&1; then
  echo "✅ flock is available: $(command -v flock)"
  exit 0
fi

cat >&2 << 'EOF'
Install commands:
  macOS (Homebrew): brew install flock
  Debian/Ubuntu:    sudo apt-get install -y util-linux
  Fedora/RHEL:      sudo dnf install -y util-linux

Then re-run:
  bash scripts/bootstrap-deps.sh
EOF

exit 1
