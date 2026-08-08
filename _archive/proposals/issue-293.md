# GitHub Issue #293: TEMPLATE-UPGRADE: PowerShell wrapper scripts normalize duplicate Path / PATH before Start-Process

> Source URL: https://github.com/emily8421/ai-project-template/issues/293
> State: CLOSED
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-07-29T15:34:28Z
> Updated: 2026-08-02T02:11:25Z
> Mirrored at: 2026-08-01T23:02:20+08:00
> Mirror status: remote issue closed as implemented; GitHub issue remains source of comments and closure state.

## Local Triage / Implementation Notes

> Local triage updated: 2026-08-02T02:11:25Z
> Remote issue state at triage: CLOSED

Implemented by PR #295 (squash merge `360ba54a`, v1.59.1):

- Scope: `Repair-ProcessPathEnvironment` added and called at startup in `scripts/check-template.ps1`, `scripts/sync-template.ps1`, `scripts/check-derived-sync.ps1`; drift-guard keyword assertions added to `scripts/check-template.sh` / `.ps1`; Windows `gh --jq` / `--template` word-splitting note added to `template-docs/remote-ci-sop-profile.md`.
- Duplicate `Path` / `PATH` process-env normalization before `Start-Process` is fully covered.
- Residual scope from the related duplicate #296 (`-WindowStyle Hidden` default + demo runbook Windows notes) is NOT covered here; tracked as v1.59.2 patch (A2 batch).
- Closure comment recorded on GitHub at 2026-08-02T02:11:25Z.

## Raw Issue Body

# TEMPLATE-UPGRADE: PowerShell wrapper scripts normalize duplicate Path / PATH before Start-Process

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：草案 · 待母模板维护者确认
> 目标仓库：母模板 `ai-project-template`
> 目标版本：母模板下一个 patch
> Release impact：patch（AI 建议；兼容性脚本修复，不改变默认同步语义）
> Release strategy：单独发布或并入下一批 Windows 兼容性修复

## 1. 背景与动机

在 Windows PowerShell 环境执行派生同步边界检查时，当前进程可能同时包含大小写不同的 `Path` 与 `PATH` 环境变量键。PowerShell 调用 `Start-Process` 构造子进程环境时会把这两个键视为冲突，导致脚本在实际检查前失败。

本问题已在一个派生同步任务中复现，失败片段为：

```text
Start-Process : Item has already been added. Key in dictionary: 'Path' Key being added: 'PATH'
```

本地已在 `scripts/check-derived-sync.ps1` 加入进程内 PATH 归一化并验证通过。但同类风险不只存在于该脚本：母模板的多个 PowerShell wrapper 都通过 `Start-Process` 拉起 Bash 或 Git，任一入口在相同环境下都可能提前失败。

## 2. 目标

- 在所有使用 `Start-Process` 的 PowerShell wrapper 脚本前置归一化进程环境中的 `Path` / `PATH` 重复键。
- 保留 Windows canonical `Path` 键，合并可用 PATH 值，删除重复大小写变体。
- 让失败从“PowerShell 环境键冲突”回到脚本原本要执行的同步 / 自检逻辑。
- 不改变 Bash 主路径、同步清单、保护文件策略或默认输出语义。

## 3. 非目标

- 不调整 `template-sync.json` 同步范围。
- 不改变派生项目版本治理、changelog ownership 或 `upstream/` 机制。
- 不把本问题包装成 Git Bash 安装问题；它发生在 PowerShell 启动子进程前。

## 4. 拟改（母模板侧）

建议在母模板中提炼一个小型 PowerShell helper，例如：

```powershell
function Repair-ProcessPathEnvironment {
  $vars = [Environment]::GetEnvironmentVariables("Process")
  $pathKeys = @()
  foreach ($key in $vars.Keys) {
    if ([string]::Equals([string]$key, "Path", [StringComparison]::OrdinalIgnoreCase)) {
      $pathKeys += [string]$key
    }
  }
  if ($pathKeys.Count -le 1) { return }

  $canonicalValue = [Environment]::GetEnvironmentVariable("Path", "Process")
  foreach ($key in $pathKeys) {
    if ([string]::IsNullOrEmpty($canonicalValue)) {
      $candidate = [Environment]::GetEnvironmentVariable($key, "Process")
      if (-not [string]::IsNullOrEmpty($candidate)) {
        $canonicalValue = $candidate
      }
    }
  }

  foreach ($key in $pathKeys) {
    if ($key -cne "Path") {
      [Environment]::SetEnvironmentVariable($key, $null, "Process")
    }
  }
  if (-not [string]::IsNullOrEmpty($canonicalValue)) {
    [Environment]::SetEnvironmentVariable("Path", $canonicalValue, "Process")
  }
}

Repair-ProcessPathEnvironment
```

候选落点：

- `scripts/check-derived-sync.ps1`
- `scripts/sync-template.ps1`
- `scripts/check-template.ps1`

如果母模板后续新增更多 PowerShell wrapper，也应复用同一 helper 或同等逻辑。

## 5. 影响面

- 影响范围：Windows PowerShell wrapper 的兼容性增强。
- 下游行为：只在进程内清理重复 PATH 键，不写入用户级或机器级环境变量。
- 风险：若两个键内容不同，保留 `Path` 值；`Path` 为空时才采用其他大小写变体的值。该策略符合 Windows canonical `Path` 约定。
- 版本影响：建议 patch。

## 6. 验收

- 在含重复 `Path` / `PATH` 的 PowerShell 进程中运行以下入口，不因 `Start-Process` 环境键冲突失败：
  - `powershell -ExecutionPolicy Bypass -File scripts\check-derived-sync.ps1 <sync-commit>`
  - `powershell -ExecutionPolicy Bypass -File scripts\sync-template.ps1 --summary`
  - `powershell -ExecutionPolicy Bypass -File scripts\check-template.ps1`
- `git diff --check` 通过。
- 母模板 `bash scripts/check-template.sh --summary` 或 CI 通过。
- 不改变 `sync-template.*` 的同步结果、保护文件清单或 changelog ownership 断言。

## 7. 衔接

- 本提案是跨领域 Windows 兼容性修复，建议回流母模板；不在 `agent-system-template` 中继续扩改 L1 同步脚本。
- 本仓本地修复与验证记录见 `sync-records/template-sync/2026-07-29-sync-template-v1.59.0.md`。
