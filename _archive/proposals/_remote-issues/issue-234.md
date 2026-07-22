# GitHub Issue #234: TEMPLATE-UPGRADE-token-hotspot-summary-trigger

> Source URL: https://github.com/emily8421/ai-project-template/issues/234
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-07-19T07:59:13Z
> Updated: 2026-07-19T07:59:13Z
> Mirrored at: 2026-07-20 15:21:06 +08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE-token-hotspot-summary-trigger

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流。
> 去项目化说明：本文提炼自派生项目在多轮 AI 协作中累计 token hotspot 记录后，缺少阶段性汇总触发的问题；不包含客户资料、私有路径、业务敏感信息或不可公开内容。

## 1. 背景与问题

模板已具备 token hotspot 的最小自动提醒：长任务收尾时，AI 可识别上下文热点并询问是否写入单条 `ai-records/token-hotspots/YYYY-MM-DD-<task-slug>.md` 记录。

派生项目实践中，该机制能收集单条记录，但累计到 3–5 份后没有自然触发阶段性 summary，导致：

- 重复热点分散在多份记录里，难以看出跨任务共性；
- “哪些热点应保留、哪些应压缩、哪些应回流模板”缺少固定判断点；
- 已有发布记录里的“3–5 份记录后评估”不属于任务路由必读规则，普通协作不会稳定读到；
- 自检脚本只校验 hotspot 入口存在，不校验累计 summary 触发或 summary schema。

## 2. 拟改目标

补齐 token hotspot 的第二阶段闭环：从“单条记录收集”升级为“达到样本阈值后主动提示汇总”，但保持可选、去敏和写入确认边界。

## 3. 建议新增规则

### 3.1 累计 summary 触发

建议在 `ai/session-rules.md` 的 Token 热点观察章节增加：

- 若 `ai-records/token-hotspots/` 下已有 3 份及以上未被 summary 覆盖的记录，AI 在相关任务收尾前应提示“已有多份 token hotspot 记录，建议生成 / 更新阶段性 summary”。
- 若已有 `ai-records/token-hotspots/SUMMARY.md`，且上次 summary 后又新增 3 份及以上记录，AI 应提示更新 summary。
- 若用户显式询问 token 消耗、hotspot 机制、为什么没有 summary，或要求“分析 hotspots / 形成 summary”，AI 可直接按用户授权生成 / 更新 summary。
- 保持现有写入边界：不得静默创建或修改文件；首次创建目录或写入 summary 前仍需说明目标路径、内容类别和隐私过滤口径。

### 3.2 Summary 建议结构

建议提供 `ai-records/token-hotspots/SUMMARY.md` 的最小结构：

1. 样本范围：列出记录日期、任务类型和主要热点。
2. 重复热点：按规则读取、文档读取、代码探索、验证日志、环境诊断等分类归纳。
3. 质量收益与成本：区分必须保留、应压缩、应沉淀、应拆会话。
4. 机制缺口：说明为什么已有记录没有自动形成 summary。
5. 建议动作：分本项目动作、模板候选动作、非目标。
6. 回流判断：是否需要形成模板提案，以及去项目化边界。

### 3.3 自检防回归

建议 `scripts/check-template.sh` 与 PowerShell fallback 增加轻量断言：

- `ai/session-rules.md` 包含“累计 summary 触发”或等价关键词；
- `ai/session-rules.md` 包含 `ai-records/token-hotspots/SUMMARY.md`；
- 若提供 summary 模板文件或 example，则检查其存在于 `template-sync.json` 中。

自检不应扫描派生项目实际 `ai-records/` 目录，也不应要求每个项目必须创建 hotspot 记录。

## 4. 建议修改位置

1. `ai/session-rules.md`：补充累计 summary 触发、写入边界和最小 summary 结构。
2. `scripts/check-template.sh` / `scripts/check-template.ps1`：补充规则文本断言，确保 Bash 与 PowerShell fallback 一致。
3. 可选：新增 `template-docs/token-hotspot-summary.example.md`，作为 summary 模板；若新增同步文件，需更新 `template-sync.json`。

## 5. 验收标准

- AI 在发现 3 份及以上未汇总 hotspot 记录时，会主动提示生成 / 更新 summary。
- 用户显式要求“分析 hotspots / 形成 summary”时，AI 能直接产出阶段性 summary。
- Summary 不替代正式项目事实文档，不写入隐私或完整对话正文。
- 自检能同时覆盖 Bash 与 PowerShell fallback 的 token-hotspot summary 规则断言。

## 5.1 验证方式

- 本地规则自检：运行 `bash scripts/check-template.sh` 或 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`，确认新增断言通过。
- Markdown 清洁检查：运行 `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals ai-records`。
- 行为抽样：在测试项目中准备 3 份 mock hotspot 记录，确认 AI 会提示生成 / 更新 `ai-records/token-hotspots/SUMMARY.md`，且不会静默写入。

## 6. 影响面

- 影响范围：所有使用 token hotspot 观察记录的派生项目。
- 风险：低；新增的是可选提醒和文档结构，不改变默认写入确认边界。
- 下行同步：派生项目获得更明确的累计观察闭环，减少热点记录“只收集、不分析”的漂移。
- 不适用场景：没有启用 `ai-records/token-hotspots/` 的项目不受影响。

## 7. 版本影响建议

建议作为 PATCH 落地：规则提示和自检断言增强，默认行为仍是可选提醒 + 写入前确认。

若维护者选择新增命令入口、summary 模板同步文件或更强自动化脚本，再评估是否升为 MINOR。

## 8. 待维护者确认项

1. 累计阈值使用 3 份、5 份，还是“3 份首次 summary，之后每新增 3 份更新”。
2. Summary 固定使用 `ai-records/token-hotspots/SUMMARY.md`，还是使用 `YYYY-MM-DD-summary.md` 追加归档。
3. 是否新增 `template-docs/token-hotspot-summary.example.md`，以及是否加入 `template-sync.json`。
4. PowerShell fallback 是否应补齐与 Bash 自检一致的 token-hotspot 断言。

## 9. 非目标

- 不自动统计真实 token 数量。
- 不记录或摘要完整对话正文。
- 不把 `ai-records/token-hotspots/` 升级为正式项目事实文档。
- 不绕过用户写入确认边界。
