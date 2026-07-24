# TEMPLATE-UPGRADE：研发数据链 Profile（轻量索引 / 分类）

> 来源：模板维护者（双 AI 综合评估 P2，见 `TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`）
> 状态：候选（待评估 → 处理中）
> 目标版本：待确认（建议 patch）
> Release impact：patch（AI 建议，待维护者确认）—— 治理说明补强，不改默认行为
> Release strategy：同主题聚合

## 1. 动机（WHY）

模板有两条性质不同的链：① **文档事实链**（强统一，`document-lifecycle-rules §2/§5/§6` 把 inputs→vision→00-09→design→08→09→code 串成可追溯主链）；② **辅助留痕**（`decisions/` ADR、`research/`、`meetings/`、`CHANGELOG`、`.ai/session-handoff.md`、`ai-records/`）—— 每个有定位但**散落多处、无统一总览**，且：
- `ai-records/token-hotspots/` 自成体系（记录→summaries→SUMMARY rollup），但只覆盖「AI 开发过程成本」，与项目领域知识链无交叉（孤岛 meta 链）。
- 辅助留痕载体**无自检硬门禁**（不像运行时机制 / doc-standards 有 `check-template.sh` require_contains 守卫），依赖人工 / AI 自觉。
- 新成员 / 新 AI 会话难以一眼看清「研发过程中产生的各类数据该沉淀到哪、如何流转、何时回写 00-09」。

建议开一条**轻量知识沉淀路径**，把各留痕载体与主链的关系、流转规则、生命周期统一索引，**不污染 00-09 核心文档**。

## 2. 现状证据（file:line）

| 现状 | 证据 |
|---|---|
| 文档事实链强统一 | `ai/document-lifecycle-rules.md:28-39`（§2 PLM 链）、`:131-149`（§5 生成矩阵）、`:268-288`（§6 追溯链） |
| 辅助留痕各自为政，定位散落 | `docs/README.md:8-19, 58-72`（§5）、`document-lifecycle-rules §7/§8`、`implementation-lifecycle-rules §7.1` |
| token-hotspots 孤岛 meta 链 | `ai-records/token-hotspots/SUMMARY.md`、`session-rules §4.1/§4.2` |
| project-registry 维护者侧、不下行同步 | `ai-records/project-registry/README.md` |
| sync-records 是派生侧概念（母模板无） | 母模板无 `sync-records/`；派生项目同步报告落此 |
| 辅助留痕无自检门禁 | `scripts/check-template.sh` require_contains 只守运行时 / doc-standards，不守 ADR / research / meetings |
| handoff 非持久、须回写 08/09 | `ai/implementation-lifecycle-rules.md:107-108` |

## 3. 拟改（WHAT）

### 3.1 轻量研发数据链 Profile

新增 `template-docs/rd-data-chain.md`（或并入 `docs/README.md` 新增章节，待确认），作为**索引 / 分类**文档，定义研发过程中各类数据如何沉淀：

| 数据类别 | 沉淀载体 | 与主链关系 | 生命周期 |
|---|---|---|---|
| 架构决策 / 取舍 | `docs/decisions/`（ADR） | 约束 04/05 | 长期，版本演进留痕 |
| 技术调研 / 实验 / 评估 | `docs/research/` | 输入 05 readiness gate | 阶段性，结论回写 05 |
| 验证证据 / 验收记录 | `docs/09-verification.md` | 主链验收层 | 只增不删 |
| 会议 / 评审 / 访谈 | `docs/meetings/` | 输入 00-03 | 留痕，结论回写需求 |
| 版本变更 | `CHANGELOG.md` | 发布边界 | 长期 |
| AI 开发过程成本 | `ai-records/token-hotspots/` | meta（非领域知识） | 观察，rollup |
| 派生项目谱系 / 同步 | `ai-records/project-registry/`、`sync-records/`（派生侧） | 维护者侧 | 长期 |
| 会话续接 | `.ai/session-handoff.md` | 临时，须回写 08/09 | gitignored |

明确**边界**：研发数据链是索引 / 导航，不替代 00-09 事实文档；长期事实必须回写 00-09（`implementation-lifecycle-rules §7.1`）。

### 3.2 串联孤岛（可选增强）

- 让 `ai-records/token-hotspots/` 的优化建议可回流 `_proposals/`（已有机制，本 Profile 显式说明这条流转路径）。
- 在 Profile 中标注各载体「是否下行同步」「是否自检门禁」，让维护者一眼看到哪些留痕无守卫。

### 3.3 不做重流程

遵循「先做索引和分类，不急着做重流程」：本提案只产出索引 / 分类 / 流转说明，不为 ADR / research / meetings 新增强制必填或自检门禁（避免过度治理；强制化另案讨论）。

## 4. 版本影响

**patch**。治理说明 / 索引补强，不改默认行为、不改同步清单结构（`rd-data-chain.md` 为可选参考）。若决定给辅助留痕加强制自检门禁，则升 minor（新增下游采用面），但本提案默认不做。

## 5. 影响面（拟改文件）

| 文件 | 改动 |
|---|---|
| （方案 A）`template-docs/rd-data-chain.md` | 新增研发数据链 Profile |
| （方案 B）`docs/README.md` | 新增「研发数据链」章节 |
| `template-sync.json` | 若新增 template-docs 文件，登记同步 |
| `template-docs/beginner-guide.md` / `MAINTAINERS.md` | 导航补 Profile 入口 |

## 6. 待确认项

| ID | 待确认 | AI 建议 | 依据 |
|---|---|---|---|
| RC-1 | 载体：独立 template-docs/rd-data-chain.md vs docs/README 章节 | 方案 A（独立 Profile），与 web-fullstack-profile 同级，可同步 | 不污染 docs 根、与现有 Profile 一致 |
| RC-2 | 是否给辅助留痕加自检门禁 | 不加（本提案），保持轻量；强制化另案 | 避免过度治理 |
| RC-3 | 是否纳入 token-hotspots → proposals 回流路径 | 纳入说明（已有机制，显式化） | 串联孤岛 |

## 7. 落地流程

1. 确认 §6 后，在维护分支新增 / 修改 Profile 文件。
2. `scripts/check-template.sh` 自检。
3. PR 评审（重点：是否过度治理、是否保持 00-09 权威、索引是否准确）。
4. 合并后 patch 版本递增 + CHANGELOG，下行同步。

## 8. 验证方式

- `scripts/check-template.sh` 通过。
- Profile 索引覆盖全部辅助留痕载体，且与各载体 README 定位一致。
- 边界声明清晰（不替代 00-09）。

## 9. 关联

- 评估总览：`TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`（提案 7）。
- 关联 `ai-records/token-hotspots/2026-07-24-template-proposal-evaluation.md`：本提案呼应 hotspot 记录里「模板能力现状索引」优化建议。
