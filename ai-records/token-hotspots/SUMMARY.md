# Token Hotspot 汇总：2026-07-10 ~ 2026-07-25

> 生成日期：2026-07-25（首版 2026-07-22，本次扩展纳入 07-23 / 07-24 / 07-25 三份）
> 归纳方法：07-22 前基于文件名 / 任务类型分布 + 4 份通读归纳；07-23 / 07-24 / 07-25 三份逐份通读后纳入。非全部 19 份逐份审计。

## 1. 汇总范围（记录日期、任务类型、主要热点）

- **份数**：19 份（07-10 ~ 07-22 共 16 份 + 07-23 / 07-24 / 07-25 各 1 份）。
- **日期范围**：2026-07-10 ~ 2026-07-25。
- **07-23 ~ 07-25 新增任务类型**：
  - 07-23 AI 编码上下文预算提案整理（候选提案去模型化 + 拆 PR checklist / check-template 可用性两个 patch 候选）
  - 07-24 模板提案批次评估（7 提案双 AI 综合评估 + batch-overview + 5 配套提案起草）
  - 07-25 P0+P1/P2 批次全实施（13 批次 Edit + 7 PR 闭环 + 多次 check-template）
- **主要热点（新增观察）**：横切评估型规则取证（跨 7+ 规则文件定位现状）、Explore agent 并行分担、双 AI 对比、多批次 Edit 的逐批次精确重读、check-template --summary 重复长输出。
- **前序主要热点（07-10 ~ 07-22）**：规则门禁读取（反复全文读 CONTRIBUTING / git-guide / rules 包）、PR/CI 闭环远端 gh 查询、归档 / 同步目录 Glob 大列表、跨仓同步多仓库上下文、验证失败环境诊断往返、triage 对照（提案描述 vs 实际现状）。

## 2. 为什么触发 / 为什么此前未触发

- 07-23 ~ 07-25 连续三份都走「快速续接 → 升级为提案评估 / 写入 / PR 闭环」路径，天然命中 §4.1。
- 07-25 是本批最重（P0 minor + P1/P2 patch 全实施），但 P1/P2 复用 P0 已加载规则（`session-rules` §3.2 同会话复用），降低了二次成本——验证了规则复用机制有效。
- rollup 机制（§4.2）v1.56.1 落地后持续运行：首版 07-22，本次 07-25 第二次更新。

## 3. 重复热点模式（规则读取 / 文档读取 / 代码探索 / 验证日志 / 环境诊断 等）

- **规则读取（最高频）**：模板维护 / 提案评估 / PR 闭环按 `ai/index.md` 路由反复读 CONTRIBUTING / git-guide / template-sync.json / project-rules / rules-core / proposals README。07-23 / 07-24 / 07-25 延续此模式。
- **横切评估取证**：07-24 评估跨 6 子系统定位现状，跨 7+ 规则文件；07-25 实施前派 Explore agent 盘点四层文件 + 行号核实（有效分担主上下文）。
- **多批次 Edit 精确重读**：07-25 的 13 批次 Edit，每批次改前 Read 精确文本（中文 `old_string` 易因全角标点 / 空格失败）。
- **验证日志**：check-template / CI / markdown-clean 重复长输出（`--summary` 已摘要化，仍累积）。
- **远端 gh 查询**：PR review / checks / merge / 分支清理。
- **目录 Glob 大列表**：`_archive/proposals/`（90+ 文件）、`ai/prompts/`、`_proposals/`。

## 4. 已形成的改进建议（必须保留 / 应压缩 / 应沉淀 / 应拆会话）

- **必须保留**：规则门禁（写入前确认 + 任务路由）、check-template 全量验证（发布 gate）、远端单步确认 + 代理（7897）、issue 镜像硬门禁、逐批次 commit（可审计）。
- **应压缩**：
  - PR 闭环 checklist 速查（CONTRIBUTING §3/§4 + git-guide + project-rules §6 + 预检），减少每轮全文重读（07-23 / 既有 summary 反复出现）。
  - 候选提案整理短 checklist（只整理 `_proposals/` 候选、Release impact=none 的场景，07-23 建议）。
  - §3.2 同会话规则复用继续推广（07-25 验证有效）。
- **应沉淀**：
  - 模板能力现状索引（按子系统列机制 + 权威 file:line，减少跨会话重复取证；07-24 建议，可作 rd-data-chain 延伸或独立 patch）。
  - 批次化实施 SOP / scenario-guides C 场景（提案→切分支→分批次 commit→每批次自检→聚合 PR→归档→下行；07-25 建议，模式已成熟）。
  - check-template 本地可用性（Windows smoke 慢 + PowerShell stderr；07-22 / 07-23 反复候选）。
- **应拆会话**：跨仓批量同步（sync-all-derived）+ 多 issue triage（C1）+ 下行同步（4 派生跨多版本）应独立会话。07-25 下行同步已决策另起。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案，去项目化边界）

- **`TEMPLATE-UPGRADE-pr-closure-checklist.md`**（PR 闭环速查，高频重复读取）：适合形成，先观察频率。
- **`TEMPLATE-UPGRADE-check-template-local-usability.md`**（Windows 本地自检可用性）：去项目化、通用于 Windows 维护者，适合形成（07-22 / 07-23 候选）。
- **模板能力现状索引**（横切评估取证）：07-24 建议，可作 rd-data-chain-profile 延伸或独立 patch（候选）。
- **批次化实施 SOP**（scenario-guides C 场景或 maintainer SOP）：07-25 建议，模式已成熟可沉淀（候选）。
- **本汇总机制自身**：§4.2 rollup 已运行（首版 07-22，本次 07-25 第二次更新），结构可用，无需额外提案。

## 6. 记录节奏教训（累积）

- 07-22 教训：连续多轮 PR 闭环累积补记 → 建议每轮 PR 合并后即写单条。
- 07-25 执行：P0+P1/P2 实施完即时写单条（07-25），符合建议。
- CI 轮询 sleep：template-check 实际 ~11–17s，15s 易二次轮询（07-25 实测 sleep 8–15 仍偶有 IN_PROGRESS）→ 建议 sleep ≥20s。
