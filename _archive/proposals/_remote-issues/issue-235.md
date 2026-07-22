# GitHub Issue #235: TEMPLATE-UPGRADE：Token Hotspot 滚动汇总触发机制

> Source URL: https://github.com/emily8421/ai-project-template/issues/235
> State: OPEN
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-07-19T08:01:11Z
> Updated: 2026-07-19T08:01:11Z
> Mirrored at: 2026-07-20 15:21:06 +08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：Token Hotspot 滚动汇总触发机制

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流
> 类型：模板优化提案草稿
> 状态：派生项目内已起草，待提交模板仓 issue
> 关联：`ai/session-rules.md` §4.1、`ai-records/token-hotspots/`、Checkpoint Mode、长任务上下文治理、模板提案回流流程

## 1. 背景

模板已在 `ai/session-rules.md` §4.1 定义 Token 热点观察触发：当一次连续任务出现规则重读、长任务、大输出命令、CI / PR 状态或用户显式询问等情况时，AI 应提示并询问是否写入 `ai-records/token-hotspots/YYYY-MM-DD-<task-slug>.md`。

派生项目在 2026-07-12 至 2026-07-16 已连续产生 4 份 token hotspot 记录，覆盖 PR 收口、Demo 彩排、编码 / 文档回写、M11 验收与版本发布。复盘发现：单份记录都写入了热点来源、质量影响和优化建议，但没有任何自动机制提示“多份记录已足够形成 summary / 提案候选”。

## 2. 问题

### 2.1 只有单次记录触发，没有滚动汇总触发

现有规则要求“自动识别并询问是否写入单份 hotspot 记录”，但没有规定：

- 累计多少份记录后应提示汇总。
- 同类热点重复出现多少次后应提炼为规则 / 脚本 / prompt 改进候选。
- `ai-records/token-hotspots/SUMMARY.md` 或月度 summary 应采用什么结构。
- 单份记录如何标记“已纳入汇总 / 未纳入汇总”。

结果是观察材料持续沉淀，但不自然进入改进闭环。

### 2.2 “自动”边界容易误解

当前规则中的自动行为是“识别并询问”，不是静默写入。若模板不显式说明 rollup 也必须遵守写入确认，用户容易期待系统会自动从多份 hotspot 生成 summary，而 AI 实际不会主动创建文件。

### 2.3 可复用优化信号容易丢失

派生项目中的 4 份记录已反复暴露通用模式：

- 从快速续接升级为执行任务后的规则包重读成本。
- 长文档 / 长日志需要锚点读取和摘要化。
- sandbox 与本机运行边界会造成误判。
- Windows 下中文 API 验证不宜依赖 curl。
- seed 数据与运行时数据应在验证脚本中明确区分。

这些信号并非项目私有，适合转化为模板规则、命令 prompt 或脚本建议；缺少 rollup 会让它们停留在分散记录中。

## 3. 建议改动

### 3.1 在 `ai/session-rules.md` §4.1 增加 rollup 触发

建议补充以下规则语义：

- 当 `ai-records/token-hotspots/` 下出现 3 份以上未汇总记录时，AI 应在相关任务收尾前提示“建议形成 token hotspot summary”，并询问是否写入 `ai-records/token-hotspots/SUMMARY.md` 或 `YYYY-MM-summary.md`。
- 当最近 7 天内同一热点类型重复出现 2 次以上时，即使记录少于 3 份，也应提示是否提炼为 summary / 提案候选。
- 当用户询问“为什么没有 summary / 是否需要模板回流”时，应直接进入只读分析：先读取 hotspot 记录与 §4.1，再判断是否新增 summary 和 `_proposals/TEMPLATE-UPGRADE-*.md`。
- rollup 仍只允许自动识别和询问，不得静默写入；写入必须遵守派生项目的文件修改确认规则。

### 3.2 提供最小 summary 模板

建议在规则或命令 prompt 中给出最小结构：

```text
# Token Hotspot 汇总：<日期范围>

## 1. 汇总范围
## 2. 为什么触发 / 为什么此前未触发
## 3. 重复热点模式
## 4. 已形成的项目改进建议
## 5. 模板回流判断
## 6. 后续处理建议
```

边界要求：summary 是 AI 协作观察汇总，不替代 handoff、正式文档、验证记录或模板提案；不得包含 token、密钥、客户敏感数据、完整对话或无法提交到仓库的隐私事实。

### 3.3 为单份记录增加可选汇总状态

建议单份 hotspot 模板增加一个可选字段：

```text
- 汇总状态：未汇总 / 已纳入 SUMMARY.md / 已转提案 <path-or-url>
```

该字段不要求回填所有历史记录，但新记录可默认写入，方便后续识别 rollup 范围。

### 3.4 可选新增命令或并入维护者命令

可选方案：

- 新增 `ai/commands/token-hotspot-summary.md` 与对应 prompt，专门处理 hotspot rollup。
- 或扩展现有维护者 summary / proposal 命令，使其支持从 `ai-records/token-hotspots/` 读取观察记录并产出 summary + 提案候选。

建议优先采用规则级最小改动；只有在多个派生项目持续产生 hotspot 后，再新增独立命令。

## 4. 验证方式

- 在测试派生项目中准备 3 份去敏 hotspot 记录，确认 AI 会先提示是否汇总，而不是静默写入。
- 执行一次用户显式询问“为什么已有多份 hotspot 没有 summary”的场景，确认 AI 会读取 §4.1 与记录正文后给出原因判断。
- 确认 summary 不包含 token、密钥、账号密码、客户敏感数据、完整对话正文或隐私事实。
- 确认生成提案前完成去项目化检查，只保留模板可复用问题和建议。
- 模板仓运行 `scripts/check-template.*`，确保规则 / 命令文档格式通过。

## 5. 非目标

- 不自动计算真实 token 数或依赖 CLI 私有 trace / cache。
- 不要求 AI 静默创建 summary、提案或修改历史记录。
- 不把 hotspot summary 作为项目事实、验收证据或 handoff 替代品。
- 不强制所有派生项目启用 `ai-records/token-hotspots/`；它仍是可选观察材料。

## 6. 影响范围

- 所有使用 `ai/session-rules.md` §4.1 记录 token hotspot 的派生项目。
- 长任务、模板维护、文档审计、PR / CI 收尾、Demo 彩排和跨 sandbox 验证任务受益更明显。
- 模板文件可能涉及 `ai/session-rules.md`、相关命令 prompt、示例 hotspot / summary 模板和检查脚本文档。

## 7. 版本影响（供模板维护者判断）

- 若只在 `ai/session-rules.md` 增加 rollup 触发和 summary 模板，建议按 **PATCH**：补强既有观察机制，向后兼容。
- 若新增独立 `token-hotspot-summary` 命令 / prompt / 示例模板，建议按 **MINOR**：新增可见的维护能力，但仍向后兼容。
