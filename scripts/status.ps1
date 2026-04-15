#!/usr/bin/env pwsh
# Show project requirement status with optional doc refresh
# Usage: ./scripts/status.ps1 [-NoRefresh]

param([switch]$NoRefresh)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ReqManifestPath = Join-Path $ProjectRoot ".requirement-manifest.json"

if (-not (Test-Path $ReqManifestPath)) {
    Write-Host "Error: .requirement-manifest.json not found" -ForegroundColor Red
    exit 1
}

if (-not $NoRefresh) {
    $RegenScript = Join-Path $ProjectRoot "scripts\regenerate-docs.ps1"
    if (Test-Path $RegenScript) { & $RegenScript }
}

$Manifest = Get-Content $ReqManifestPath -Raw | ConvertFrom-Json
$Reqs = @($Manifest.requirements)
$RequiresDeployment = $Manifest.requiresDeployment
if ($null -eq $RequiresDeployment) { $RequiresDeployment = $true }

Write-Host "=== Project Status ==="
Write-Host "Manifest: $ReqManifestPath"

$TotalCount = $Reqs.Count
$MergedCount = @($Reqs | Where-Object { $_.status -eq "MERGED" }).Count
$DeployedCount = @($Reqs | Where-Object { $_.status -eq "DEPLOYED" }).Count

if ($RequiresDeployment -eq $false) {
    $Outstanding = @($Reqs | Where-Object { $_.status -ne "DEPLOYED" -and $_.status -ne "CANCELLED" -and $_.status -ne "MERGED" })
    $CompletedCount = $MergedCount + $DeployedCount
} else {
    $Outstanding = @($Reqs | Where-Object { $_.status -ne "DEPLOYED" -and $_.status -ne "CANCELLED" })
    $CompletedCount = $DeployedCount
}

Write-Host "Total: $TotalCount"
Write-Host "Outstanding: $($Outstanding.Count)"
Write-Host "Completed: $CompletedCount"

Write-Host ""
Write-Host "Outstanding REQ IDs:"

if ($RequiresDeployment -eq $false) {
    $OutstandingStatuses = @("PROPOSED","BACKLOG","IN_PROGRESS","CODE_REVIEW","BLOCKED")
} else {
    $OutstandingStatuses = @("PROPOSED","BACKLOG","IN_PROGRESS","CODE_REVIEW","BLOCKED","MERGED")
}

$FoundAny = $false
foreach ($Status in $OutstandingStatuses) {
    $Items = @($Reqs | Where-Object { $_.status -eq $Status })
    if ($Items.Count -gt 0) {
        $Ids = ($Items | ForEach-Object { $_.id }) -join ", "
        Write-Host "- ${Status}: $Ids"
        $FoundAny = $true
    }
}
if (-not $FoundAny) { Write-Host "- None" }

Write-Host ""
Write-Host "Outstanding details:"
foreach ($Req in $Outstanding) {
    Write-Host "- $($Req.id) [$($Req.status)]: $($Req.name) (priority: $($Req.priority))"
}

Write-Host ""
Write-Host "Completed:"
if ($RequiresDeployment -eq $false) {
    Write-Host "- MERGED (auto-completed): $MergedCount"
    Write-Host "- DEPLOYED: $DeployedCount"
    Write-Host "- TOTAL COMPLETED: $CompletedCount"
} else {
    Write-Host "- MERGED (awaiting deploy): $MergedCount"
    Write-Host "- DEPLOYED: $DeployedCount"
    Write-Host "- TOTAL COMPLETED: $CompletedCount"
}
Write-Host ""
Write-Host "Status board: docs/STATUS.md"
