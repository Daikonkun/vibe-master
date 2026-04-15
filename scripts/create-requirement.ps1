#!/usr/bin/env pwsh
# Create a new requirement and optionally start a worktree for it
# Usage: ./scripts/create-requirement.ps1 -Name "Feature name" -Description "Description" [-Priority MEDIUM]

param(
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][string]$Description,
    [ValidateSet("CRITICAL","HIGH","MEDIUM","LOW")]
    [string]$Priority = "MEDIUM"
)

$ErrorActionPreference = "Stop"

# Generate requirement ID
$Epoch = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$ReqId = "REQ-$Epoch"

# Generate slug from name
$Slug = ($Name.ToLower() -replace '[^a-z0-9]','-' -replace '-+','-' -replace '^-|-$','')

# Find project root
$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

Write-Host "Creating requirement: $ReqId"
Write-Host "   Name: $Name"
Write-Host "   Priority: $Priority"

# Ensure manifest exists
$ManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
if (-not (Test-Path $ManifestPath)) {
    $DefaultManifest = @{
        '$schema' = ".requirement-manifest.schema.json"
        version = "1.0"
        projectName = "Vibe Project"
        requiresDeployment = $true
        requirements = @()
    } | ConvertTo-Json -Depth 5
    Set-Content -Path $ManifestPath -Value $DefaultManifest -Encoding UTF8
}

# Read manifest, add new requirement
$Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$NewReq = [PSCustomObject]@{
    id = $ReqId
    name = $Name
    description = $Description
    status = "PROPOSED"
    priority = $Priority
    origin = "project"
    createdAt = $Timestamp
    updatedAt = $Timestamp
}
$Manifest.requirements += $NewReq
$Manifest | ConvertTo-Json -Depth 10 | Set-Content $ManifestPath -Encoding UTF8

# Create detailed spec file
$SpecDir = Join-Path $ProjectRoot "docs\requirements"
if (-not (Test-Path $SpecDir)) {
    New-Item -ItemType Directory -Path $SpecDir -Force | Out-Null
}

$SpecPath = Join-Path $SpecDir "$ReqId-$Slug.md"
$SpecContent = @"
# $Name

**ID**: $ReqId  
**Status**: PROPOSED  
**Priority**: $Priority  
**Created**: $Timestamp  

## Description

$Description

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
"@
Set-Content -Path $SpecPath -Value $SpecContent -Encoding UTF8

Write-Host ""
Write-Host "Requirement created: $ReqId"
Write-Host "   Spec: docs/requirements/$ReqId-$Slug.md"
