# TEMPLATE-UPGRADE: Batch 3.1 文档标准分层与 00-03 细粒度规范补齐

> Proposal status: Draft for implementation
> Proposal batch: Batch 3.1
> Related issues: preparatory batch before Batch 4; no new GitHub issue yet
> Source context: maintainer request after Batch 3 merge; derived from archived Batch 1 / 2 / 3 / 7 proposals and active Batch 4 / 5 / 6 proposal shape
> Source proposals: `_archive/proposals/TEMPLATE-UPGRADE-batch-1-proposal-inbox-governance-status-dictionary.md`, `_archive/proposals/TEMPLATE-UPGRADE-batch-2-requirements-chain-00-03.md`, `_archive/proposals/TEMPLATE-UPGRADE-batch-3-architecture-tech-risk-readiness.md`, `_archive/proposals/TEMPLATE-UPGRADE-batch-7-docs-generation-guidance-open-items.md`, `_proposals/TEMPLATE-UPGRADE-batch-4-db-api-contract-status-gates.md`, `_proposals/TEMPLATE-UPGRADE-batch-5-dev-plan-verification-evidence-handoff.md`, `_proposals/TEMPLATE-UPGRADE-batch-6-design-doc-standard.md`

## 1. 背景与问题

Batch 2 已把 `00-03` 需求链规范落地到 `docs/00-03`、`ai/document-lifecycle-rules.md`、生成 / 审计 / 评估 Prompt 和 `ai/doc-standards/README.md`；Batch 3 已新增独立的 `ai/doc-standards/04-architecture.md` 与 `05-tech-spec.md`，明确 `04/05` 的细粒度标准。

当前仍存在结构性不一致：

1. `ai/doc-standards/` 的定位尚未被明确为“每份文档的细粒度标准源”。
2. `00-03` 需求阶段仍缺独立标准文件，细则分散在 `docs/00-03`、`ai/doc-standards/README.md`、`document-lifecycle-rules` 和 prompts 中。
3. `docs/00-09` 同时承担“大纲模板”和“规则说明”职责，容易让派生项目事实文档变重，也让 AI 不清楚精修某份文档时该读取哪个细粒度规则。
4. 同步脚本仍保留“从 `docs/00-03、06-09` 镜像到 `ai/doc-standards/`”的历史机制；这会和“doc-standards 是独立标准源”的目标冲突。
5. 后续 Batch 4 / 5 / 6 将分别补 `06-07`、`08-09`、`docs/design/*` 细粒度标准；若不先确定分层，后续实现会继续混用模板骨架与标准规则。

因此 Batch 3.1 应作为 Batch 4 前的结构整理：先把 `ai/doc-standards/` 明确为细粒度标准源，补齐 `00-03` 独立标准，并让 `docs/00-09` 回归大纲模板职责。

## 2. 设计目标

1. 明确三层职责：
   - `ai/document-lifecycle-rules.md`：跨文档生命周期总控。
   - `ai/doc-standards/*.md`：每份核心文档的细粒度规范标准。
   - `docs/00-09.md`：项目事实文档的大纲模板。
2. 新增独立 `ai/doc-standards/00-03` 标准文件，吸收 Batch 2 的需求链细则。
3. 在 `docs/00-09` 每个章节使用统一形式 `【撰写提要：……】`，作为大纲填写提示，而不是承载完整规则。
4. 让生成、精修、审计、评估按 scope 读取对应标准文件：
   - 生成 / 审计需求阶段 → 读取 `ai/doc-standards/00-03`。
   - 精修某份文档 → 读取对应 `ai/doc-standards/<doc>.md`。
   - 生成整个文档体系 → 读取已存在的 `ai/doc-standards/00-09` 标准；尚未独立标准化的阶段按当前模板兼容，并由 Batch 4 / 5 / 6 补齐。
5. 调整同步逻辑：`ai/doc-standards/00-05` 独立标准由同步清单同步，不再由 `docs/00-05` 镜像覆盖。
6. 为 Batch 4 / 5 / 6 提供统一落地模式：新增标准文件 → docs 大纲模板轻量化 → Prompt / command / 自检引用对应标准。

## 3. 分层规则

| 层级 | 文件 | 职责 | 禁止项 |
|---|---|---|---|
| 生命周期总控 | `ai/document-lifecycle-rules.md` | 阶段链路、输入输出职责、追溯、状态传播、变更传播、评估门禁 | 不展开每份文档的全部字段细则 |
| 细粒度标准 | `ai/doc-standards/00-09.md`、未来 `ai/doc-standards/design-*.md` | 每份文档的章节、字段、ID、矩阵、状态、审计项、禁止项 | 不写项目事实；不替代 `docs/` |
| 大纲模板 | `docs/00-09.md` | 派生项目实际填写内容的大纲、占位表格、`【撰写提要：……】` | 不堆叠大量规则说明；不成为标准源 |
| Prompt / command | `ai/prompts/*`、`ai/commands/*` | 根据用户意图路由到 lifecycle + 对应 doc-standards + docs 模板 | 不复制大段标准，避免多处漂移 |

## 4. 00-03 独立标准来源

Batch 3.1 应从已归档 Batch 2 proposal 抽取而非重新发明规则。

| 标准文件 | 主要来源 | 必须覆盖 |
|---|---|---|
| `ai/doc-standards/00-scenario.md` | Batch 2 §4.1 | 文档元信息、角色、典型场景、边界 / 非目标、来源映射、下游影响、待确认项 |
| `ai/doc-standards/01-user-requirements.md` | Batch 2 §4.2 | U-ID、用户操作流、用户可观察 AC、优先级与阶段建议、非目标、追溯矩阵 |
| `ai/doc-standards/02-srs.md` | Batch 2 §4.3 | REQ-ID、NFR-ID、约束假设、边界异常、U-ID → REQ-ID、验证入口 |
| `ai/doc-standards/03-prd.md` | Batch 2 §4.4 | 产品目标、功能清单、Phase 路线图、优先级取舍、非目标、REQ 覆盖矩阵、证据 / 验收引用 |

还应引用 Batch 1 的横切状态词典和待确认事项结构，引用 Batch 7 的分阶段确认 / open items / 专题讨论门禁，确保 `00-03` 标准不只描述字段，也描述状态、确认和生成边界。

## 5. docs 大纲模板要求

`docs/00-09` 应继续保留项目事实大纲，但每个章节的提示形式统一为：

```markdown
【撰写提要：说明本章节要填写什么、上游依据是什么、不得写入什么、需要如何追溯。】
```

要求：

1. 每个 H2 章节至少有一条 `【撰写提要：……】`。
2. 章节下的表格保留最低可填写字段；复杂规则移入 `ai/doc-standards/<doc>.md`。
3. `docs/00-03` 的撰写提要应指向来源锚点、需求链和状态，而非长篇解释标准。
4. `docs/04-05` 的撰写提要应保持与已有 `ai/doc-standards/04/05` 对齐。
5. `docs/06-09` 在 Batch 4 / 5 未完成前，先统一撰写提要形式，不提前补完整细粒度标准。
6. 未来 Batch 4 / 5 / 6 落地时，应继续把详细规范写入 `ai/doc-standards/06-09` / design 标准，再回头轻量调整 docs 大纲。

## 6. 生成 / 精修 / 审计路由规则

| 用户意图 | 必读标准 | 必读事实 / 模板 | 输出重点 |
|---|---|---|---|
| 生成整个文档体系 | `ai/document-lifecycle-rules.md`、已存在的 `ai/doc-standards/00-09` | `docs/00-09`、`docs/README.md`、输入材料 | 全链路草稿、阶段路线、open items、评估 / 审计建议 |
| 生成需求阶段文档 | `ai/doc-standards/00-03`、lifecycle E1 / E2、需求链健康度 | `docs/00-03`、输入材料 | `SC-ID → U-ID → REQ-ID → Phase → AC / TC` |
| 精修某份文档 | 对应 `ai/doc-standards/<doc>.md` | 当前 `docs/<doc>.md`、上下游影响文档 | 最小变更、下游影响、待确认项 |
| 审计需求阶段 | `ai/doc-standards/00-03`、`document-lifecycle-rules` §6 | `docs/00-03` | 需求链健康度矩阵、断点、修复建议 |
| 评估阶段转换 | `ai/prompts/review/19-docs-evaluation.md` + 对应标准 | 当前阶段相关 docs | Go / Conditional Go / No Go |

## 7. 拟改范围

| 文件 / 区域 | 变更摘要 |
|---|---|
| `ai/doc-standards/00-scenario.md` | 新增 00 细粒度标准 |
| `ai/doc-standards/01-user-requirements.md` | 新增 01 细粒度标准 |
| `ai/doc-standards/02-srs.md` | 新增 02 细粒度标准 |
| `ai/doc-standards/03-prd.md` | 新增 03 细粒度标准 |
| `ai/doc-standards/README.md` | 明确 doc-standards 是细粒度标准源，并列出当前覆盖状态 / 待补齐阶段 |
| `ai/document-lifecycle-rules.md` | 明确 lifecycle 与 doc-standards / docs 大纲的分工；增加按 scope 读取标准的路由规则 |
| `docs/00-09.md` | 每个 H2 章节统一补 `【撰写提要：……】`，保持大纲模板职责 |
| `ai/prompts/docs/00-generate-or-complete-docs.md` | 生成全体系 / 需求阶段时读取对应 doc-standards |
| `ai/prompts/docs/04-edit-single-doc.md` | 精修某文档时读取对应 doc-standard |
| `ai/prompts/review/16-docs-system-audit.md` | 审计时按 scope 对照对应 doc-standards |
| `ai/prompts/review/19-docs-evaluation.md` | 阶段评估时读取对应阶段标准 |
| `ai/prompts/review/10-docs-checklist.md` | 编码前 checklist 引用 00-05 独立标准和后续待补标准状态 |
| `ai/commands/docs-evaluation.md` / `generate-docs.md` / `edit-single-doc.md` / `docs-system-audit.md` | 如有必要，同步命令说明中的必读文件 |
| `template-sync.json` | 加入 `ai/doc-standards/00-03` 独立标准 |
| `scripts/sync-template.sh` / `.ps1` | 不再从 `docs/00-05` 镜像覆盖独立标准；暂保留 `06-09` 兼容镜像直到 Batch 4 / 5 独立标准落地 |
| `scripts/check-template.sh` / `.ps1` | 增加 00-03 独立标准、撰写提要、路由规则和同步逻辑断言 |
| `VERSION` / `CHANGELOG.md` | 递增版本并记录 Batch 3.1 |

## 8. 版本影响

建议作为 MINOR 版本处理，例如 `v1.35.0`。

理由：

- 新增 `00-03` 独立细粒度标准文件。
- 改变 `ai/doc-standards/` 的正式定位和同步方式。
- 改变 AI 生成、精修、审计、评估时的必读依据链。
- 为 Batch 4 / 5 / 6 的标准化落地提供统一结构。

## 9. 验收口径

1. `ai/doc-standards/00-03` 独立标准文件存在，且覆盖 Batch 2 proposal 中对应最低要求。
2. `ai/doc-standards/README.md` 明确三层分工：lifecycle / doc-standards / docs 大纲。
3. `docs/00-09` 每个 H2 章节均使用 `【撰写提要：……】` 形式。
4. `document-lifecycle-rules` 明确生成、精修、审计、评估时按 scope 读取对应标准。
5. 生成 / 精修 / 审计 / 评估 Prompt 不再只笼统说读取 `docs/00-09`，而是要求读取对应 `ai/doc-standards/<doc>.md`。
6. `sync-template` 不再用 `docs/00-05` 覆盖独立 `ai/doc-standards/00-05` 标准；`06-09` 镜像兼容保留并注明待 Batch 4 / 5 替换。
7. 自检脚本能防止 `00-03` 标准、撰写提要和同步分层规则被误删。
8. Batch 3.1 合并后，Batch 4 / 5 / 6 继续按“标准文件优先，docs 大纲轻量”的模式实施。

## 10. 非目标

- 不落地 `06-07` DB / API 契约细粒度标准；该范围留给 Batch 4。
- 不落地 `08-09` 开发计划 / 验证证据细粒度标准；该范围留给 Batch 5。
- 不落地 `docs/design/*` 通用详细设计标准；该范围留给 Batch 6。
- 不重写派生项目事实文档。
- 不把 `docs/00-09` 改成规则手册；docs 仍是项目事实大纲模板。
- 不改变已经合并的 Batch 1 / 2 / 3 / 7 决策，只抽取其中已批准的细则并整理到更合适的位置。

## 11. 风险与缓解

| 风险 | 缓解 |
|---|---|
| 改动范围较广 | 只做分层、00-03 标准和撰写提要统一；06-09/design 细则不提前展开 |
| docs 模板变得过轻导致使用者不知道怎么写 | 每章保留 `【撰写提要：……】` 和最低表格；详细规则指向 doc-standards |
| sync-template 历史镜像逻辑复杂 | 明确保留 `06-09` 兼容镜像，`00-05` 改为独立标准同步 |
| Prompt 与标准重复 | Prompt 只写路由和门禁，不复制大量字段标准 |
| 已归档提案遗漏细节 | Batch 3.1 实施前读取 Batch 1 / 2 / 3 / 7 归档提案，逐项抽取已批准细则 |

## 12. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| B3.1-C1 | 是否将 `ai/doc-standards/` 正式定义为细粒度标准源 | 建议是 | 解决 docs 大纲与规则标准混用问题 | 继续从 docs 镜像标准 | 会让标准职责继续混乱，影响 Batch 4/5/6 |
| B3.1-C2 | 是否先补 `00-03` 独立标准再做 Batch 4 | 建议是 | Batch 2 已完成但缺独立标准文件；后续阶段应先统一模式 | 直接做 Batch 4 | 可能继续产生标准位置不一致 |
| B3.1-C3 | `docs/00-09` 是否统一使用 `【撰写提要：……】` | 建议是 | 用户明确要求；便于大纲模板轻量化且可读 | 只改 00-03 | 统一性不足，后续还需再扫一轮 |
| B3.1-C4 | 是否保留 `06-09` 镜像兼容直到 Batch 4/5 | 建议保留 | 避免提前创建未细化标准；保持同步可用 | 立即新增空标准 | 可能产生空洞标准或重复返工 |

## 13. 归档策略

Batch 3.1 实施 PR 合并后，本 proposal 应移动到 `_archive/proposals/`。若实施过程中发现需要远端 issue，可再补建 GitHub issue；否则作为模板维护者内部结构整理批次处理。
