#!/usr/bin/env pwsh
# Initialize a new vibe project by clearing Vibe-Master-internal REQs
# while preserving any project-specific REQs.
# Usage: ./scripts/init-project.ps1 [-ProjectName "My Vibe Project"]

param(
    [string]$ProjectName = "My Vibe Project"
)

$ErrorActionPreference = "Stop"

Write-Host "Vibe Agent Orchestrator - Project Initialization"
Write-Host "===================================================="
Write-Host ""

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

Write-Host "Project: $ProjectName"
Write-Host "Location: $ProjectRoot"
Write-Host ""

# Self-protection: refuse to run on the Vibe Master source repo
if (Test-Path (Join-Path $ProjectRoot ".vibe-master-source")) {
    Write-Host "Error: This is the Vibe Master source repository." -ForegroundColor Red
    Write-Host "   The /init command cannot run here to protect the template's own REQ history."
    Write-Host "   Clone or copy this repo to a new directory first."
    exit 1
}

# Initialize git if needed
if (-not (Test-Path (Join-Path $ProjectRoot ".git"))) {
    Write-Host "Initializing git repository..."
    git init
    git config user.email "ai@vibe.local"
    git config user.name "Vibe Agent"
}

# Create docs/requirements directory
$SpecDir = Join-Path $ProjectRoot "docs\requirements"
if (-not (Test-Path $SpecDir)) {
    New-Item -ItemType Directory -Path $SpecDir -Force | Out-Null
}

# --- Selective REQ clearing ---
$ManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$VmIds = @()

if (Test-Path $ManifestPath) {
    $Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json

    # Collect IDs of vibe-master-origin REQs
    $VmReqs = @($Manifest.requirements | Where-Object { $_.origin -eq "vibe-master" })
    $VmIds = $VmReqs | ForEach-Object { $_.id }

    # Remove spec files for vibe-master REQs only
    $Cleaned = 0
    foreach ($ReqId in $VmIds) {
        $Pattern = "$ReqId-*.md"
        $Files = Get-ChildItem -Path $SpecDir -Filter $Pattern -File
        foreach ($F in $Files) {
            Remove-Item $F.FullName -Force
            $Cleaned++
        }
    }
    Write-Host "Cleared $Cleaned Vibe Master REQ spec file(s)"

    # Remove vibe-master REQs from manifest, keep project REQs
    $Kept = @($Manifest.requirements | Where-Object { $_.origin -ne "vibe-master" }).Count
    $Manifest.projectName = $ProjectName
    $Manifest.requirements = @($Manifest.requirements | Where-Object { $_.origin -ne "vibe-master" })
    $Manifest | ConvertTo-Json -Depth 10 | Set-Content $ManifestPath -Encoding UTF8
    Write-Host "   Preserved $Kept project REQ(s)"
} else {
    Write-Host "Initializing requirement manifest..."
    $Manifest = [PSCustomObject]@{
        '$schema' = ".requirement-manifest.schema.json"
        version = "1.0"
        projectName = $ProjectName
        requiresDeployment = $true
        requirements = @()
    }
    $Manifest | ConvertTo-Json -Depth 10 | Set-Content $ManifestPath -Encoding UTF8
}

# Selectively clear worktree manifest
$WtManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"
Write-Host "Cleaning worktree manifest..."

if ((Test-Path $WtManifestPath) -and $VmIds.Count -gt 0) {
    $WtManifest = Get-Content $WtManifestPath -Raw | ConvertFrom-Json
    $WtManifest.worktrees = @($WtManifest.worktrees | Where-Object {
        $ReqIds = $_.requirementIds
        if (-not $ReqIds) { return $true }
        $HasVmId = $false
        foreach ($Rid in $ReqIds) {
            if ($VmIds -contains $Rid) { $HasVmId = $true; break }
        }
        -not $HasVmId
    })
    $WtManifest | ConvertTo-Json -Depth 10 | Set-Content $WtManifestPath -Encoding UTF8
} else {
    $DefaultWt = [PSCustomObject]@{
        '$schema' = ".worktree-manifest.schema.json"
        version = "1.0"
        worktrees = @()
    }
    $DefaultWt | ConvertTo-Json -Depth 5 | Set-Content $WtManifestPath -Encoding UTF8
}

# Regenerate docs
$RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
if (Test-Path $RegenScript) {
    Write-Host "Regenerating docs..."
    & $RegenScript
}

# Create initial commit
git -C $ProjectRoot add -A
git -C $ProjectRoot commit -m "chore: init project $ProjectName" --no-verify 2>$null

Write-Host ""
Write-Host "Initialization complete!"
Write-Host ""
Write-Host "Next steps:"
Write-Host '  1. Create your first requirement: /add-requirement "Feature" "Description"'
Write-Host "  2. Check status: /status"
Write-Host "  3. Start work: /start-work REQ-XXXXX"
Write-Host ""
Write-Host "Configuration complete. Open in VS Code to begin!"
