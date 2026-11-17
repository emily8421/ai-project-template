# Sync notice: This file is maintained by ai-project-template and may be overwritten when a derived project syncs template methodology.
# Do not edit it directly in derived projects; propose reusable changes in _governance/_proposals/ and upstream them to the template repository.
# menu-launcher.ps1 - console launcher menu (point-and-run entry beside the chat UI).
# Single source of truth: scripts/launcher-menu.json (rendered from the manifest, never duplicated here).
# Red line: selecting a session item only assembles a prompt for an AI CLI session;
# remote state changes still require explicit per-step authorization inside that session.
# ASCII-only source on purpose: all user-facing text (Chinese) lives in the UTF-8 JSON manifest.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\menu-launcher.ps1 [-List]
param(
    [switch]$List
)

$ErrorActionPreference = 'Stop'

# Ensure Chinese text from the UTF-8 manifest renders correctly on non-UTF8 consoles.
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $PSScriptRoot 'launcher-menu.json'
if (-not (Test-Path $manifestPath)) {
    Write-Host "launcher-menu.json not found next to this script: $manifestPath"
    exit 2
}
$raw = [System.IO.File]::ReadAllText($manifestPath, [System.Text.Encoding]::UTF8)
$manifest = $raw | ConvertFrom-Json

$isMaintainerRepo = Test-Path (Join-Path $root 'MAINTAINERS.md')
$repoScope = if ($isMaintainerRepo) { 'maintainer' } else { 'derived' }
$repoLabel = if ($isMaintainerRepo) { 'template repo (maintainer)' } else { 'derived repo' }

$items = @($manifest.items | Where-Object { $_.scope -eq 'all' -or $_.scope -eq $repoScope })

$script:choiceMap = @{}

function Show-Menu {
    Write-Host ''
    Write-Host "=== ai-project-template launcher menu [$repoLabel] ==="
    Write-Host 'Selecting != authorization: session items only prepare a prompt;'
    Write-Host 'remote changes still need per-step confirmation inside the AI session.'
    Write-Host ''
    Write-Host '[script items - run directly]'
    $n = 1
    foreach ($it in $items | Where-Object { $_.type -eq 'script' }) {
        $script:choiceMap[[string]$n] = $it
        Write-Host ("  {0,2}. {1}" -f $n, $it.title)
        $n++
    }
    Write-Host '[session items - prepare prompt for an AI CLI session]'
    foreach ($it in $items | Where-Object { $_.type -eq 'session' }) {
        $script:choiceMap[[string]$n] = $it
        Write-Host ("  {0,2}. {1}" -f $n, $it.title)
        $n++
    }
    Write-Host '   q. quit'
}

function Invoke-ScriptItem($it) {
    $target = Join-Path $root $it.target
    if (-not (Test-Path $target)) {
        Write-Host "[skip] target not present in this repo: $($it.target)"
        Write-Host '       (template-only scripts do not sync down; run it in the template repo.)'
        return
    }
    $argList = @()
    if ($it.args) { $argList = [string]$it.args -split '\s+' | Where-Object { $_ -ne '' } }
    Write-Host ''
    Write-Host (">> running: $($it.target) $($argList -join ' ')")
    if ($it.runner -eq 'bash') {
        $bash = Get-Command bash -ErrorAction SilentlyContinue
        if (-not $bash) {
            Write-Host '[skip] bash not found on PATH. Run it manually inside Git Bash:'
            Write-Host "       bash $($it.target) $($argList -join ' ')"
            return
        }
        & bash $target @argList
    }
    else {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $target @argList
    }
    Write-Host (">> exit code: $LASTEXITCODE")
}

function Build-SessionPrompt($it) {
    $lines = @()
    if ($it.source -and $it.source -ne 'inline') {
        $srcPath = Join-Path $root $it.source
        if (Test-Path $srcPath) {
            $lines += ("First read the rule source: {0}" -f $it.source)
        }
        else {
            $lines += ("Rule source missing in this repo (sync gap?): {0}" -f $it.source)
        }
    }
    $lines += [string]$it.brief
    return ($lines -join "`n")
}

function Invoke-SessionItem($it) {
    $prompt = Build-SessionPrompt $it
    Write-Host ''
    Write-Host '--- prompt for your AI CLI session (run it in the RIGHT repo directory) ---'
    Write-Host $prompt
    Write-Host '---'
    Write-Host '[c] copy to clipboard  [l] launch claude  [x] launch codex  [Enter] back'
    $act = (Read-Host 'action').Trim().ToLower()
    if ($act -eq 'c') {
        try { Set-Clipboard -Value $prompt; Write-Host '[ok] copied to clipboard.' }
        catch { Write-Host ("[warn] clipboard unavailable: {0}" -f $_.Exception.Message) }
    }
    elseif ($act -eq 'l' -or $act -eq 'x') {
        $cli = if ($act -eq 'l') { 'claude' } else { 'codex' }
        $cmd = Get-Command $cli -ErrorAction SilentlyContinue
        if (-not $cmd) { Write-Host ("[skip] '{0}' not found on PATH." -f $cli); return }
        Write-Host (">> launching {0} with the prompt above (Ctrl+C to abort)..." -f $cli)
        & $cli $prompt
    }
}

if ($List) {
    foreach ($it in $items) {
        Write-Host ("{0}`t{1}`t{2}" -f $it.type, $it.scope, $it.title)
    }
    exit 0
}

while ($true) {
    Show-Menu
    $sel = (Read-Host 'select').Trim().ToLower()
    if ($sel -eq 'q' -or $sel -eq '') { break }
    $it = $script:choiceMap[$sel]
    if (-not $it) { Write-Host ("invalid choice: {0}" -f $sel); continue }
    if ($it.type -eq 'script') { Invoke-ScriptItem $it } else { Invoke-SessionItem $it }
}
Write-Host 'bye.'
