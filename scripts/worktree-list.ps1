#!/usr/bin/env pwsh
# Show active worktrees and linked requirements from manifest
# Usage: ./scripts/worktree-list.ps1

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$WorktreeManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"

if (-not (Test-Path $WorktreeManifestPath)) {
    Write-Host "Error: .worktree-manifest.json not found" -ForegroundColor Red
    exit 1
}

$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
$ActiveWorktrees = @($WtManifest.worktrees | Where-Object { $_.status -eq "ACTIVE" })

Write-Host "=== Active Worktrees ==="

if ($ActiveWorktrees.Count -eq 0) {
    Write-Host "No active worktrees found."
    exit 0
}

foreach ($Wt in $ActiveWorktrees) {
    Write-Host "- ID: $($Wt.id)"
    Write-Host "  Branch: $($Wt.branch)"
    Write-Host "  Base: $($Wt.baseBranch)"
    Write-Host "  Path: $($Wt.path)"
    Write-Host "  Requirements: $($Wt.requirementIds -join ', ')"
    Write-Host ""
}

Write-Host "Count: $($ActiveWorktrees.Count)"
