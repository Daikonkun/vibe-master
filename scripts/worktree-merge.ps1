#!/usr/bin/env pwsh
# Merge a feature branch, clean worktree, and update manifests
# Usage: ./scripts/worktree-merge.ps1 -Branch feature/REQ-XXXXXXXXXX-name [-BaseBranch main]

param(
    [Parameter(Mandatory=$true)][string]$Branch,
    [string]$BaseBranch = "main"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$WorktreeManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

if (-not (Test-Path $ReqManifestPath) -or -not (Test-Path $WorktreeManifestPath)) {
    Write-Host "Error: requirement/worktree manifest missing" -ForegroundColor Red
    exit 1
}

# Ensure working tree is clean
$StatusOutput = git -C $ProjectRoot status --porcelain 2>$null
if ($StatusOutput) {
    Write-Host "Error: Working tree is not clean. Commit or stash changes first." -ForegroundColor Red
    exit 1
}

# Validate branches exist
$BaseCheck = git -C $ProjectRoot rev-parse --verify $BaseBranch 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Base branch not found locally: $BaseBranch" -ForegroundColor Red
    exit 1
}

$BranchCheck = git -C $ProjectRoot show-ref --verify "refs/heads/$Branch" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Feature branch not found locally: $Branch" -ForegroundColor Red
    exit 1
}

# Look up worktree and requirement IDs
$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
$WtEntry = $WtManifest.worktrees | Where-Object { $_.branch -eq $Branch -or $_.id -eq $Branch } | Select-Object -First 1

$WorktreePath = $null
$ReqIds = @()
if ($WtEntry) {
    $WorktreePath = $WtEntry.path
    $ReqIds = @($WtEntry.requirementIds)
}

# Merge
Write-Host "Merging $Branch into $BaseBranch..."
git -C $ProjectRoot checkout $BaseBranch
git -C $ProjectRoot merge --no-ff $Branch -m "Merge $Branch"

# Remove worktree
if ($WorktreePath -and (Test-Path $WorktreePath)) {
    git -C $ProjectRoot worktree remove $WorktreePath
}

# Delete feature branch
git -C $ProjectRoot branch -d $Branch

# Update worktree manifest
$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
foreach ($W in $WtManifest.worktrees) {
    if ($W.branch -eq $Branch -or $W.id -eq $Branch) {
        $W.status = "MERGED"
        $W | Add-Member -NotePropertyName "mergedAt" -NotePropertyValue $Timestamp -Force
    }
}
$WtManifest | ConvertTo-Json -Depth 10 | Set-Content $WorktreeManifestPath -Encoding UTF8

# Determine target status based on requiresDeployment flag
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$RequiresDeployment = $Manifest.requiresDeployment
if ($null -eq $RequiresDeployment) { $RequiresDeployment = $true }

if ($RequiresDeployment -eq $false) {
    $ReqTargetStatus = "DEPLOYED"
} else {
    $ReqTargetStatus = "MERGED"
}

# Update requirement statuses
foreach ($ReqId in $ReqIds) {
    $CurrentReqStatus = ($Manifest.requirements | Where-Object { $_.id -eq $ReqId }).status
    if ($CurrentReqStatus -ne "CODE_REVIEW" -and $CurrentReqStatus -ne "MERGED") {
        Write-Host "Warning: $ReqId is in $CurrentReqStatus (expected CODE_REVIEW). Proceeding anyway." -ForegroundColor Yellow
    }

    foreach ($R in $Manifest.requirements) {
        if ($R.id -eq $ReqId) {
            $R.status = $ReqTargetStatus
            $R.updatedAt = $Timestamp
            if ($ReqTargetStatus -eq "DEPLOYED") {
                $R | Add-Member -NotePropertyName "deployedAt" -NotePropertyValue $Timestamp -Force
            }
        }
    }
}
$Manifest | ConvertTo-Json -Depth 10 | Set-Content $ReqManifestPath -Encoding UTF8

# Regenerate docs
$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) { & $RegenScript }

# Git commit
git -C $ProjectRoot add .requirement-manifest.json .worktree-manifest.json REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/ 2>$null
git -C $ProjectRoot commit -m "chore: merge $Branch" --no-verify 2>$null

Write-Host "Merge complete: $Branch -> $BaseBranch"
foreach ($ReqId in $ReqIds) {
    Write-Host "   $ReqId -> $ReqTargetStatus"
}
if ($RequiresDeployment -eq $true -and $ReqTargetStatus -eq "MERGED") {
    Write-Host ""
    Write-Host "Requirements merged but not yet deployed. Deploy your changes, then run:"
    foreach ($ReqId in $ReqIds) {
        Write-Host "   /update-requirement $ReqId DEPLOYED"
    }
}
