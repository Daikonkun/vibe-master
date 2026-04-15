#!/usr/bin/env pwsh
# Show a requirement and its detailed spec file if present
# Usage: ./scripts/show-requirement.ps1 -ReqId REQ-XXXXXXXXXX

param(
    [Parameter(Mandatory=$true)][string]$ReqId
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"

if ($ReqId -notmatch '^REQ-\d{10,}$') {
    Write-Host "Error: Invalid requirement ID format: $ReqId" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Req = $Manifest.requirements | Where-Object { $_.id -eq $ReqId } | Select-Object -First 1

if (-not $Req) {
    Write-Host "Error: Requirement not found: $ReqId" -ForegroundColor Red
    exit 1
}

Write-Host "=== Requirement $ReqId ==="
$Req | ConvertTo-Json -Depth 5

# Find spec file
$SpecDir = Join-Path $ProjectRoot "docs\requirements"
$Pattern = "$ReqId-*.md"
$SpecFile = Get-ChildItem -Path $SpecDir -Filter $Pattern -File -ErrorAction SilentlyContinue | Select-Object -First 1

if ($SpecFile) {
    Write-Host ""
    Write-Host "=== Specification Path ==="
    Write-Host $SpecFile.FullName
    Write-Host ""
    Write-Host "=== Specification Content ==="
    Get-Content $SpecFile.FullName -Encoding UTF8
} else {
    Write-Host ""
    Write-Host "No spec file found in docs/requirements for $ReqId"
}
