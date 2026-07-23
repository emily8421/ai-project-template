# Token Hotspot 记录：AI Coding 上下文预算提案整理

> 日期：2026-07-23
> 任务类型：提案评估 / 模板维护候选整理（只读分析 + 单文件 proposal 转写）
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入提案分析与写入；读取完整规则包、提案、既有 hotspot summary 和维护文档）
> 汇总状态：未汇总

## 热点工作

- **续接与规则路由**：先按快速续接读取 Git 事实、`VERSION` 和 `.ai/session-handoff.md`；用户要求分析 proposal 后退出快速续接，读取 `ai/index.md`、`ai/rules-core.md`，按文档 / 提案审计路由读取 `ai/global-rules.md`、`ai/document-lifecycle-rules.md`、`ai/implementation-lifecycle-rules.md`、`ai/project-rules.md`。
- **目标提案评估**：读取 `_proposals/GLM-5.2_Token消耗分析与优化建议.md`、`_proposals/README.md`、`_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`，判断原文件更像账号使用观察，不适合原样作为模板优化提案。
- **既有证据对照**：读取 `ai-records/token-hotspots/SUMMARY.md` 和既有 hotspot 文件名分布，确认本仓已有 2026-07-10 ~ 2026-07-22 的阶段汇总，重复热点集中在规则门禁读取、PR / CI 闭环、跨仓同步、大目录列表和失败诊断往返。
- **写入前补读维护规则**：用户要求“按建议执行”后，补读 `ai/commands/README.md`、`MAINTAINERS.md`、`CONTRIBUTING.md`、`template-sync.json`、`ai/session-rules.md`，确认本次只做候选提案整理，不改正式规则、不改版本、不提交。
- **本地写入**：将 `_proposals/GLM-5.2_Token消耗分析与优化建议.md` 转写并重命名为 `_proposals/TEMPLATE-UPGRADE-ai-coding-context-budget.md`；核心处理是去模型化、去账号额度事实化，并拆出 `PR 闭环 checklist` 与 `check-template 本地可用性` 两个 patch 级候选。
- **验证**：运行 `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals/TEMPLATE-UPGRADE-ai-coding-context-budget.md`，结果通过。

## 热点判断

- **主要成本**：① 快速续接升级为提案审计后读取完整规则包；② proposal 评估需要同时读取目标草稿、收件箱规则、既有 token hotspot 提案和阶段 summary；③ 写入前又补读模板维护规则、贡献流程和同步清单，确认版本与写入边界。
- **必要读取**：规则路由、写入确认边界、提案收件箱规则和既有 hotspot summary 都直接影响“能不能改、改哪里、是否需要版本”的判断，属于高价值读取。
- **可压缩读取**：后续同类“只整理候选提案、不落正式规则”的任务，可复用一个短 checklist，避免每次全文读 `MAINTAINERS.md`、`CONTRIBUTING.md`、`template-sync.json` 后再人工归纳边界。
- **输出控制**：未展开全 `_archive/`，未查询远端 issue / PR，未读全部 hotspot 记录全文；只用 summary + 文件名分布 + 1 份既有记录格式做局部对照。
- **总量级**：medium（完整规则路由 + 多份治理文档 + 单文件写入；无远端操作、无 PR / CI 闭环、无全量自检）。

## 质量影响

- **正向**：把模型 / 账号用量观察从模板事实中剥离，避免把不稳定平台信息写入通用规则；将可复用部分沉淀为候选模板提案。
- **风险控制**：本次只新增 / 重命名 proposal 文件；不改 `VERSION`、`CHANGELOG.md`、正式规则、同步清单或脚本；其他未跟踪 hotspot 文件未触碰。
- **残留事项**：`PR 闭环 checklist` 和 `check-template 本地可用性` 仍是后续候选，尚未落地为正式模板改动。

## 优化建议

- **候选提案速查**：为“只整理 `_proposals/` 候选、Release impact=none、不改同步范围”的场景沉淀一个短 checklist，明确必读文件和可跳过文件。
- **PR 闭环 checklist**：继续优先评估 `TEMPLATE-UPGRADE-pr-closure-checklist.md`，因为本轮和既有 summary 都显示 PR / CI 闭环是高频重复读取热点。
- **check-template 本地可用性**：继续优先评估 `TEMPLATE-UPGRADE-check-template-local-usability.md`，把 Windows / PowerShell / Bash fallback 的失败诊断成本降下来。
- **模型信息边界**：模型额度、倍率、套餐、价格等不稳定信息只留在本地观察或个人 SOP，不进入模板同步规则。
