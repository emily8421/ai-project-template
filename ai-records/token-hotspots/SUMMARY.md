# Token Hotspot 汇总：2026-07-10 ~ 2026-08-09

> 生成日期：2026-08-09（首版 2026-07-22，07-25 第二次扩展，本次第三次扩展纳入 07-26 ~ 08-09 共 10 份）。
> 归纳方法：07-22 前基于文件名 / 任务类型分布 + 4 份通读归纳；07-23 / 07-24 / 07-25 三份逐份通读；本次 07-26 ~ 08-09 共 10 份逐份通读后纳入。截至本次覆盖 30 份（07-10 ~ 08-09），其中 07-10 ~ 07-22 早期 16 份非全部逐份审计。
> 单条记录去向（v1.57.2 起）：单条 hotspot 记录已移至本地 `.ai/token-hotspots/`（gitignore，不上传）；本目录仅保留汇总（`SUMMARY.md` + `summaries/`）作为入库观察材料。下方“份数 / 日期”对应本地 `.ai/token-hotspots/` 中的单条文件。

## 0. 覆盖边界

- 已覆盖记录（本地 `.ai/token-hotspots/`）：07-10 ~ 07-25 共 20 份 + 07-26 ~ 08-09 共 10 份 = **30 份**。
- 未覆盖记录：无（截至 2026-08-09，本地全部单条已纳入本汇总）。
- 下一次 rollup 起点：从 **2026-08-10** 起，只统计 `汇总状态：未汇总` 的本地新记录。

> 本次是一次“补欠账” rollup：上次 SUMMARY 停在 07-26，之后连续 10 份未汇总（远超 §4.2 的 3 份阈值），连续多个会话收尾时未触发 rollup 提示。机制本身没停（单条一直在写），是汇总层断了——详见 §6 教训。

## 1. 汇总范围（记录日期、任务类型、主要热点）

- **份数**：30 份（07-10 ~ 08-09）。
- **07-26 ~ 08-09 新增 10 份任务类型**：
  - 07-26 token hotspot 机制自身治理（ai-record-lifecycle 落地 v1.57.2，PR #270 / #271）
  - 07-27 派生项目 CHANGELOG-PLAIN 归属修复 + smoke（×2：脚本修复 / Windows Git Bash 诊断）
  - 07-28 远端 issue 镜像（#275 / #276，gh 401 + PowerShell REST）
  - 07-29 v1.58.2 → v1.60.0 评估 + 冻结决策（PR #289 / issue #290）+ 断言瘦身（PR #291）；派生同步 v1.59.0（跨 3 仓）
  - 07-30 registry 收口（LUMEN PR #86 完成，agent-system-template paused）
  - 08-02 C1 提案收件箱汇总（2 提案 + 7 issue 镜像）
  - 08-05 agent-system-template 9 提案收口归档（Explore agent ×2，跨仓核实）
  - 08-09 #307 docs-health-review 落地（v1.60.2，PR #309）
- **主要热点（07-26 ~ 08-09 新增观察）**：跨仓核实（git log / CHANGELOG / 母模板文件多仓对照）、Windows Git Bash 环境诊断（最重单条 15KB，跨 CLI 交叉验证）、Explore agent 批量分担、handoff 更新前 Read 全文、远端 gh 认证过期 + PowerShell REST 数组枚举坑。
- **前序主要热点（07-10 ~ 07-25）**：规则门禁读取（反复全文读 CONTRIBUTING / git-guide / rules 包）、PR/CI 闭环远端 gh 查询、归档 / 同步目录 Glob 大列表、跨仓同步多仓库上下文、验证失败环境诊断往返、triage 对照（提案描述 vs 实际现状）、横切评估取证、多批次 Edit 精确重读、check-template --summary 重复长输出。

## 2. 为什么触发 / 为什么此前未触发

- 07-26 ~ 08-09 每份都走「快速续接 → 升级为提案评估 / 同步 / PR 闭环 / 能力落地」路径，天然命中 §4.1。
- 07-25 是上批最重（P0 minor + P1/P2 patch 全实施），但 P1/P2 复用 P0 已加载规则（`session-rules` §3.2 同会话复用），降低了二次成本——验证了规则复用机制有效。
- **8 月频率明显下降**（7 月 16 天 20 份 ≈ 1.3/天 → 8 月 9 天 3 份 ≈ 0.3/天）：8 月工作集中在治理分层 + 规则重编号 + 单点能力落地（#302 ~ #311），多为 §3.2 同会话规则复用 + 快速续接为主，重读取减少。
- **rollup 机制断裂**：SUMMARY 停在 07-26，之后 10 份未回流。机制没停（单条一直在写），是汇总这层断了——见 §6。

## 3. 重复热点模式（规则读取 / 文档读取 / 代码探索 / 验证日志 / 环境诊断 等）

- **规则读取（最高频）**：模板维护 / 提案评估 / PR 闭环按 `ai/index.md` 路由反复读完整回退包 + MAINTAINERS + CONTRIBUTING + template-sync.json。07-26 ~ 08-09 延续此模式；08-09 #307 落地再读 7 份回退包（多份 200+ 行）。
- **跨仓核实（7 月底 ~ 8 月新增突出）**：07-29 派生同步跨 3 仓；08-05 跨仓 `git log` + CHANGELOG 全文 + 母模板 6 文件核对 A 组 5 提案。跨仓是新的成本中心。
- **Windows 环境诊断（07-27 最重单条）**：PS5.1 路径拆词（通用，任何 PS→`bash -lc '..."$var"...'` 都撞）+ codex 沙箱刮 PATH（特有）；经 Claude 实现+复核、codex 独立复现，落地 v1.58.1（三脚本 MSYS PATH 自举守卫 + env-setup §8.1 文档 + 5 断言）。
- **文档读取**：提案正文（9 提案长 status 行）、issue 镜像（部分 ≈240 行）、`check-template.sh`（1991 行）、`scenario-guides.md`（860+ 行）。
- **Explore agent 分担（正向）**：08-05 用 2 个 Explore agent 批量读 9 提案 + 跨仓核对母模板落地，主上下文只收结构化矩阵 + 异常项详情。
- **handoff 更新前 Read 全文（08-05 观察）**：每次更新前 Read 全文（~100 行）定位 old_string，建议改“只 Read 待改段”。
- **远端 gh / REST**：07-28 gh 认证过期（401）转公开 REST；PowerShell `Invoke-RestMethod` 数组枚举产生空字段误导，需显式单条查询 + 原始 `curl.exe` JSON 核对。
- **验证日志**：`check-template --summary` 项数持续增长（1862 → 1895 → 1917 → 1922）；Windows Git Bash 跑 1900+ checks 耗时 >2min，需 `run_in_background` 或长 timeout。
- **目录 Glob 大列表**：`_archive/proposals/`（90+ 文件）、`ai/prompts/`、`_proposals/`。

## 4. 已形成的改进建议（必须保留 / 应压缩 / 应沉淀 / 应拆会话）

- **必须保留**：规则门禁（写入前确认 + 任务路由）、check-template 全量验证（发布 gate）、远端单步确认 + 代理（7897）、issue 镜像硬门禁、逐批次 commit（可审计）、Checkpoint Mode（有效阻止误碰并发仓 agent-system-template）、逐项核实 + 用户拍板（评审先核实 feedback）、跨 CLI 交叉验证（Claude 实现 + codex 独立复现）。
- **应压缩**：
  - handoff 大段更新改“只 Read 待改段”而非全文（08-05）。
  - 提案批量读让 Explore agent 只返回矩阵 + 异常项，正常项省全文摘要（08-05）。
  - 评估类「提案原文 vs 落地」四列对照模板化（issue → 提案 → 实际 diff → CHANGELOG，07-29）。
  - PR 闭环 checklist 速查（07-10 ~ 07-26 反复出现仍未沉淀——**最高频压缩候选**，建议正式起提案）。
  - registry note 用短状态短语（`local synced` / `PR open` / `merged` / `paused`，07-29 / 07-30）。
- **应沉淀**：
  - CLOSED issue 关闭时同步补“Local Triage / Implementation Notes”（#276 / #285 范式，#273 / #275 缺，08-02）——维护纪律，无需提案。
  - 提案收口矩阵模板（组 / 真实状态 / 归档判断 / 残留待办，已部分落 `_archive/proposals/README.md`，08-05）。
  - check-template 断言收敛为单一循环（从 template-sync.json 动态读，减少新增能力时的注册点，08-09 候选）。
  - CHANGELOG-PLAIN 漂移检测断言（顶部版本 == CHANGELOG.md 顶部，07-26 候选）。
- **应拆会话**：跨仓批量同步（sync-all-derived）、9 提案收口 + 归档 + A13 叠加（08-05）、多 issue triage（C1）应独立会话。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案，去项目化边界）

- **`TEMPLATE-UPGRADE-pr-closure-checklist.md`**（PR 闭环速查，07-10 ~ 07-26 反复出现）：**最高频候选**，建议本次正式起提案。
- **`TEMPLATE-UPGRADE-check-template-assertion-consolidation.md`**（断言收敛单一循环）：08-09 候选，降低新增能力成本。
- **`TEMPLATE-UPGRADE-changelog-plain-drift-check.md`**（CHANGELOG-PLAIN 漂移检测）：07-26 候选。
- **C1 硬门禁显式化**（命令文件步骤补“先列镜像路径 + Updated/Mirrored at 再出计划”）：08-02，先观察是否反复触发。
- **已落地（无需新提案）**：Windows Git Bash（v1.58.1 PR #278 / #279）、ai-record-lifecycle（v1.57.2，本汇总机制自身）、模板能力现状索引（rd-data-chain 延伸，观察中）。
- **领域仓自有流程（不回流母模板）**：agent-system-template 提案归档批注 + followups 转出（08-05，已落领域仓 `_archive/proposals/README.md` + `_proposals/_archive-followups.md`，母模板 `_proposals/` 已有完整收件箱 + `_archive/` 机制，无可复用改进）。

## 6. 记录节奏教训（累积）

- 07-22 教训：连续多轮 PR 闭环累积补记 → 建议每轮 PR 合并后即写单条。
- 07-25 执行：P0+P1/P2 实施完即时写单条（07-25），符合建议；规则复用（§3.2）降低二次成本。
- CI 轮询 sleep：template-check 实际 ~11–17s，15s 易二次轮询（07-25 实测 sleep 8–15 仍偶有 IN_PROGRESS）→ 建议 sleep ≥20s。
- **08-09 教训（rollup 断裂）**：SUMMARY 停在 07-26，之后 10 份未汇总（§4.2 阈值 3 份的 3 倍多），连续多个会话收尾时未触发 rollup 提示。根因：rollup 靠“AI 收尾自觉”，无累计计数器强制触发，属与 [[self-check-continuity-blindspot]] 同类的连续性盲区（检查项存在，但无计数器，全靠每次自觉）。用户视角后果：单条是 gitignored 本地不可见，SUMMARY 是唯一跨会话可见层，断了 → 用户误判“机制停转”。改进：每次会话收尾前显式检查“上次 SUMMARY 后本地新增未汇总份数 ≥3 即提示 rollup”；本次已补齐 10 份欠账。
