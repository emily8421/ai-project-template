# check-registry-drift.ps1 —— 模板仓派生登记对账（advisory，只读）
#
# Template-only notice: 本脚本为 ai-project-template 模板仓专用，不进 template-sync.json、不随同步下行；
# 派生项目中的同名残留属历史下行错误，可安全删除（见 scripts/README.md §1 / §5）。
#
# 用途：逐仓比对 _governance/ai-records/project-registry/registry.md 登记的 Inherited 版本与各派生仓
#       TEMPLATE-BASE.md 的 Current synced template version，输出差异表并在存在漂移时返回非零退出码，
#       使「派生仓自行同步后母仓未回写登记」的漂移在固定时点被例行发现（提案
#       TEMPLATE-UPGRADE-registry-writeback-enforcement.md）。建议挂载时点：C1 triage 开头、
#       半年度机制审计、派生同步窗口收尾。
# 只读：不修改任何文件、不访问网络；漂移仅提示，处置（回写登记 / 补同步）由维护者决定。
# 用法：powershell -File scripts/check-registry-drift.ps1 [-RegistryPath <registry.md 绝对或相对路径>]
# 退出码：0 = 全部一致（含跳过项）；1 = 存在漂移或不可达仓；2 = 结构性错误（registry 缺失 / 表格无法解析）。

param(
    [string]$RegistryPath = (Join-Path $PSScriptRoot "..\_governance\ai-records\project-registry\registry.md")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $RegistryPath -PathType Leaf)) {
    Write-Output "FAIL: registry 不存在: $RegistryPath"
    exit 2
}

$rows = @()
foreach ($line in (Get-Content -LiteralPath $RegistryPath -Encoding UTF8)) {
    if ($line -notmatch '^\|') { continue }
    $cells = ($line -split '\|') | ForEach-Object { $_.Trim() }
    # 列序：[1]Project [2]Aliases [3]Type [4]Repo [5]Upstream [6]Sync mode [7]Local path [8]Path status [9]Inherited ...
    if ($cells.Count -lt 10) { continue }
    if ($cells[1] -eq 'Project' -or $cells[1] -like '---*') { continue }
    $rows += [pscustomobject]@{
        Project   = $cells[1]
        SyncMode  = $cells[6]
        LocalPath = ($cells[7] -replace '^`+', '' -replace '`+$', '').Trim()
        Inherited = ($cells[9] -replace '^`+', '' -replace '`+$', '').Trim()
    }
}

if ($rows.Count -eq 0) {
    Write-Output "FAIL: registry 未解析出任何数据行（表格格式可能已变更，人工核对）"
    exit 2
}

$drift = 0
$results = @()
foreach ($row in $rows) {
    if ($row.SyncMode -match '未做过模板同步' -or $row.Inherited -match '—|未登记') {
        $results += [pscustomobject]@{ Project = $row.Project; Registry = '-'; Repo = '-'; Result = 'SKIP（无同步对账对象）' }
        continue
    }
    if ([string]::IsNullOrWhiteSpace($row.LocalPath) -or -not (Test-Path -LiteralPath $row.LocalPath)) {
        $drift++
        $results += [pscustomobject]@{ Project = $row.Project; Registry = $row.Inherited; Repo = '-'; Result = 'DRIFT（Local path 不可达）' }
        continue
    }
    $base = Join-Path $row.LocalPath 'TEMPLATE-BASE.md'
    if (-not (Test-Path -LiteralPath $base -PathType Leaf)) {
        $drift++
        $results += [pscustomobject]@{ Project = $row.Project; Registry = $row.Inherited; Repo = '-'; Result = 'DRIFT（TEMPLATE-BASE.md 缺失）' }
        continue
    }
    $synced = $null
    foreach ($l in (Get-Content -LiteralPath $base -Encoding UTF8)) {
        if ($l -match 'Current synced template version:\s*(v[0-9]+\.[0-9]+\.[0-9]+)') { $synced = $Matches[1]; break }
    }
    if (-not $synced) {
        $drift++
        $results += [pscustomobject]@{ Project = $row.Project; Registry = $row.Inherited; Repo = '-'; Result = 'DRIFT（TEMPLATE-BASE 无版本行）' }
        continue
    }
    if ($synced -eq $row.Inherited) {
        $results += [pscustomobject]@{ Project = $row.Project; Registry = $row.Inherited; Repo = $synced; Result = 'MATCH' }
    }
    else {
        $drift++
        $results += [pscustomobject]@{ Project = $row.Project; Registry = $row.Inherited; Repo = $synced; Result = 'DRIFT（registry 落后或超前，实查回写）' }
    }
}

$results | Format-Table -AutoSize | Out-String -Width 200 | Write-Output

if ($drift -gt 0) {
    Write-Output "registry 对账：发现 $drift 项漂移——以各仓 TEMPLATE-BASE 实查为准，回写登记（PR）或补同步；本工具只报不修（advisory）。"
    exit 1
}
Write-Output "registry 对账：全部一致（共 $($results.Count) 仓，含跳过项）。"
exit 0
