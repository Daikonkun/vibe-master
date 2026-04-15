#!/usr/bin/env pwsh
# Regenerate docs and show requirement dependency graph
# Usage: ./scripts/dependency-graph.ps1

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) { & $RegenScript }

$DepFile = Join-Path $ProjectRoot "docs\DEPENDENCIES.md"
if (Test-Path $DepFile) {
    Get-Content $DepFile -Encoding UTF8
}
