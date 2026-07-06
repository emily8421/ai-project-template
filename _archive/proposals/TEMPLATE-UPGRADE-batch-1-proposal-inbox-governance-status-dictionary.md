# TEMPLATE-UPGRADE: 提案收件箱本地镜像、分批治理与横切状态词典

> 来源：GitHub issue #111、#117；本地镜像：`_proposals/_remote-issues/issue-111.md`、`_proposals/_remote-issues/issue-117.md`
> 参考：本地提案分支 `proposal/docs-system-generation-guidance-main` 中的 `TEMPLATE-UPGRADE-docs-system-generation-guidance.md`
> 类型：模板优化提案
> 状态：已完成维护者分析，待实施
> 计划批次：Batch 1
> 建议版本：MINOR
> 关联 issue：#111、#117

## 1. 背景与问题

当前模板已经支持本地 `_proposals/` 提案收件箱，也支持派生项目通过 GitHub issue 回流 `proposal` / `feedback`。但在实际维护过程中，远端 issue 正文每次都要重新读取，容易造成重复联网、上下文膨胀、批次分析漂移，也不利于跨会话续接。

同时，文档体系相关提案 #105-#117 覆盖需求、架构、契约、详细设计、计划验证和横切状态等多个层面。如果直接从 issue 队列逐个实施，容易出现以下问题：

1. 一个大提案覆盖全部文档链，范围过大，难以评审。
2. 多个提案重复定义 Mock、降级、候选、已验证、已启用等状态词。
3. 项目事实问题、模板规范缺口、审计流程问题和回流治理问题混在一起。
4. 长任务跨会话时，缺少稳定的本地输入和 Batch 计划，容易重复读取 issue 或遗漏依赖。
5. “生成整个文档体系”这类总控场景缺少统一的阶段路线、模式选择和待确认事项总览机制。

因此，Batch 1 应先建立治理底座：远端 issue 本地镜像机制、分批提案治理流程、横切状态词典、待确认事项总览原则和文档体系生成总控的最低约束。后续 Batch 2-6 再分别落地具体文档规范。

## 2. 输入来源

| 来源 | 本地路径 / 链接 | 本提案处理方式 |
|---|---|---|
| GitHub issue #111 | `_proposals/_remote-issues/issue-111.md` | 吸收“分批审计 / 分批提案工作流” |
| GitHub issue #117 | `_proposals/_remote-issues/issue-117.md` | 吸收“横切状态词典 / 状态传播” |
| 本地大提案 | `proposal/docs-system-generation-guidance-main:_proposals/TEMPLATE-UPGRADE-docs-system-generation-guidance.md` | 吸收治理层内容；专题讨论场景延后 |
| 当前镜像机制试行 | `_proposals/_remote-issues/README.md` | 制度化为 C1 处理规则 |
| Batch 0 proposal | `_proposals/TEMPLATE-UPGRADE-batch-0-a13-sync-closure.md` | 作为“镜像 → proposal → 实施”的先例 |

## 3. 设计目标

1. **远端 issue 本地化**：处理提案收件箱时，先将远端 issue 正文镜像到 `_proposals/_remote-issues/`，后续分析优先读取本地镜像。
2. **分批治理**：把文档体系提案拆成可评审的 Batch，遵循“一批一范围、报告先行、事实与模板分离、去重可审计、可续接”。
3. **横切状态统一**：定义 Mock、降级、默认关闭、候选、已验证、已启用、目标设计、草案、禁止等状态，供后续 00-09 / design / audit / evaluation 引用。
4. **状态传播**：状态变化时检查 `03/project-rules/04-09/design/README` 等下游影响，避免只改单点文档。
5. **待确认事项总览**：先定义最小字段和门禁语义，后续是否新增独立 command / prompt 再评估。
6. **文档体系生成总控**：用户说“生成整个文档体系”时，AI 先说明阶段路线和生成模式，不直接写文件。
7. **为 Batch 2-6 降低重复**：后续具体文档规范只引用本批状态词典和治理规则，不重复定义。

## 4. 提案收件箱本地镜像机制

### 4.1 触发条件

当维护者执行以下场景时启用：

- “处理提案”
- “汇总模板优化”
- “处理 issue 提案”
- `/run template-proposal-summary`
- C1「处理提案收件箱」

### 4.2 推荐流程

1. 先读取本地 `_proposals/TEMPLATE-UPGRADE-*.md` 和 `_proposals/_remote-issues/*.md`。
2. 查询远端 open issue：
   - `proposal` 标签。
   - `feedback` 标签。
   - 标题匹配 `TEMPLATE-UPGRADE:` 的 open issue。
3. 若远端 issue 不存在本地镜像，或远端 `updated_at` 晚于镜像中的 `Updated`，刷新本地镜像。
4. 后续分析、去重、冲突判断和 Batch 计划优先读取本地镜像。
5. 远端 GitHub 仍是评论、状态和关闭的权威来源；关闭 issue 前必须重新核对远端状态。

### 4.3 命名与元信息

镜像目录：

```text
_proposals/_remote-issues/
```

文件命名：

```text
issue-<number>.md
```

镜像文件至少包含：

```markdown
# GitHub Issue #<number>: <title>

> Source URL:
> State:
> Labels:
> Author:
> Created:
> Updated:
> Mirrored at:
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body
```

### 4.4 归档规则

- 对应 issue 处理完成并关闭后，可将镜像文件与正式 proposal 一起移到 `_archive/proposals/`。
- 未处理或延后处理的 issue 镜像继续保留在 `_proposals/_remote-issues/`。
- 若本地镜像已过期，应刷新后再分析，不得把旧镜像当作最新远端事实。

## 5. 分批治理工作流

### 5.1 Batch 划分原则

| 原则 | 说明 |
|---|---|
| 一批一范围 | 每个 Batch 聚焦一个文档链段或横切主题 |
| 报告 / 镜像先行 | 先有本地稳定输入，再做分析与 proposal |
| 事实与模板分离 | 项目事实问题不直接写入模板规则 |
| 去重可审计 | 每批检查 `_proposals/`、`_archive/proposals/`、远端 issue 镜像 |
| 可续接 | Batch 计划、已完成、待确认项写入 `.ai/session-handoff.md` |
| 先 proposal 后实施 | 每批先形成 proposal，经确认后再修改模板 |

### 5.2 建议剩余 Batch

| Batch | 关联 issue | 范围 |
|---|---|---|
| Batch 2 | #105、#112 | 00-03 需求链规范 |
| Batch 3 | #106、#113 | 04-05 架构与技术方案规范 |
| Batch 4 | #107、#114 | 06-07 DB / API 契约规范 |
| Batch 5 | #110、#116 | `docs/design/*` 通用详细设计规范 |
| Batch 6 | #108、#109、#115 | 08-09 开发计划与验证证据规范 |

Batch 1 只提供治理底座，不直接实现上述具体 doc-standard。

## 6. 横切状态词典

建议定义最小统一状态集，后续文档规范按需引用，不重复发明术语。

| 状态 | 含义 | 可用于 | 禁止误写 |
|---|---|---|---|
| `已启用` | 当前 Phase 默认运行路径实际使用 | 已实现功能、已上线能力 | 未验证或未授权能力不得写已启用 |
| `已验证` | 在指定范围内验证通过 | 技术验证、资源验证、契约验证 | 不等同于生产可用或默认启用 |
| `Mock` | 仅模拟数据、payload、接口或状态流 | Demo、测试、降级演示 | 不得写成真实业务系统接入 |
| `降级` | 替代真实依赖的低成本路径 | 本机 Demo、资源不足、外部服务关闭 | 不得写成目标能力已完成 |
| `默认关闭` | 有设计或代码预留，但当前不开启 | LLM、真实通知、外部 API、付费服务 | 不得在当前 Sprint 默认启用 |
| `候选` | 方向性方案，尚未验证 | 技术路线、未来能力 | 不得进入实现计划，除非先做 Spike / PoC |
| `目标设计` | 未来结构或产品目标 | DB 目标表、API 未来版本、产品愿景 | 不得写成当前实现 |
| `草案` | 契约或方案未冻结 | 早期 API / DB / 设计文档 | 不得对外承诺稳定兼容 |
| `禁止` | 当前阶段不得接入或实现 | 真实数据、真实外部系统、未经授权服务 | 不得通过测试或演示绕过 |

## 7. 横切状态检查清单

### 7.1 Mock / 真实边界

触发条件：文档中出现订单、项目、通知、CRM、ERP、OA、工单、飞书、客户数据、外部 API、LLM 自动答复等真实业务或外部系统信号。

必查：

- 是否明确 `Mock`、`默认关闭`、`候选`、`已验证` 或 `已启用`。
- 是否禁止真实 token、真实组织数据、真实客户隐私进入 Demo。
- API / DB / design / verification 中是否保持同一口径。
- 是否有失败降级和“不编造”兜底。

### 7.2 降级路径

触发条件：Docker、数据库、向量检索、Embedding、LLM、外部通知、部署环境不可用或非当前阶段前置。

必查：

- 降级方案是否写清触发条件。
- 降级是否有验证记录。
- 降级是否改变 API / 用户承诺。
- 是否明确降级不等于目标能力已完成。

### 7.3 权限、安全与隐私

触发条件：接口对真实用户开放、员工控制台、外部服务、真实数据、试点部署、生产日志。

必查：

- 权限边界是否由后端接口和服务层执行，而非仅靠前端隐藏。
- 是否有敏感字段、日志脱敏、token / secret 管理和审计说明。
- 是否有角色 × 动作矩阵或明确豁免理由。
- 是否记录真实数据进入系统的合规前置条件。

## 8. 待确认事项总览机制

Batch 1 只定义机制，不强制新增独立命令。

建议当文档体系生成、评估、审计或 Batch 提案分析发现未决项时，使用统一字段：

| 字段 | 说明 |
|---|---|
| `ID` | 如 `OPEN-001` |
| `提出时间` | 首次发现或提出日期 |
| `来源文档 / 章节` | issue、文档、报告或 Prompt 来源 |
| `待确认事项` | 需要人工确认的问题 |
| `AI 建议` | 推荐处理方式 |
| `建议依据` | 来源材料、规则、技术事实或约束 |
| `备选方案` | 可选替代路径 |
| `最晚确认节点` | 如“生成 05 前”“进入 Sprint-1 前”“Phase 升级前” |
| `阻塞关系` | 阻塞 / 不阻塞 / 条件阻塞，以及影响范围 |
| `状态` | 待确认 / 已确认 / 延后 / 关闭 / 废弃 |
| `关闭时间 / 关闭依据` | 人工确认、文档修订、PR 或评估报告链接 |

建议后续在 Batch 2-6 中决定是否落盘为 `docs/research/YYYY-MM-DD-docs-open-items.md` 或新增 `docs-open-items` command。

## 9. 文档体系生成总控最低规则

当用户说“生成整个文档体系”时，AI 应先说明阶段路线，而不是直接写 00-09：

1. 输入材料评审。
2. 需求确认。
3. 需求分析。
4. 总体设计。
5. 技术选型 / 技术路线评估。
6. 详细设计。
7. 验证用例设计。
8. 执行计划 / Sprint 规划。
9. 完整文档体系评估与审计。
10. 待确认事项总览与编码前门禁。

同时提供两种模式：

- **分阶段确认模式**：默认推荐；每阶段确认后再生成下一阶段。
- **输入充分后批量生成模式**：适合快速起草；必须先做输入充分性评估，生成后必须做完整评估 / 审计。

详细的需求层人机交互、总体设计 / 技术选型、交互设计方案讨论场景不在 Batch 1 细化，后续分别并入 Batch 2 / 3 / 5。

## 10. 拟改范围

| 文件 | 建议变更 |
|---|---|
| `_proposals/README.md` | 增加 `_remote-issues/` 镜像机制、刷新规则、归档规则 |
| `template-docs/scenario-guides.md` | 增强 C1；轻量补充文档体系生成总控入口 |
| `ai/commands/template-proposal-summary.md` | 增加先镜像远端 issue、再按本地镜像分析的流程 |
| `ai/prompts/maintainers/11-template-proposal-summary.md` | 增加镜像、刷新、去重、归档、关闭 issue 的详细规则 |
| `ai/document-lifecycle-rules.md` | 增加横切状态词典、状态传播和文档体系生成总控最低规则 |
| `ai/prompts/docs/00-generate-or-complete-docs.md` | 增加生成前阶段路线与模式选择 |
| `ai/prompts/review/16-docs-system-audit.md` | 增加分批审计、横切状态和待确认总览输出 |
| `ai/prompts/review/19-docs-evaluation.md` | 增加状态词典和待确认项对 Go / Conditional Go / No Go 的影响 |
| `scripts/check-template.sh` / `.ps1` | 增加关键断言 |
| `CHANGELOG.md` / `VERSION` | 按 MINOR 记录版本 |

## 11. 版本影响

建议作为 MINOR 版本处理。

理由：

- 新增 C1 提案收件箱本地镜像机制。
- 新增文档体系分批治理原则。
- 新增横切状态词典和文档体系生成总控最低规则。
- 会影响 AI 处理提案、生成文档、评估文档和审计文档的默认行为。

## 12. 验收口径

1. C1 场景明确远端 issue 先镜像到 `_proposals/_remote-issues/`。
2. `template-proposal-summary` 命令和 Prompt 均要求优先读取本地镜像。
3. `_proposals/README.md` 明确镜像目录、命名、刷新和归档规则。
4. 文档生命周期规则中存在统一横切状态词典。
5. 文档生成 / 审计 / 评估 Prompt 能引用状态词典和待确认事项总览。
6. 用户说“生成整个文档体系”时，AI 先说明阶段路线和模式选择。
7. 自检脚本能防止关键规则被误删。
8. 合并后关闭 #111、#117；本地大提案如已被吸收，应归档或拆分剩余内容。

## 13. 非目标

- 不落地 00-03、04-05、06-07、08-09 的具体 doc-standard 文件。
- 不完整实现 `docs-open-items` command / prompt。
- 不详细展开需求层人机交互、总体设计 / 技术选型、交互设计方案讨论场景。
- 不关闭 #105-#116 中属于后续 Batch 的 issue。
- 不重写旧派生项目文档。

## 14. Issue 关闭与归档策略

- Batch 1 实施 PR 合并后关闭 #111、#117。
- 关闭留言说明：已建立提案收件箱镜像机制、分批治理规则和横切状态词典。
- 若本地大提案的治理部分已吸收，应在归档说明中标明哪些内容已吸收、哪些内容延后到 Batch 2 / 3 / 5。
- `_proposals/_remote-issues/issue-111.md` 和 `issue-117.md` 可随 Batch 1 proposal 归档；其他 issue 镜像继续保留。

## 15. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| B1-C1 | 横切状态词典主落点 | 建议放 `ai/document-lifecycle-rules.md`，其他 Prompt 引用 | 状态传播属于文档生命周期规则 | 放 `ai/global-rules.md` | 更通用但会使 global-rules 过重 |
| B1-C2 | 是否新增独立 `docs-open-items` 命令 | 建议暂不新增，只定义机制 | 避免 Batch 1 范围过大 | 立即新增 command / prompt | 清晰但会扩大版本范围 |
| B1-C3 | 远端 issue 镜像是否纳入 C1 强制流程 | 建议强制用于 C1 | 已实践成功，能减少重复远端读取 | 作为推荐做法 | 更灵活但仍可能重复读取远端正文 |
| B1-C4 | 文档体系生成总控是否在 Batch 1 落地 | 建议只落最低规则 | 完整专题讨论场景应拆到后续 Batch | 全量落地本地大提案 | 范围过大，易与 Batch 2/3/5 冲突 |
| B1-C5 | 本地大提案如何收口 | 建议实施时拆分：治理层吸收，专题讨论延后 | 提案内容跨多个 Batch | 整体归入 Batch 1 | 会让 Batch 1 过大 |
