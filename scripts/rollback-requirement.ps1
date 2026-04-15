#!/usr/bin/env pwsh
# Rollback a merged requirement: revert its merge commit, restore manifests, and recreate worktree
# Usage: ./scripts/rollback-requirement.ps1 -ReqId REQ-XXXXXXXXXX [-BaseBranch main] [-Force]

param(
    [Parameter(Mandatory=$true)][string]$ReqId,
    [string]$BaseBranch = "main",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$WorktreeManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

if ($ReqId -notmatch '^REQ-\d{10,}$') {
    Write-Host "Error: Invalid requirement ID format: $ReqId" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $WorktreeManifestPath)) {
    Write-Host "Error: .worktree-manifest.json not found" -ForegroundColor Red
    exit 1
}

# Validate requirement exists and is in a rollback-eligible status
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Req = $Manifest.requirements | Where-Object { $_.id -eq $ReqId } | Select-Object -First 1

if (-not $Req) {
    Write-Host "Error: Requirement not found: $ReqId" -ForegroundColor Red
    exit 1
}

if ($Req.status -ne "MERGED" -and $Req.status -ne "DEPLOYED") {
    Write-Host "Error: Requirement $ReqId is in status $($Req.status). Only MERGED or DEPLOYED requirements can be rolled back." -ForegroundColor Red
    exit 1
}

# Look up the branch from worktree manifest
$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
$WtEntry = $WtManifest.worktrees | Where-Object { $_.requirementIds -contains $ReqId } | Select-Object -First 1

if (-not $WtEntry -or -not $WtEntry.branch) {
    Write-Host "Error: No worktree branch found for $ReqId in .worktree-manifest.json" -ForegroundColor Red
    exit 1
}

$Branch = $WtEntry.branch
$WorktreePath = $WtEntry.path

# Ensure working tree is clean
$StatusOutput = git -C $ProjectRoot status --porcelain 2>$null
if ($StatusOutput) {
    Write-Host "Error: Working tree is not clean. Commit or stash changes first." -ForegroundColor Red
    exit 1
}

# Ensure we are on the base branch
$CurrentBranch = git -C $ProjectRoot rev-parse --abbrev-ref HEAD
if ($CurrentBranch -ne $BaseBranch) {
    Write-Host "Switching to $BaseBranch..."
    git -C $ProjectRoot checkout $BaseBranch
}

# Find the merge commit for this branch
$MergeCommit = git -C $ProjectRoot log --merges --grep="Merge $Branch" --format="%H" | Select-Object -First 1

if (-not $MergeCommit) {
    Write-Host "Error: Could not find a merge commit for branch $Branch on $BaseBranch" -ForegroundColor Red
    exit 1
}

# Safety check: detect newer merge commits after the target
$NewerMerges = git -C $ProjectRoot log --merges "${MergeCommit}..HEAD" --format="%H %s" 2>$null
if ($NewerMerges) {
    $MergeCount = ($NewerMerges | Measure-Object).Count
    Write-Host "Warning: There are $MergeCount merge commit(s) after the target merge." -ForegroundColor Yellow
    Write-Host "   Reverting may cause conflicts with subsequent work."
    Write-Host ""
    Write-Host "Newer merges:"
    $NewerMerges | Select-Object -First 5 | ForEach-Object { Write-Host "   $_" }
    Write-Host ""
    if (-not $Force) {
        Write-Host "Aborting rollback. Use -Force to override." -ForegroundColor Red
        exit 1
    }
    Write-Host "Proceeding anyway (-Force)."
}

# Revert the merge commit
Write-Host "Reverting merge commit $MergeCommit for $Branch..."
git -C $ProjectRoot revert -m 1 --no-edit $MergeCommit

# Recreate the feature branch from HEAD (post-revert)
$BranchExists = git -C $ProjectRoot show-ref --verify "refs/heads/$Branch" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Branch $Branch already exists locally. Skipping branch creation."
} else {
    Write-Host "Recreating branch $Branch from HEAD..."
    git -C $ProjectRoot branch $Branch HEAD
}

# Recreate the worktree if the path doesn't already exist
if ($WorktreePath -and -not (Test-Path $WorktreePath)) {
    Write-Host "Recreating worktree at $WorktreePath..."
    $ParentDir = Split-Path $WorktreePath -Parent
    if (-not (Test-Path $ParentDir)) {
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    }
    git -C $ProjectRoot worktree add $WorktreePath $Branch
}

# Update .requirement-manifest.json
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
foreach ($R in $Manifest.requirements) {
    if ($R.id -eq $ReqId) {
        $R.status = "IN_PROGRESS"
        $R.updatedAt = $Timestamp
        if ($R.PSObject.Properties.Name -contains "deployedAt") {
            $R.PSObject.Properties.Remove("deployedAt")
        }
    }
}
$Manifest | ConvertTo-Json -Depth 10 | Set-Content $ReqManifestPath -Encoding UTF8

# Update worktree manifest
$WtManifest = Get-Content $WorktreeManifestPath -Raw | ConvertFrom-Json
foreach ($W in $WtManifest.worktrees) {
    if ($W.requirementIds -contains $ReqId) {
        $W.status = "ACTIVE"
        if ($W.PSObject.Properties.Name -contains "mergedAt") {
            $W.PSObject.Properties.Remove("mergedAt")
        }
    }
}
$WtManifest | ConvertTo-Json -Depth 10 | Set-Content $WorktreeManifestPath -Encoding UTF8

# Update spec file status
$SpecDir = Join-Path $ProjectRoot "docs\requirements"
$SpecFile = Get-ChildItem -Path $SpecDir -Filter "$ReqId-*.md" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if ($SpecFile) {
    $Content = Get-Content $SpecFile.FullName -Raw -Encoding UTF8
    $Content = $Content -replace '\*\*Status\*\*:.*', "**Status**: IN_PROGRESS  "
    Set-Content -Path $SpecFile.FullName -Value $Content -Encoding UTF8 -NoNewline
}

# Regenerate docs
$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) { & $RegenScript }

# Git commit
git -C $ProjectRoot add .requirement-manifest.json .worktree-manifest.json REQUIREMENTS.md docs/STATUS.md docs/ROADMAP.md docs/DEPENDENCIES.md docs/requirements/ 2>$null
git -C $ProjectRoot commit -m "chore: rollback $ReqId" --no-verify 2>$null

Write-Host "Rollback complete for $ReqId"
Write-Host "   Status: IN_PROGRESS"
Write-Host "   Branch: $Branch"
