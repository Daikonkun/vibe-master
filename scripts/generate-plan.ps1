#!/usr/bin/env pwsh
# Generate or update Development Plan section in a requirement spec file
# Usage: ./scripts/generate-plan.ps1 -ReqId REQ-XXXXXXXXXX [-SpecFile path]

param(
    [Parameter(Mandatory=$true)][string]$ReqId,
    [string]$SpecFile = ""
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }

if (-not $SpecFile) {
    $SpecDir = Join-Path $ProjectRoot "docs\requirements"
    $Pattern = "$ReqId-*.md"
    $Found = Get-ChildItem -Path $SpecDir -Filter $Pattern -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($Found) { $SpecFile = $Found.FullName }
}

if (-not $SpecFile -or -not (Test-Path $SpecFile)) {
    Write-Host "Error: Spec file not found for $ReqId" -ForegroundColor Red
    exit 1
}

$Content = Get-Content $SpecFile -Raw -Encoding UTF8

# Extract key sections using regex
$Description = "No description"
if ($Content -match '(?s)## Description\s*\r?\n(.*?)## Success Criteria') {
    $Lines = $Matches[1].Trim() -split "`n" | Where-Object { $_.Trim() } | Select-Object -First 1
    $Description = $Lines.Trim().Substring(0, [math]::Min(80, $Lines.Trim().Length))
}

$Success = "No success criteria"
if ($Content -match '(?s)## Success Criteria\s*\r?\n(.*?)## Technical Notes') {
    $Lines = $Matches[1].Trim() -split "`n" | Where-Object { $_.Trim() } | Select-Object -First 2
    $Success = ($Lines -join " ").Trim().Substring(0, [math]::Min(100, ($Lines -join " ").Trim().Length))
}

$TechNotes = "No technical notes"
if ($Content -match '(?s)## Technical Notes\s*\r?\n(.*?)## Dependencies') {
    $Lines = $Matches[1].Trim() -split "`n" | Where-Object { $_.Trim() } | Select-Object -First 1
    $TechNotes = $Lines.Trim().Substring(0, [math]::Min(100, $Lines.Trim().Length))
}

$RelSpec = "docs/requirements/$(Split-Path $SpecFile -Leaf)"
$Now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$PlanSection = @"

## Development Plan

1. Review Description, Success Criteria, and Technical Notes in ``$RelSpec``.
   - **Summary**: $Description
   - **Key criteria**: $Success
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: $TechNotes
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run ``./scripts/regenerate-docs.ps1`` to update manifests and generated docs.
5. Validate with ``./scripts/show-requirement.ps1 -ReqId $ReqId`` and verify success criteria are met.

**Last updated**: $Now
"@

# Replace existing Development Plan or insert before Dependencies
if ($Content -match '## Development Plan') {
    # Replace existing plan section
    $Content = $Content -replace '(?s)## Development Plan.*?(?=\r?\n## (Dependencies|Worktree))', $PlanSection
} else {
    # Insert before Dependencies section
    $Content = $Content -replace '(## Dependencies)', "$PlanSection`n`n`$1"
}

Set-Content -Path $SpecFile -Value $Content -Encoding UTF8 -NoNewline

Write-Host "Development Plan updated in $SpecFile"
