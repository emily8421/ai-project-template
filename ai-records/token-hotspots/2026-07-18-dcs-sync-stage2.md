# Token Hotspot 记录：digital-cs-demo 下行同步 v1.54.2 阶段 2 执行（PR digital-cs-demo#35）

> 日期：2026-07-18
> 任务类型：派生项目下行同步执行（digital-cs-demo v1.30.4 → v1.54.2 阶段 2：sync commit + 边界验证 + push + PR）
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入同步写入任务，完整读取 `ai/index.md` 规则链 + 多个大输出命令：dry-run 258 行 / check-derived-sync ~250 行）

## 热点工作

- **规则读取**（快速续接升级到执行任务，按 `ai/index.md` 路由）：`ai/session-rules.md`（§3.1 快速续接 / §3.3 Checkpoint / §4.1 hotspot）、`ai/index.md`、`ai/rules-core.md`、`ai/implementation-lifecycle-rules.md`、`ai/project-rules.md`、`ai/commands/README.md`、`git-guide.md`（全文 §1-§8，定位 §5.2 旧项目首次同步 + §5.7 代理）、`ai/prompts/maintainers/12-sync-template.md`（完整 24 步 SOP + A13 判据矩阵）。
- **memory 复用**：`derived-project-digital-cs-demo`（阶段 1 评估上下文：分支 / bootstrap `68d16e7` / local proxy 7897 / dry-run EXIT 0），省去重新评估。
- **派生状态核查**：`git status / log / VERSION / TEMPLATE-BASE / proxy / sync 脚本` 一批只读，与 handoff 阶段 1 一致。
- **dry-run 重跑**：`sync-template.sh --dry-run --preserve-project-version` → 258 行 log（fetch 成功 + 119 Δ/= 文件清单 + Windows CRLF 警告 diff-stat）。
- **同步提交**：`--commit --preserve-project-version` → commit `8d0f1fc`（119 文件，含首次生成 TEMPLATE-BASE.md，VERSION 保留 v1.30.4）。
- **边界验证**：`check-derived-sync.ps1` → ~250 行（119 文件列两遍：同步提交清单 + 逐文件「同步清单内变更」确认），EXIT 0；非阻断提示版本机制未启用（= 阶段 3 工作）。
- **远程闭环**：`check-github-context.ps1` 预检（gh repo view 一次 TLS timeout，非阻断）→ `git push`（local proxy）→ `gh pr create --body-file`（HTTPS_PROXY）→ PR #35。
- **留痕**：模板 `.ai/session-handoff.md`（元数据刷新 + 阶段 3 续接）+ memory `derived-project-digital-cs-demo` + MEMORY 索引。

## 热点判断

- **主要成本**：规则链读取（git-guide 372 行 + 12-sync-template 131 行 + 4 个规则文件全文）+ 大输出命令（dry-run 258 行 + check-derived-sync ~250 行，CRLF 噪音占大头）。
- **dry-run 2 分钟工具超时（非脚本失败）**：首次 dry-run 命中工具 120s 默认超时——脚本本身成功（fetch 完成 + 文件清单完整），是 Windows 下 119 文件逐个 `LF→CRLF` 警告 + diff-stat 把输出撑长。诊断后改用 600s 超时 + log 重定向 + grep 过滤 CRLF 噪音，commit 一次成功。属 H-003（验证证据摘要）+ Checkpoint「失败即停但区分真假失败」的实战。
- **agent 分担未用**：同步是线性 SOP（评估已在阶段 1 完成），无跨项目取参考 / 大范围搜索需求，直接执行更准，未派 agent（与同日 LUMEN 版本机制启用派 agent 取 zhiyan 参考不同）。
- **总量级**：medium（单焦点任务，但规则链 + 大输出读取偏重；memory 复用阶段 1 评估省了一波）。

## 质量影响

- **H-003（验证证据摘要）生效**：dry-run / commit / check-derived-sync 输出全部重定向 log，回复只保留 EXIT 码 + 关键摘要 + grep（项目专属触及 / CRLF 噪音过滤），未把 258/250 行全文刷入对话。
- **Checkpoint 风险分级落地**：本地 `--commit`（已授权 + 可逆 + dry-run 已验范围）按已授权批次执行；push / PR 两个远程高风险动作单步确认（AskUserQuestion 门禁），符合 §3.3.2。
- **真假失败区分**：dry-run 工具超时未被当作脚本失败盲目重试，而是读部分日志定位（fetch 已成功）→ 改超时策略；体现 Checkpoint「失败即停 + 先诊断类别」。
- **大同步分阶段（延续阶段 1 好模式）**：阶段 2 只做 sync + PR，版本机制启用（project-rules 版本管理章节 + project-check.yml）显式留阶段 3 且前置「等 PR 合并」，避免同步提交混入项目事实改动，也避免单会话做完跨 24 版本大工程致上下文爆炸。
- **双版本保护验证**：`--preserve-project-version` 实测保留 VERSION v1.30.4 + 首次生成 TEMPLATE-BASE.md，check-derived-sync 识别双版本模式并跳过 README↔VERSION 模板版本一致性检查——机制按预期工作。

## 优化建议

- **Windows sync 命令输出极度冗长（可回流）**：`sync-template.sh` dry-run/commit 在 Windows 下对每个同步文件打印 `warning: LF will be replaced by CRLF` + diff-stat，119 文件 × 警告撑出数百行，首次命中工具 120s 默认超时。建议：① 脚本侧在 diff 阶段抑制 CRLF 警告（如临时 `git -c core.safecrlf=false` 或 stderr 过滤 `LF will be replaced`）；② 或在 `git-guide.md` §5.7 / `12-sync-template.md` 提示「Windows 下 dry-run/commit 输出冗长，建议重定向到 log + 用长超时（≥300s）+ grep 摘要」。可起草 `_proposals/TEMPLATE-UPGRADE-*.md`。
- **check-derived-sync 输出可精简（次要）**：119 文件目前列两遍（同步提交清单 + 逐文件「同步清单内变更」✓），成功时可只保留计数 + 尾部摘要，减少 ~120 行；失败/可疑时再展开。
- **dry-run 审查 checklist（与上一份 hotspot 建议呼应，仍未沉淀）**：跨版本同步 dry-run 固定查 ①项目专属触及 ②版本机制处理 ③变化规模。本次实操用「name-only + grep 禁止路径」做了 ①②，可正式写入 `12-sync-template.md` 或 git-guide §5。
- **大同步分阶段 + 留痕续接（好模式，保持）**：本次阶段 2 是阶段 1 范例的延续，memory + handoff 续接顺畅，新会话直接进入执行未重做评估。

## 关联

- PR digital-cs-demo#35（sync v1.54.2，MERGEABLE / CLEAN，无 CI 因项目无 workflow）：https://github.com/emily8421/digital-cs-demo/pull/35
- 阶段 1 评估 hotspot（同日）：`2026-07-18-template-sync-proxy-and-dcs-assessment.md`
- 同日同会话链：`2026-07-18-lumen-version-mechanism-enable.md`（LUMEN 版本机制启用，可作阶段 3 版本机制启用参考）
- memory `derived-project-digital-cs-demo`；机制 `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`（H-003）
- 权威流程：`git-guide.md` §5.2 / §5.7，`ai/prompts/maintainers/12-sync-template.md`
