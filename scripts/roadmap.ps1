#!/usr/bin/env pwsh
# Regenerate docs and show roadmap view
# Usage: ./scripts/roadmap.ps1

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) { & $RegenScript }

$RoadmapFile = Join-Path $ProjectRoot "docs\ROADMAP.md"
if (Test-Path $RoadmapFile) {
    Get-Content $RoadmapFile -Encoding UTF8
}
