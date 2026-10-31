# GitHub Issue #490: TEMPLATE-UPGRADE：同步类 SOP 的 PowerShell 调用建议「优先无 -ExecutionPolicy Bypass，被拦再降级」

> Source URL: https://github.com/emily8421/ai-project-template/issues/490
> State: OPEN
> Labels: proposal,from:flowkit-derived,
> Author: emily8421
> Created: 2026-10-30T03:36:40Z
> Updated: 2026-10-30T03:36:40Z
> Mirrored at: 2026-10-30T15:26:16Z
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：flowkit-derived（emily8421/flowkit-derived）派生项目回流

# TEMPLATE-UPGRADE：同步类 SOP 的 PowerShell 调用建议「优先无 `-ExecutionPolicy Bypass`，被拦再降级」

## 1. 动机

派生项目按 `ai/prompts/maintainers/12-sync-template.md` / `git-guide.md` §5 的 SOP 执行同步时，给定的命令形如：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run
```

实测发现两个问题：

1. **在 AI CLI 会话中易被权限管控直接拦截**。Claude Code 的权限分类器将 `-ExecutionPolicy Bypass` 判定为「关闭脚本执行策略校验的安全削弱操作」，在用户未点名同意时拒绝执行；且当该命令与建分支等前置动作串联时，整条命令被拦，只读前置步骤也被连带重做。
2. **该开关在多数执行场景下非必需**。同步 / 检查脚本（`sync-template.ps1`、`check-derived-sync.ps1`、`collect-env.ps1` 等）经 `git clone` 落地，不带 Mark-of-the-Web；在 `CurrentUser = RemoteSigned` 的机器上，`powershell -NoProfile -File scripts/xxx.ps1 ...` 无 bypass 即可正常运行。派生项目 2026-10-30 同步（v1.75.6）全流程（dry-run / commit / check-derived-sync）均以无 bypass 方式执行成功，EXIT 全 0。

即：SOP 硬编码 `-ExecutionPolicy Bypass` 在「人手开 PowerShell」时代是省事写法，在「AI CLI 代跑 + 权限管控」环境下反而成为摩擦点甚至阻断点。

## 2. 拟改

文档口径调整（不改任何脚本、不改 workflow、不新增自检断言）：

1. `ai/prompts/maintainers/12-sync-template.md`：步骤 8 / 9 / 11 等 PowerShell 调用示例前补一句总则——「优先 `powershell -NoProfile -File <script> ...`（无 bypass）运行；仅当脚本报『此系统上禁止运行脚本』类加载错误时，再改用 `-ExecutionPolicy Bypass` 重试」。具体示例命令可保留现状或同步改为无 bypass 形式（建议改为无 bypass，正文说明降级条件）。
2. `git-guide.md` §5.3 / §5.4：同口径调整示例命令，或在节首补同款说明一句。
3. `ai/commands/sync-methodology.md`、`15-post-sync-cleanup.md`、`collect-env` 相关命令 / Prompt 中同模式 `powershell -ExecutionPolicy Bypass -File ...` 示例：随批量替换或统一指向上述总则。
4. 附注（可选）：建议 SOP 提醒 AI 执行者不要把「建分支等前置 Git 操作」与「脚本运行」串成单条命令，避免被权限管控整条拦截时连带重做只读步骤。

## 3. 目标版本影响

- 建议定级 **PATCH**：纯文档指引与示例命令形式调整，无行为逻辑变化、无同步清单变化、无脚本改动、无自检断言增减；与 #479（公文腔词语约束 → v1.75.4 PATCH）同级先例一致。
- 对存量派生项目零迁移义务；对未来同步 / 检查操作生效。

## 4. 影响面

- 影响文件：`ai/prompts/maintainers/12-sync-template.md`、`git-guide.md`、`ai/commands/sync-methodology.md`、`ai/prompts/maintainers/15-post-sync-cleanup.md`、`ai/commands/collect-env.md` / `ai/prompts/setup/13-collect-env.md` 中含 `-ExecutionPolicy Bypass` 的示例（以全仓 grep 为准）。
- 不影响：`scripts/*.ps1` 脚本本体、`project-check.yml` / `check-derived-sync.*` 行为、`template-sync.json`、CI 断言。
- 受益场景：所有在 AI CLI（Claude Code / Codex / Cursor 等）权限管控下执行同步的 Windows 派生项目；人手执行场景不受影响（无 bypass 在 RemoteSigned 下本就能跑）。

## 1.1 与既有规则的关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `git-guide.md` §5.1「Windows 说明」（Git Bash / MSYS 启动错误 → PowerShell fallback） | 对象不同 / 互补不重复 | 该段管「脚本内部探测到宿主问题后的 fallback 链路与编码解码」；本提案管「调用方执行策略开关的选择顺序」，层级不同 |
| `template-docs/env-setup.md` §8.1 canonical 调用方式 | 互补不重复 | 该节管「带空格路径 / 带变量时的调用形态」（直接执行 .sh / env 变量 / wrapper）；本提案管「是否带 `-ExecutionPolicy Bypass`」，可互为相邻条目 |
| `git-guide.md` §5.7 网络 / 代理配置 | 对象不同 | 该节管网络受限；本提案管权限管控拦截，失败域不同 |
| v1.75.4 #478 校验时点指引 | 互补不重复 | 该指引管「何时跑 check-derived-sync」；本提案管「跑检查命令的 PowerShell 开关形式」 |

## 5. 验证方式

- 已验证（派生项目实测）：`CurrentUser = RemoteSigned` 且脚本无 MotW 时，`powershell -NoProfile -File scripts/sync-template.ps1 --dry-run`、`--commit`、`scripts/check-derived-sync.ps1` 均 EXIT=0（flowkit-derived 2026-10-30 v1.75.6 同步运行记录）。
- 改后验证：全仓 grep `-ExecutionPolicy Bypass`，确认保留处均带「先无 bypass、被拦再 bypass」的降级说明；`scripts/check-template.*` 全量自检通过（无新断言，不应有影响）。

## 6. 备选方案（已考虑并放弃）

- 「保留 bypass 示例 + 仅加注释」：被 AI CLI 权限拦截的问题依旧存在（拦截发生在命令解析层，注释不改变命令形态），故改为「无 bypass 优先、降级有据」的顺序调整。
