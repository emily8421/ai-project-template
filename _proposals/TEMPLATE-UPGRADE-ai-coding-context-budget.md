# TEMPLATE-UPGRADE: AI Coding 上下文预算与高频闭环降耗

> 来源：模板维护者（由本仓 AI Coding 用量观察草稿转写）
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：none（AI 建议，待维护者确认；本提案只整理候选方向，不直接改变模板行为）
> Release strategy：延后候选池；优先拆出 patch 级小优化

## 1. 背景

本提案来自一份 GLM-5.2 使用量观察草稿。原草稿记录了某次 AI Coding 使用接近账号周额度上限，并推测主要消耗来自项目上下文读取、Agent 多轮推理、长会话开发和模型分工不清。

这些观察能说明“上下文成本值得治理”，但不适合作为通用模板事实直接落地：

- 模型额度、倍率和套餐限制属于平台 / 账号事实，会随产品策略变化，不应写进模板规则。
- 单账号用量不能代表所有派生项目，也不能直接推导模板必须新增强制目录或新流程。
- “建立 PROJECT_CONTEXT / ARCHITECTURE / DEVELOPMENT_GUIDE / API_DOCUMENT”等建议与本模板现有 `docs/00-09`、`.ai/session-handoff.md`、`ai-records/token-hotspots/` 可能重复，容易制造陈旧副本。

因此，本提案将原草稿转写为去模型化的模板候选：只讨论 AI Coding 上下文预算、读取路径压缩和高频维护闭环降耗。

## 2. 已有证据

本仓已经有 `ai-records/token-hotspots/SUMMARY.md` 覆盖 2026-07-10 ~ 2026-07-22 的阶段汇总。该 summary 指出的主要热点包括：

- 规则门禁反复全文读取。
- PR / CI 闭环中的远端查询和状态复核。
- 归档 / 同步目录的大列表读取。
- 跨仓同步导致多仓库上下文膨胀。
- 验证失败后的环境诊断往返。
- 提案 triage 时需要对照“描述是否已被现实吸收”。

summary 同时明确：写入确认、任务路由、远端单步确认、issue 镜像门禁等质量护栏必须保留，不能为了省 token 直接削弱。

## 3. 目标

1. 降低 AI Coding 中重复、低价值、可压缩的上下文读取成本。
2. 保留本模板的核心质量门禁和可审计性。
3. 把“省上下文”落实为小的、可验证的维护体验改进，而不是新增一套并行事实文档。
4. 为后续 patch 级提案拆分提供候选池。

## 4. 非目标

- 不记录或固化任何具体模型的套餐额度、倍率、周额度、价格或账号用量。
- 不新增强制同步目录。
- 不用 `PROJECT_CONTEXT.md` 等并行文件替代 `docs/00-09`、`ai/index.md`、`.ai/session-handoff.md` 或 hotspot 记录机制。
- 不削弱写入前确认、任务路由、远端操作单步确认、issue 镜像硬门禁。
- 不在本提案中直接修改正式规则、脚本、同步清单、`VERSION` 或 `CHANGELOG.md`。

## 5. 候选优化

### 5.1 PR 闭环 checklist（优先）

问题：

- 模板维护和 PR / CI 收尾中，经常重复读取 CONTRIBUTING、git-guide、project-rules、commands README、proposal README 等长文件。
- 多数 PR 闭环只需要固定的少量步骤：状态复核、检查项、merge 判断、分支清理、本地同步、归档或 handoff。

候选做法：

- 新增或更新一个维护者速查入口，沉淀 PR 闭环 checklist。
- checklist 只引用权威文件，不复制大段规则正文。
- 保留高风险动作单步确认：push、创建 / 合并 PR、关闭 issue、删除分支、发布。

候选落点：

- `template-docs/` 下新增维护者速查页；或
- `ai/commands/README.md` / 相关命令文件中增加短入口；或
- `MAINTAINERS.md` 增加极短索引，详细步骤仍指向现有权威规则。

Release impact 初判：`patch`。

### 5.2 check-template 本地可用性优化（优先）

问题：

- Windows 本地维护时，`check-template` 失败诊断、Bash / WSL / Git Bash 路径差异、PowerShell stderr 行为会放大上下文成本。
- 失败后 AI 往往需要多轮读取脚本、日志和环境信息。

候选做法：

- 优先提升失败信息的可定位性：断言名、实际值、期望值、建议下一步。
- 对 Windows 慢路径或不可用路径给出明确 fallback 语义，避免把环境问题误判为模板缺陷。
- 继续保持：PowerShell fallback 不能替代 Bash / CI 完整自检。

候选落点：

- `scripts/check-template.ps1`
- `scripts/check-template.sh`
- `template-docs/smoke-test.md` 或 `MAINTAINERS.md` 的自检说明

Release impact 初判：`patch`。

### 5.3 长任务拆会话与范围限定（观察）

问题：

- 跨仓同步、多 issue triage、PR 闭环和归档混在同一会话时，上下文快速膨胀。

候选做法：

- 在相关命令或维护者文档中提示：跨仓批量同步、多 issue triage、PR 闭环最好拆成独立会话或独立 checkpoint。
- 强化“先限定目录 / 关键词，再搜索；搜索批次后回锚点汇报”的现有规则，而不是新增复杂流程。

Release impact 初判：`patch` 或 `none`，取决于是否改正式同步规则。

### 5.4 模型分工建议（不落模板规则）

原草稿建议用不同模型处理架构设计、复杂编码、简单修改和文档整理。该方向对个人使用可能有价值，但不建议写入本模板通用规则：

- 模型名称、能力、价格和额度变化快。
- 模板应约束任务质量和证据链，不应绑定具体供应商或套餐。
- 可在项目或个人 SOP 中按需记录，不作为下行同步方法论。

## 6. 分阶段建议

建议不做一轮大改，拆成小的 patch 候选：

1. 先处理 `PR 闭环 checklist`：低风险，直接针对高频重复读取。
2. 再处理 `check-template 本地可用性`：已有 Windows 维护痛点证据，能降低失败诊断成本。
3. 继续观察长任务拆会话提示是否已经被现有 Checkpoint Mode 覆盖；若覆盖足够，不新增规则。
4. 模型分工只保留为个人使用建议，不进入模板同步清单。

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 是否为 PR 闭环 checklist 单独建提案 | 建议单独建 `TEMPLATE-UPGRADE-pr-closure-checklist.md` | hotspot summary 已多次指出 PR / CI 闭环重复读取 | 直接在本提案中继续追加；暂不处理 | 单独提案更清晰，不阻塞本提案整理 |
| C-002 | check-template 本地可用性是否进入下一批 | 建议单独建 `TEMPLATE-UPGRADE-check-template-local-usability.md` | Windows / PowerShell / Bash fallback 问题具备去项目化价值 | 只记录在 hotspot summary；等再次触发 | 可降低维护诊断成本，不阻塞当前模板使用 |
| C-003 | 是否新增 `PROJECT_CONTEXT.md` 等上下文文件 | 不建议新增 | 与 `docs/00-09`、handoff、hotspot 机制重复，易漂移 | 新增可选模板文件 | 新增文件会扩大同步表面积，暂不建议 |
| C-004 | 是否把具体模型额度写入模板规则 | 不建议 | 平台 / 账号事实不稳定，且不具备模板通用性 | 写入个人 SOP 或本地观察记录 | 不阻塞任何模板优化 |

## 8. 验收标准

本提案整理阶段：

- 已去除对具体模型额度的模板化依赖。
- 已说明原草稿为何不能原样落地。
- 已将优化方向映射到本仓 hotspot summary 的可审计证据。
- 已拆出 patch 级候选，而非建议一次大改。
- 未修改正式规则、同步清单、版本文件或脚本。

后续落地阶段：

- 每个候选优化单独说明拟改文件、风险、验证命令和版本影响。
- 不削弱现有质量门禁。
- 修改后至少运行 `git diff --check`、相关 Markdown clean 检查和模板自检。
