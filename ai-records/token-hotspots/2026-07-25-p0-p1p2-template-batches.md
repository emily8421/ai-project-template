# Token Hotspot：P0+P1/P2 模板批次全实施长会话

- 日期：2026-07-25
- 任务类型：模板维护（P0 minor + P1/P2 patch 全实施 + 7 PR 闭环）
- 分支：`change/system-skeleton-gate`（#262/#263）+ `change/p1p2-doc-enhancements`（#264/#265）
- 版本：v1.57.0（P0）+ v1.57.1（P1/P2）
- 汇总状态：已纳入 SUMMARY.md（2026-07-25 第二次更新）

## 1. 热点（上下文成本高的环节）

### 1.1 完整规则回退包读取
- 从快速续接升级到 P0 实施，按模板维护路由读完整回退包（`ai/index.md` / `rules-core` / `global-rules` / `document-lifecycle-rules` / `implementation-lifecycle-rules` / `session-rules` / `commands/README` + `run-dev-task` + `MAINTAINERS` / `CONTRIBUTING` + 提案本体），10 个文件一次并行读。
- P1/P2 复用了 P0 已加载规则（`session-rules` §3.2 同会话复用），未重读——这部分省了。

### 1.2 多批次 Edit + 逐批次精确文本重读
- P0 8 批次 + P1/P2 5 批次，每批次改文件前要 Read 精确文本（中文 markdown，Edit 要求 `old_string` 精确匹配，中文全角标点 / 空格易失败）。
- 同文件跨批次改（`global-rules` / `implementation-lifecycle-rules` 在 P0 批次 1、2 都改）→ 必须边做边 commit 才能干净分批次，每批次前重读确认行号未漂。

### 1.3 check-template 重复长输出
- 每个关键节点（P0 批次 7 断言、批次 8 版本 bump；P1/P2 批次 E）跑 `check-template.sh --summary`，每次 ~25 行分区计数。P0 跑 2 次 + P1/P2 跑 1 次 + 归档 `check-markdown-clean`。
- `--summary` 已摘要化（v1.56.13 引入），但多次累积仍占上下文。

### 1.4 提案评估前置读取
- P0 评估读 `batch-overview` + `system-skeleton-gate` 提案；P1/P2 读 `batch-overview` + 4 个配套提案（5 文件并行）。

## 2. 质量影响

- 规则回退包读取是硬规则门禁，不可省；但 P1/P2 复用 P0 已加载规则（§3.2）确实降低了二次成本，值得继续推广。
- 逐批次精确重读是 Edit 正确性保障（中文 `old_string` 易因标点 / 空格失败），换来的代价可接受；失败时靠重读修复，往返成本可控。
- `check-template --summary` 摘要化已很好，进一步压缩空间有限；它是发布 gate，不宜省。

## 3. 优化建议

- **可压缩**：P1/P2 接续时 §3.2 规则复用已生效（本次做到），同类长维护会话继续沿用。
- **可沉淀**：P0/P1/P2 的批次化实施模式（提案评估 → 切分支 → 分批次 commit → 每批次自检 → 聚合 PR → 归档 → 下行）已成熟，可考虑沉淀成 maintainer SOP 或 `scenario-guides` C 场景，减少下次类似长维护的规划成本。
- **应拆会话**：下行同步（4 派生项目跨 v1.54→v1.57.1 多版本）是独立大任务，已决策另起会话——避免本会话继续膨胀（符合 §4.1「应拆会话」判断）。
- **保留**：完整规则回退包读取（硬规则）、`check-template` 全量验证（发布 gate）、逐批次 commit（可审计）。

## 4. 关联

- 续接：`.ai/session-handoff.md`（P0+P1/P2 闭环 + 下行同步待做）
- 提案：`_archive/proposals/TEMPLATE-UPGRADE-system-skeleton-gate.md` 等 5 份（已归档）
- 前序 hotspot：`2026-07-24-template-proposal-evaluation.md`（P0 评估阶段）
