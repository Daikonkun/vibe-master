#!/usr/bin/env pwsh
# List requirements from manifest, optionally filtered by status
# Usage: ./scripts/list-requirements.ps1 [[-StatusFilter] PROPOSED]

param(
    [string]$StatusFilter = ""
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

$ValidStatuses = @("PROPOSED","IN_PROGRESS","CODE_REVIEW","MERGED","DEPLOYED","BLOCKED","BACKLOG","CANCELLED")
if ($StatusFilter -and $ValidStatuses -notcontains $StatusFilter.ToUpper()) {
    Write-Host "Error: Invalid status filter: $StatusFilter" -ForegroundColor Red
    exit 1
}

$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Reqs = $Manifest.requirements

if ($StatusFilter) {
    $Reqs = @($Reqs | Where-Object { $_.status -eq $StatusFilter.ToUpper() })
}

Write-Host "=== Requirements ==="
if ($StatusFilter) {
    Write-Host "Filter: $($StatusFilter.ToUpper())"
} else {
    Write-Host "Filter: ALL"
}

if ($Reqs.Count -eq 0) {
    Write-Host "No requirements found."
    exit 0
}

# Display as table
$Reqs | Format-Table -Property @{L="ID";E={$_.id}}, @{L="STATUS";E={$_.status}}, @{L="PRIORITY";E={$_.priority}}, @{L="NAME";E={$_.name}} -AutoSize

Write-Host "Count: $($Reqs.Count)"
