#!/usr/bin/env pwsh
# Update a requirement's status with lifecycle transition validation
# Usage: ./scripts/update-requirement-status.ps1 -ReqId REQ-XXXXXXXXXX -NewStatus CODE_REVIEW [-Force] [-NoRefresh]

param(
    [Parameter(Mandatory=$true)][string]$ReqId,
    [Parameter(Mandatory=$true)][string]$NewStatus,
    [switch]$Force,
    [switch]$NoRefresh
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$ValidStatuses = @("PROPOSED","IN_PROGRESS","CODE_REVIEW","MERGED","DEPLOYED","BLOCKED","BACKLOG","CANCELLED")

# Validate REQ ID format
if ($ReqId -notmatch '^REQ-\d{10,}$') {
    Write-Host "Error: Invalid requirement ID format: $ReqId" -ForegroundColor Red
    exit 1
}

$NewStatus = $NewStatus.ToUpper()
if ($ValidStatuses -notcontains $NewStatus) {
    Write-Host "Error: Invalid status: $NewStatus" -ForegroundColor Red
    Write-Host "Valid statuses: $($ValidStatuses -join ', ')"
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

$CurrentStatus = $Req.status

# Define allowed transitions
function Get-AllowedTransitions {
    param([string]$From)
    switch ($From) {
        "PROPOSED"    { @("IN_PROGRESS","BACKLOG","CANCELLED") }
        "IN_PROGRESS" { @("CODE_REVIEW","BLOCKED","BACKLOG","CANCELLED") }
        "CODE_REVIEW" { @("MERGED","BLOCKED","CANCELLED") }
        "MERGED"      { @("DEPLOYED","CANCELLED") }
        "DEPLOYED"    { @("CANCELLED") }
        "BLOCKED"     { @("IN_PROGRESS","BACKLOG","CANCELLED") }
        "BACKLOG"     { @("PROPOSED","IN_PROGRESS","CANCELLED") }
        "CANCELLED"   { @() }
        default       { @() }
    }
}

function Test-CanTransition {
    param([string]$From, [string]$To)
    if ($From -eq $To) { return $true }
    if ($To -eq "CANCELLED") { return $true }
    $Allowed = Get-AllowedTransitions -From $From
    return $Allowed -contains $To
}

if (-not $Force -and -not (Test-CanTransition -From $CurrentStatus -To $NewStatus)) {
    $Allowed = Get-AllowedTransitions -From $CurrentStatus
    Write-Host "Error: Invalid transition: $CurrentStatus -> $NewStatus" -ForegroundColor Red
    Write-Host "Allowed from $CurrentStatus`: $($Allowed -join ' ')"
    Write-Host "Use -Force to bypass validation."
    exit 1
}

# Warn if manually deploying on a non-deployment project
$RequiresDeployment = $Manifest.requiresDeployment
if ($null -eq $RequiresDeployment) { $RequiresDeployment = $true }
if ($NewStatus -eq "DEPLOYED" -and $RequiresDeployment -eq $false) {
    Write-Host "Note: This project has requiresDeployment=false. Requirements are auto-completed at merge."
    Write-Host "      Proceeding with manual DEPLOYED transition anyway."
}

if ($CurrentStatus -eq $NewStatus) {
    Write-Host "No change: $ReqId is already $NewStatus"
    exit 0
}

# Validate updatedAt >= createdAt
$CreatedAt = $Req.createdAt
if ($CreatedAt -and $Timestamp -lt $CreatedAt) {
    Write-Host "Error: updatedAt ($Timestamp) would be before createdAt ($CreatedAt)" -ForegroundColor Red
    exit 1
}

# Update manifest
foreach ($R in $Manifest.requirements) {
    if ($R.id -eq $ReqId) {
        $R.status = $NewStatus
        $R.updatedAt = $Timestamp
        if ($NewStatus -eq "DEPLOYED") {
            $R | Add-Member -NotePropertyName "deployedAt" -NotePropertyValue $Timestamp -Force
        }
    }
}
$Manifest | ConvertTo-Json -Depth 10 | Set-Content $ReqManifestPath -Encoding UTF8

# Regenerate docs
if (-not $NoRefresh) {
    $RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
    if (Test-Path $RegenScript) {
        & $RegenScript
    }
}

# Git commit
git -C $ProjectRoot add .requirement-manifest.json REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/ 2>$null
git -C $ProjectRoot commit -m "chore: update $ReqId status to $NewStatus" --no-verify 2>$null

Write-Host "Updated $ReqId"
Write-Host "   $CurrentStatus -> $NewStatus"
if (-not $NoRefresh) {
    Write-Host "   Docs regenerated"
} else {
    Write-Host "   Docs regeneration skipped (-NoRefresh)"
}
