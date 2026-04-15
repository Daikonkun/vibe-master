#!/usr/bin/env pwsh
# Generate all documentation from requirement and worktree manifests
# Usage: ./scripts/regenerate-docs.ps1

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"
$WorktreeManifestPath = Join-Path $ProjectRoot ".worktree-manifest.json"

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

$DocsDir = Join-Path $ProjectRoot "docs"
if (-not (Test-Path $DocsDir)) {
    New-Item -ItemType Directory -Path $DocsDir -Force | Out-Null
}

Write-Host "Regenerating documentation..."

# Load manifest
$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Reqs = @($Manifest.requirements)
$RequiresDeployment = $Manifest.requiresDeployment
if ($null -eq $RequiresDeployment) { $RequiresDeployment = $true }

# --- Sync per-requirement spec status lines ---
Write-Host "Syncing docs/requirements status fields..."
$SpecDir = Join-Path $ProjectRoot "docs\requirements"
if (Test-Path $SpecDir) {
    foreach ($Req in $Reqs) {
        $Pattern = "$($Req.id)-*.md"
        $SpecFile = Get-ChildItem -Path $SpecDir -Filter $Pattern -File | Select-Object -First 1
        if ($SpecFile) {
            $Content = Get-Content $SpecFile.FullName -Raw -Encoding UTF8
            $Content = $Content -replace '\*\*Status\*\*:.*', "**Status**: $($Req.status)  "
            Set-Content -Path $SpecFile.FullName -Value $Content -Encoding UTF8 -NoNewline
        }
    }
}

# --- Generate REQUIREMENTS.md ---
Write-Host "Generating REQUIREMENTS.md..."
$Sb = [System.Text.StringBuilder]::new()
[void]$Sb.AppendLine("# Product Requirements")
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("Auto-generated summary of all product requirements. For detailed specs, see individual files in ``docs/requirements/``.")
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("| ID | Name | Status | Priority | Worktree | Created | Updated |")
[void]$Sb.AppendLine("|---|---|---|---|---|---|---|")

foreach ($Req in $Reqs) {
    $Wt = if ($Req.worktreeId) { $Req.worktreeId } else { [char]0x2014 }
    $Created = $Req.createdAt.Split("T")[0]
    $Updated = $Req.updatedAt.Split("T")[0]
    [void]$Sb.AppendLine("| $($Req.id) | $($Req.name) | $($Req.status) | $($Req.priority) | $Wt | $Created | $Updated |")
}
[void]$Sb.AppendLine("")

# Status breakdown
$StatusList = @("PROPOSED","IN_PROGRESS","CODE_REVIEW","MERGED","DEPLOYED","BLOCKED","BACKLOG","CANCELLED")
$StatusCounts = @{}
foreach ($Req in $Reqs) {
    $StatusCounts[$Req.status] = $StatusCounts[$Req.status] + 1
}
[void]$Sb.AppendLine("## Status Breakdown")
foreach ($Status in $StatusList) {
    $Count = if ($StatusCounts[$Status]) { $StatusCounts[$Status] } else { 0 }
    $Label = (Get-Culture).TextInfo.ToTitleCase(($Status -replace "_", " ").ToLower())
    [void]$Sb.AppendLine("- **$Label**: $Count")
}
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("## Next Steps")
[void]$Sb.AppendLine('Use ``/add-requirement "Feature name" "Description"`` to submit requirements.')
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("---")
[void]$Sb.AppendLine("")
$Now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
[void]$Sb.AppendLine("* Last updated: $Now")
[void]$Sb.AppendLine("* Structured data: See ``.requirement-manifest.json``")
[void]$Sb.AppendLine("* Worktree mapping: See ``.worktree-manifest.json``")

[System.IO.File]::WriteAllText((Join-Path $ProjectRoot "REQUIREMENTS.md"), $Sb.ToString(), (New-Object System.Text.UTF8Encoding $false))

# --- Generate STATUS.md ---
Write-Host "Generating docs/STATUS.md..."
$Sb = [System.Text.StringBuilder]::new()
[void]$Sb.AppendLine("# Project Status")
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("Kanban-style view of all requirements and their current state.")
[void]$Sb.AppendLine("")

foreach ($Status in $StatusList) {
    $Matching = @($Reqs | Where-Object { $_.status -eq $Status })
    $Label = (Get-Culture).TextInfo.ToTitleCase(($Status -replace "_", " ").ToLower())
    [void]$Sb.AppendLine("## $Label ($($Matching.Count))")
    [void]$Sb.AppendLine("")
    foreach ($Req in $Matching) {
        $Wt = if ($Req.worktreeId) { $Req.worktreeId } else { "none" }
        [void]$Sb.AppendLine("* $($Req.id): $($Req.name) (priority: $($Req.priority))")
        [void]$Sb.AppendLine("  - Worktree: $Wt")
    }
    [void]$Sb.AppendLine("")
}

$Total = $Reqs.Count
$Deployed = @($Reqs | Where-Object { $_.status -eq "DEPLOYED" }).Count
$Merged = @($Reqs | Where-Object { $_.status -eq "MERGED" }).Count
if ($RequiresDeployment -eq $false) {
    $Completed = $Deployed + $Merged
} else {
    $Completed = $Deployed
}
$Pct = if ($Total -eq 0) { 0 } else { [math]::Floor($Completed * 100 / $Total) }
$InProgress = @($Reqs | Where-Object { $_.status -eq "IN_PROGRESS" }).Count
$Blocked = @($Reqs | Where-Object { $_.status -eq "BLOCKED" }).Count

[void]$Sb.AppendLine("## Stats")
[void]$Sb.AppendLine("- Total Requirements: $Total")
if ($RequiresDeployment -eq $false) {
    [void]$Sb.AppendLine("- Completed (Merged + Deployed): $Completed ($Pct%)")
} else {
    [void]$Sb.AppendLine("- Deployed: $Deployed ($Pct%)")
    [void]$Sb.AppendLine("- Merged (awaiting deploy): $Merged")
}
[void]$Sb.AppendLine("- In Progress: $InProgress")
[void]$Sb.AppendLine("- Blocked: $Blocked")

[System.IO.File]::WriteAllText((Join-Path $ProjectRoot "docs\STATUS.md"), $Sb.ToString(), (New-Object System.Text.UTF8Encoding $false))

# --- Generate ROADMAP.md ---
Write-Host "Generating docs/ROADMAP.md..."
$Sb = [System.Text.StringBuilder]::new()
[void]$Sb.AppendLine("# Roadmap")
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("Timeline view of all requirements organized by status and priority.")
[void]$Sb.AppendLine("")

$PriorityOrder = @(
    @{ Key = "CRITICAL"; Label = "Critical Items" },
    @{ Key = "HIGH"; Label = "High Priority" },
    @{ Key = "MEDIUM"; Label = "Medium Priority" },
    @{ Key = "LOW"; Label = "Low Priority" }
)
foreach ($P in $PriorityOrder) {
    $Matching = @($Reqs | Where-Object { $_.priority -eq $P.Key })
    [void]$Sb.AppendLine("## $($P.Label)")
    foreach ($Req in $Matching) {
        [void]$Sb.AppendLine("* [$($Req.status)] $($Req.id): $($Req.name)")
    }
    [void]$Sb.AppendLine("")
}

[System.IO.File]::WriteAllText((Join-Path $ProjectRoot "docs\ROADMAP.md"), $Sb.ToString(), (New-Object System.Text.UTF8Encoding $false))

# --- Generate DEPENDENCIES.md ---
Write-Host "Generating docs/DEPENDENCIES.md..."
$Sb = [System.Text.StringBuilder]::new()
[void]$Sb.AppendLine("# Requirement Dependencies")
[void]$Sb.AppendLine("")
[void]$Sb.AppendLine("Graph of requirement dependencies and relationships.")
[void]$Sb.AppendLine("")

foreach ($Req in $Reqs) {
    $Deps = $Req.dependsOn
    if ($Deps -and $Deps.Count -gt 0) {
        [void]$Sb.AppendLine("$($Req.id): $($Req.name)")
        [void]$Sb.AppendLine("  └─ Depends on: $($Deps -join ', ')")
        [void]$Sb.AppendLine("")
    } else {
        [void]$Sb.AppendLine("$($Req.id): $($Req.name) (no dependencies)")
        [void]$Sb.AppendLine("")
    }
}

[System.IO.File]::WriteAllText((Join-Path $ProjectRoot "docs\DEPENDENCIES.md"), $Sb.ToString(), (New-Object System.Text.UTF8Encoding $false))

Write-Host ""
Write-Host "Documentation regenerated successfully!"
Write-Host ""
Write-Host "Generated files:"
Write-Host "  - REQUIREMENTS.md (summary table)"
Write-Host "  - docs/STATUS.md (kanban board)"
Write-Host "  - docs/ROADMAP.md (timeline)"
Write-Host "  - docs/DEPENDENCIES.md (dependency graph)"
