# TEMPLATE-UPGRADE: GitHub issue / PR 查询鲁棒性

> 来源：模板维护者（当前维护会话）
> 类型：模板优化提案
> 状态：已实施，随 v1.38.1 归档
> 建议版本：PATCH
> 关联事件：2026-07-07 维护扫描时，远端 open issue 统计被 PowerShell JSON / 过滤写法误判为 0
> 落地版本：v1.38.1

## 1. 背景与问题

模板维护者处理提案收件箱时，需要查询 GitHub open issue、open PR、单个 issue 状态，并把远端权威状态与本地 `_proposals/_remote-issues/` 镜像和 `_archive/proposals/` 归档交叉核对。

本次维护扫描中，AI 使用临时 PowerShell 命令查询 GitHub `/issues` API 时出现误判：远端实际仍有 `#131`、`#114`、`#107` 三个 open issue，但临时统计输出为 `open_issue_count=0`。随后用户指出异常，经逐项复核确认：

- `#107` 与 `#114` 仍为 open，但已由 Batch 4 / `v1.36.0` 吸收，应关闭。
- `#131` 为真实待处理 open proposal。
- 误判来自临时命令对 `ConvertFrom-Json` 顶层数组枚举和 issue / PR 过滤的处理不稳。

该问题不属于单个业务项目问题，而是模板维护流程中的通用远端状态核对风险。

## 2. 设计目标

1. **避免远端状态误判**：open issue / PR 统计必须稳定，不因 PowerShell 数组枚举或对象属性判断出错。
2. **交叉验证单项状态**：关闭 issue 或判断已处理前，必须同时核对列表状态与单个 issue 状态。
3. **统一维护查询入口**：减少维护者临时拼命令导致的差异和误判。
4. **保留平台差异说明**：PowerShell、`gh`、`curl`、GitHub REST API 的行为差异应在维护文档或脚本中显式说明。

## 3. 拟改范围

| 文件 | 拟改内容 | 是否必须 |
|---|---|---|
| `_proposals/README.md` | 在远端 issue 镜像刷新规则中补充“列表 + 单项状态交叉验证”和稳健过滤口径 | 建议 |
| `ai/prompts/maintainers/11-template-proposal-summary.md` | 提醒维护者查询 GitHub issue / PR 时避免临时过滤误判，关闭前复核单项状态 | 建议 |
| `ai/prompts/maintainers/17-submit-proposal.md` / `18-submit-feedback.md` | 如涉及回查 issue 状态，引用统一查询口径 | 可选 |
| `SOP.md` 或 `git-guide.md` | 在维护者远端操作注意事项中补充 GitHub issue 状态核对口径 | 可选 |
| `scripts/list-github-issues.ps1` | 新增只读辅助脚本，稳定输出 open issues / PRs / 指定 issue 状态 | 可选 |
| `scripts/check-template.ps1` / `.sh` | 若新增脚本，加入脚本存在性或关键输出提示的轻量自检 | 可选 |

## 4. 建议规则

### 4.1 远端 issue 状态核对

维护者判断远端 issue / PR 状态时，应至少执行以下核对：

1. 查询 open issues 列表。
2. 查询 open PR 列表。
3. 对准备关闭、归档或声明已处理的 issue，逐个查询单项状态。
4. 将远端状态与本地镜像、归档提案、`CHANGELOG.md`、相关 PR / commit 交叉核对。

若列表状态与单项状态冲突，以单项状态和 GitHub 页面为准，并停止继续自动处理，先向用户说明冲突。

### 4.2 PowerShell 过滤口径

GitHub `/issues` API 会同时返回 issue 和 PR。判断普通 issue 时，不应使用：

```powershell
Where-Object { -not $_.pull_request }
```

建议使用是否存在 `pull_request` 属性来区分：

```powershell
$items = @(Invoke-RestMethod -Headers $headers -Uri $issuesUrl)
$issues = @($items | Where-Object { $null -eq $_.PSObject.Properties['pull_request'] })
$prsFromIssuesApi = @($items | Where-Object { $null -ne $_.PSObject.Properties['pull_request'] })
```

若使用 `curl.exe | ConvertFrom-Json`，也必须确保顶层数组被正确枚举；建议统一封装在脚本中，而不是每次临时拼接命令。

### 4.3 关闭 issue 前的最小证据

关闭已处理 proposal issue 前，维护者应在关闭留言或本地记录中至少列出：

- 吸收它的 Batch / PR / 版本。
- 归档提案路径或 `CHANGELOG.md` 条目。
- 本地镜像是否已归档或仍需清理。

## 5. 非目标

- 不改变 GitHub issue 作为远端权威状态来源的定位。
- 不强制维护者必须使用 `gh` 或必须使用 `curl`。
- 不在本提案中直接关闭任何 issue；远端状态修改仍需用户确认或维护者明确操作。
- 不处理 `#131` 的 UI 原型策略内容；该 issue 应作为独立 Batch 候选。

## 6. 验证方式

1. 用真实仓库同时存在 issue / PR 的场景验证查询脚本或示例命令。
2. 验证 open issues、open PRs、单项 issue 状态输出一致。
3. 验证关闭前检查能识别“本地已归档但远端仍 open”的情况。
4. 运行 `scripts/check-template.ps1`；如涉及 Bash 脚本同步，运行 `scripts/check-template.sh`。

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| GIQR-C1 | 是否新增统一查询脚本 | 建议新增 PowerShell 脚本，Bash 可后续补 | 本次误判来自临时命令，脚本可减少重复踩坑 | 只更新 README / Prompt 示例 | 文档成本低，但维护者仍可能临时拼错命令；不阻塞先修文档 |
| GIQR-C2 | 是否把单项状态复核设为关闭 issue 前必做 | 建议设为必做 | 关闭 issue 是远端状态修改，误关或漏关都会影响提案治理 | 只作为建议 | 必做更稳，但步骤略多；不阻塞普通只读扫描 |
| GIQR-C3 | 是否与 `#131` 下一批一起处理 | 建议拆开，小 PATCH 先处理查询鲁棒性 | 该问题影响维护流程本身，且范围小 | 合入 UI 原型策略 Batch | 合并可减少 PR 数，但会混合流程修复与功能规则设计 |
