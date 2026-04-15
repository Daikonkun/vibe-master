#!/usr/bin/env pwsh
# Cross-platform dispatch layer for Vibe Master scripts
# Detects the OS and calls the appropriate script variant (.ps1 on Windows, .sh on Linux/macOS)
# Usage: ./scripts/dispatch.ps1 <script-name> [args...]
#   e.g.: ./scripts/dispatch.ps1 create-requirement "Feature" "Description"

param(
    [Parameter(Mandatory=$true, Position=0)][string]$ScriptName,
    [Parameter(ValueFromRemainingArguments=$true)][string[]]$ScriptArgs
)

$ErrorActionPreference = "Stop"

$ProjectRoot = git rev-parse --show-toplevel 2>$null
if (-not $ProjectRoot) { $ProjectRoot = $PWD.Path }
$ScriptsDir = Join-Path $ProjectRoot "scripts"

# Determine which variant to run
$IsWindows = $env:OS -eq "Windows_NT" -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)

if ($IsWindows) {
    # Prefer .ps1 on Windows
    $Ps1Path = Join-Path $ScriptsDir "$ScriptName.ps1"
    if (Test-Path $Ps1Path) {
        & $Ps1Path @ScriptArgs
        return
    }
    # Fall back to .sh via Git Bash if available
    $ShPath = Join-Path $ScriptsDir "$ScriptName.sh"
    if (Test-Path $ShPath) {
        $GitBash = "C:\Program Files\Git\bin\bash.exe"
        if (Test-Path $GitBash) {
            $UnixRoot = $ProjectRoot -replace '\\','/'
            if ($UnixRoot -match '^([A-Z]):') { $UnixRoot = '/' + $Matches[1].ToLower() + $UnixRoot.Substring(2) }
            $UnixScript = $ShPath -replace '\\','/'
            if ($UnixScript -match '^([A-Z]):') { $UnixScript = '/' + $Matches[1].ToLower() + $UnixScript.Substring(2) }
            $EscapedArgs = $ScriptArgs | ForEach-Object { "'$_'" }
            & $GitBash -c "cd '$UnixRoot' && bash '$UnixScript' $($EscapedArgs -join ' ')"
            return
        }
        Write-Host "Error: No .ps1 variant found and Git Bash not available for .sh fallback" -ForegroundColor Red
        exit 1
    }
    Write-Host "Error: Script not found: $ScriptName" -ForegroundColor Red
    exit 1
} else {
    # Prefer .sh on Linux/macOS
    $ShPath = Join-Path $ScriptsDir "$ScriptName.sh"
    if (Test-Path $ShPath) {
        & bash $ShPath @ScriptArgs
        return
    }
    # Fall back to .ps1 if pwsh is available
    $Ps1Path = Join-Path $ScriptsDir "$ScriptName.ps1"
    if (Test-Path $Ps1Path) {
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            & pwsh -File $Ps1Path @ScriptArgs
            return
        }
        Write-Host "Error: No .sh variant found and pwsh not available for .ps1 fallback" -ForegroundColor Red
        exit 1
    }
    Write-Host "Error: Script not found: $ScriptName" -ForegroundColor Red
    exit 1
}
