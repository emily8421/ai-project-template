# Token Hotspot：模板提案批次评估（2026-07-24）

> 类型：AI 协作观察记录（非项目事实文档）。不替代 `.ai/session-handoff.md`、`docs/08-dev-plan.md` 或 `docs/09-verification.md`。
> 边界：只记录任务类型、文件路径、命令类别、热点判断、质量影响与优化建议；不含 token 数值、密钥、账号或敏感数据。

## 1. 任务类型

模板维护·提案评估。路径：快速续接（resume）→ 用户提出 7 条模板优化思路要求评估 → 引入另一 AI 独立分析做双 AI 对比 → 综合后起草提案批次（1 份评估总览 + 5 份配套提案 + 本 hotspot）。

## 2. 命中的触发条件（session-rules §4.1）

- ✅ 从快速续接进入分析 / 设计 / 写入任务后，又完整读取 `ai/index.md` 及其规则清单（rules-core / session-rules / global-rules §8 / implementation-lifecycle / project-rules / CONTRIBUTING / _proposals/README）。
- ✅ 执行模板维护 / 提案评估长任务，多次读取大文件、长 agent 报告，并多次运行只读 git 检查。
- ✅ `ai/` 规则、`template-docs/`、`_proposals/` 成为本次主要上下文成本。

## 3. 主要热点（文件 / 命令类别）

- **规则读取（分散）**：`ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`（快速续接 + 任务路由）、`ai/global-rules.md §8`、`ai/implementation-lifecycle-rules.md §1–§7`、`ai/project-rules.md`（全文，含 §6 写入确认 / §2.9 版本锁定）、`CONTRIBUTING.md`、`_proposals/README.md`。横切评估需跨 7+ 规则文件定位现状。
- **现状文档**：根 `README.md`、`docs/README.md`、`template-docs/web-fullstack-profile.md`（全文，含 §5.1）。
- **两个 Explore agent 长报告**：主题 A/B/C（演示 + 阶段路径 + 场景质量）与 D/E/F（node 版本 + 知识沉淀 + 图纸规范），各返回结构化结论 + file:line 证据。
- **双 AI 对比**：综合另一 AI 分析记录，新增一轮对比 / 采纳 / 盲点 / 分歧裁决成本。
- **只读命令**：`git status / log / stash`、`git checkout -b`（切维护分支）。

## 4. 热点判断

中—重。任务横跨文档体系、演示机制、版本管理、主文件约束、实现阶段路径、知识沉淀六个子系统，规则与现状证据天然分散，单次会话需大量定位读取。属「横切评估型」热点，非单文件深读型。

## 5. 质量影响

- 风险：上下文越重，跑飞 / 失忆概率越高（rules-core §2 已警示）。本任务因涉及写入（提案落盘），失忆会导致提案引用错位。
- 缓解生效项：① 规则按层路由（index 任务路由表）避免了全量预读 `ai/`；② 两个 Explore agent 并行分担现状取证，主上下文只收结论而非文件 dump；③ 双 AI 对比虽增成本，但互补了命名碰撞、场景质量无效项、四层不同步等盲点，提升了评估正确性。

## 6. 优化建议

1. **模板能力现状索引**：横切评估类任务反复定位「某机制现在做到哪了」，可考虑一份轻量「模板能力现状索引」（按子系统列出机制 + 权威 file:line），减少跨会话重复取证。可作为 `rd-data-chain-profile` 提案的延伸或独立 patch。
2. **Explore agent 分担常态化**：本任务两个并行 agent 显著降低主上下文成本，建议横切评估默认采用「主上下文读核心规则 + agent 并行探查子系统」模式。
3. **双 AI 对比成本可控化**：对比分析聚焦「共识 / 增量 / 盲点 / 分歧」四段，避免全量重述；本批已按此压缩。
4. **提案批次组织**：评估总览 + 配套提案平铺 `_proposals/`，互相回指，减少未来 triage 时重复阅读。

## 7. 汇总状态

- 汇总状态：未汇总（待 `ai-records/token-hotspots/SUMMARY.md` rollup，见 session-rules §4.2）。
