#!/usr/bin/env pwsh
# Create a git worktree for a requirement and mark it IN_PROGRESS
# Usage: ./scripts/start-work.ps1 -ReqId REQ-XXXXXXXXXX [-BaseBranch main]

param(
    [Parameter(Mandatory=$true)][string]$ReqId,
    [string]$BaseBranch = "main"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$WorktreeManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

# Validate REQ ID format
if ($ReqId -notmatch '^REQ-\d{10,}$') {
    Write-Host "Error: Invalid requirement ID format: $ReqId" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

# Load manifest
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Req = $Manifest.requirements | Where-Object { $_.id -eq $ReqId } | Select-Object -First 1

if (-not $Req) {
    Write-Host "Error: Requirement not found: $ReqId" -ForegroundColor Red
    exit 1
}

# Check for existing active worktree
$ActiveWorktree = $Req.worktreeId
if ($ActiveWorktree -and (Test-Path $WorktreeManifestPath)) {
    $WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
    $ExistingWt = $WtManifest.worktrees | Where-Object { $_.id -eq $ActiveWorktree -and $_.status -eq "ACTIVE" } | Select-Object -First 1
    if ($ExistingWt) {
        Write-Host "Error: Requirement $ReqId already has an active worktree: $ActiveWorktree" -ForegroundColor Red
        exit 1
    }
}

# Generate branch ID and worktree path
$Slug = ($Req.name.ToLower() -replace '[^a-z0-9]','-' -replace '-+','-' -replace '^-|-$','')
$BranchId = "feature/$ReqId-$Slug"
$WorktreePath = Join-Path (Split-Path $ProjectRoot -Parent) $BranchId.Replace("/", "\")

# Validate base branch exists
$BranchCheck = git -C $ProjectRoot rev-parse --verify $BaseBranch 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Base branch does not exist locally: $BaseBranch" -ForegroundColor Red
    exit 1
}

# Check worktree path doesn't already exist
if (Test-Path $WorktreePath) {
    Write-Host "Error: Worktree path already exists: $WorktreePath" -ForegroundColor Red
    exit 1
}

# Create parent directory
$ParentDir = Split-Path $WorktreePath -Parent
if (-not (Test-Path $ParentDir)) {
    New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
}

# Create the worktree
$BranchExists = git -C $ProjectRoot show-ref --verify "refs/heads/$BranchId" 2>$null
if ($LASTEXITCODE -eq 0) {
    git -C $ProjectRoot worktree add $WorktreePath $BranchId
} else {
    git -C $ProjectRoot worktree add -b $BranchId $WorktreePath $BaseBranch
}
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to create worktree" -ForegroundColor Red
    exit 1
}

# Ensure worktree manifest exists
if (-not (Test-Path $WorktreeManifestPath)) {
    $DefaultWt = @{
        '$schema' = ".worktree-manifest.schema.json"
        version = "1.0"
        worktrees = @()
    } | ConvertTo-Json -Depth 5
    Set-Content -Path $WorktreeManifestPath -Value $DefaultWt -Encoding UTF8
}

# Validate updatedAt >= createdAt
$CreatedAt = $Req.createdAt
if ($CreatedAt -and $Timestamp -lt $CreatedAt) {
    Write-Host "Error: updatedAt ($Timestamp) would be before createdAt ($CreatedAt)" -ForegroundColor Red
    exit 1
}

# Update requirement manifest
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
foreach ($R in $Manifest.requirements) {
    if ($R.id -eq $ReqId) {
        $R.status = "IN_PROGRESS"
        $R.worktreeId = $BranchId
        $R.updatedAt = $Timestamp
    }
}
$Manifest | ConvertTo-Json -Depth 10 | Set-Content $ReqManifestPath -Encoding UTF8

# Update worktree manifest
$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
$NewWt = [PSCustomObject]@{
    id = $BranchId
    path = $WorktreePath
    branch = $BranchId
    baseBranch = $BaseBranch
    requirementIds = @($ReqId)
    createdAt = $Timestamp
    status = "ACTIVE"
}
$WtManifest.worktrees = @($WtManifest.worktrees) + @($NewWt)
$WtManifest | ConvertTo-Json -Depth 10 | Set-Content $WorktreeManifestPath -Encoding UTF8

# Regenerate docs
$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) {
    & $RegenScript
}

# Generate/update Development Plan
$PlanScript = Join-Path $ProjectRoot "scripts\generate-plan.ps1"
if (Test-Path $PlanScript) {
    try { & $PlanScript -ReqId $ReqId } catch { Write-Host "Warning: Plan generation failed (non-fatal)" }
}

# Git commit
git -C $ProjectRoot add .requirement-manifest.json .worktree-manifest.json REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/ 2>$null
git -C $ProjectRoot commit -m "chore: start work on $ReqId" --no-verify 2>$null

Write-Host ""
Write-Host "Start-work complete for $ReqId"
Write-Host "   Worktree: $BranchId"
Write-Host "   Path: $WorktreePath"
Write-Host "   Status: IN_PROGRESS"
