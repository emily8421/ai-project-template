# Token Hotspot 汇总：2026-07-10 ~ 2026-09-04

> 生成日期：2026-08-13（首版 2026-07-22，07-25 第二次扩展，08-09 第三次扩展纳入 07-26 ~ 08-09 共 10 份，08-11 第四次扩展纳入 08-10 ~ 08-11 共 7 份，08-13 第五次扩展纳入 08-12 ~ 08-13 共 8 份；08-15 第六次扩展纳入 08-13 后半 ~ 08-15 共 7 份；本次 2026-08-26 第七次扩展纳入 08-16 ~ 08-26 共 11 份；2026-08-31 第八次扩展纳入 08-27 ~ 08-31 共 3 份；2026-09-04 第九次扩展纳入 08-31 漏网 1 份 + 09-03 ~ 09-04 共 2 份）。
> 归纳方法：07-22 前基于文件名 / 任务类型分布 + 4 份通读归纳；07-23 / 07-24 / 07-25 三份逐份通读；08-09 次 07-26 ~ 08-09 共 10 份逐份通读；08-11 次 08-10 ~ 08-11 共 7 份逐份通读后纳入；08-15 次 7 份、本次第七次 11 份逐份通读后纳入。
> 单条记录去向（v1.57.2 起）：单条 hotspot 记录已移至本地 `.ai/token-hotspots/`（gitignore，不上传）；本目录仅保留汇总（`SUMMARY.md` + `summaries/`）作为入库观察材料。下方“份数 / 日期”对应本地 `.ai/token-hotspots/` 中的单条文件。

## 0. 覆盖边界

- 已覆盖记录（本地 `.ai/token-hotspots/`）：07-10 ~ 07-25 共 20 份 + 07-26 ~ 08-09 共 10 份 + 08-10 ~ 08-11 共 7 份 + 08-12 ~ 08-13 共 8 份 + 08-13 后半 ~ 08-15 共 7 份 = **52 份** + 08-16 ~ 08-26 共 11 份（§8）+ 08-27 ~ 08-31 共 3 份（§9）= 66 份 + 08-31 webuikb-sync 漏网 1 份 + 09-03 ~ 09-04 共 2 份（§10）= **69 份**。
- 未覆盖记录：无（截至 2026-09-04，本地全部单条已纳入本汇总）。
- 下一次 rollup 起点：从 **2026-09-05** 起，只统计 `汇总状态：未汇总` 的本地新记录。

> 本次为常规增量 rollup：08-13 次汇总后，08-13 后半 ~ 08-15 新增 7 份未汇总（超 §4.2 的 3 份阈值），于 2026-08-15 CI 空窗期本地工作（C-010 筹备）时触发并入批。

## 1. 汇总范围（记录日期、任务类型、主要热点）

- **份数**：37 份（07-10 ~ 08-11）。
- **07-26 ~ 08-09 任务类型**（10 份，前次已纳入）：
  - 07-26 token hotspot 机制自身治理（ai-record-lifecycle 落地 v1.57.2，PR #270 / #271）
  - 07-27 派生项目 CHANGELOG-PLAIN 归属修复 + smoke（×2：脚本修复 / Windows Git Bash 诊断）
  - 07-28 远端 issue 镜像（#275 / #276，gh 401 + PowerShell REST）
  - 07-29 v1.58.2 → v1.60.0 评估 + 冻结决策（PR #289 / issue #290）+ 断言瘦身（PR #291）；派生同步 v1.59.0（跨 3 仓）
  - 07-30 registry 收口（LUMEN PR #86 完成，agent-system-template paused）
  - 08-02 C1 提案收件箱汇总（2 提案 + 7 issue 镜像）
  - 08-05 agent-system-template 9 提案收口归档（Explore agent ×2，跨仓核实）
  - 08-09 #307 docs-health-review 落地（v1.60.2，PR #309）
- **08-10 ~ 08-11 新增 7 份任务类型**：
  - 08-10 #312 token-hotspot 触发强化落地（v1.60.3，PR #315；首次践行 §4.1 强化版）
  - 08-10 归档 issue-312 镜像 + SUMMARY 份数订正（#316）
  - 08-10 document-language-style 语言规范建议分析（→ 已落地 #321）
  - 08-10 resume 下一步建议（只读，UTF-8 分块读取）
  - 08-10 agent-command-preflight 治理事故分析 + 提案起草（→ 已落地 #317）
  - 08-11 agent-command-preflight P0 实施 + D:\tmp worktree 漂移调查（→ 已落地 #317 + 转提案 #319）
  - 08-11 worktree-registration triage + P0 实施 + 双 PR 闭环（→ 已落地 v1.60.6，PR #324 / #325）
- **主要热点（08-10 ~ 08-11 新增观察）**：模板维护规则读取链固化（多次重复 index + rules-core + CONTRIBUTING + MAINTAINERS + global-rules + 相邻规则）、check-markdown-clean 误扫 `_archive`（超 MAINTAINERS §3 固定参数）、chore 归档 PR 单独建造成 CI 往返翻倍、`gh pr checks --json bucket` 字段本机为空导致轮询空转、SUMMARY 份数连续性盲区再现（订正 29→30 靠人工核实）、worktree 漂移调查（一次性）。
- **前序主要热点（07-10 ~ 08-09）**：规则门禁读取（反复全文读 CONTRIBUTING / git-guide / rules 包）、PR/CI 闭环远端 gh 查询、归档 / 同步目录 Glob 大列表、跨仓同步多仓库上下文、验证失败环境诊断往返、triage 对照（提案描述 vs 实际现状）、横切评估取证、多批次 Edit 精确重读、check-template --summary 重复长输出、跨仓核实、Windows Git Bash 环境诊断、Explore agent 批量分担、handoff 更新前 Read 全文。
- **08-12 ~ 08-13 新增 8 份任务类型**：
  - 08-12 远端 issue 只读快照（治理上下文加载 > 查询本身）
  - 08-12 C1 提案 triage 首轮评估（完整回退包 + 2 提案全文 + grep 核对）
  - 08-12 提案重新评估报告落盘（5 issue 镜像 + 首轮报告交叉对照）
  - 08-12 C1 复评 triage（2 份 AI 报告 + 4 issue 原文核实）
  - 08-12 #335 gap 评估 + 远端关闭（capability-packages / rules-core / remote-ci-sop 全文）
  - 08-12 #335 gap 补强 PATCH（plan + 2 PR + 归档；check-template 1800+ 行 Read 2 次）
  - 08-12 #332 退回重写草稿（完整规则 + issue 镜像 + 复评章节 + 范本）
  - 08-13 #332 评审 → v1.61.4 落地长任务（Grep 稀疏核实失误 + CI 失败排查 + 多轮 git/gh）
- **主要热点（08-12 ~ 08-13 新增观察）**：**Grep 稀疏匹配（-C 1）导致评审核实失误**（漏看 §6.2 中间 3 条编号列表、误判结构，Read 全段纠正）；check-template 默认输出 1800+ 行应优先 `--summary`；双报告核对应先 grep 事实锚点再精读；plan mode Explore agent 落点结论可直接当 Plan（跳过 Plan agent）；远端 gh / CI 多轮交互 + Monitor 轮询。

## 2. 为什么触发 / 为什么此前未触发

- 07-26 ~ 08-09 每份都走「快速续接 → 升级为提案评估 / 同步 / PR 闭环 / 能力落地」路径，天然命中 §4.1。
- 07-25 是上批最重（P0 minor + P1/P2 patch 全实施），但 P1/P2 复用 P0 已加载规则（`session-rules` §3.2 同会话复用），降低了二次成本——验证了规则复用机制有效。
- **8 月频率波动**：7 月 16 天 20 份 ≈ 1.3/天 → 8 月上旬（08-01 ~ 08-09）9 天 3 份 ≈ 0.3/天（治理分层 + 规则重编号，多为 §3.2 复用）；但 08-10 ~ 08-11 两天 7 份回升 ≈ 3.5/天——两个模板维护 P0 连续实施（#312 强化 → #317 预检 → #319 worktree 登记）+ 一次语言规范分析密集触发。模板维护实施类任务仍是最高频热点来源。
- **rollup 机制断裂（08-09 教训）→ 本次修复验证**：08-09 次汇总把「收尾前显式查未汇总份数」写进 §6；本次 08-11 收尾自检即触发 rollup 提示并执行，间隔从断档 10 份收敛到 7 份（两日），机制恢复。

## 3. 重复热点模式（规则读取 / 文档读取 / 代码探索 / 验证日志 / 环境诊断 等）

- **规则读取（最高频）**：模板维护 / 提案评估 / PR 闭环按 `ai/index.md` 路由反复读完整回退包 + MAINTAINERS + CONTRIBUTING + template-sync.json。07-26 ~ 08-09 延续此模式；08-09 #307 落地再读 7 份回退包（多份 200+ 行）。**08-10 ~ 08-11 模板维护实施类连续命中（#312 / #317 / #319）**：每次必读 index + rules-core + CONTRIBUTING + MAINTAINERS + global-rules（风格参照）+ 目标文件相邻规则 + commands/README；部分读取不可避免（改规则须看相邻措辞与版本纪律），但「临场决定读哪些」本身可前置固化——见 §4 新候选「模板维护最小必读清单」。
- **跨仓核实（7 月底 ~ 8 月新增突出）**：07-29 派生同步跨 3 仓；08-05 跨仓 `git log` + CHANGELOG 全文 + 母模板 6 文件核对 A 组 5 提案。跨仓是新的成本中心。
- **Windows 环境诊断（07-27 最重单条）**：PS5.1 路径拆词（通用，任何 PS→`bash -lc '..."$var"...'` 都撞）+ codex 沙箱刮 PATH（特有）；经 Claude 实现+复核、codex 独立复现，落地 v1.58.1（三脚本 MSYS PATH 自举守卫 + env-setup §8.1 文档 + 5 断言）。
- **文档读取**：提案正文（9 提案长 status 行）、issue 镜像（部分 ≈240 行）、`check-template.sh`（1991 行）、`scenario-guides.md`（860+ 行）。
- **Explore agent 分担（正向）**：08-05 用 2 个 Explore agent 批量读 9 提案 + 跨仓核对母模板落地，主上下文只收结构化矩阵 + 异常项详情。
- **handoff 更新前 Read 全文（08-05 观察）**：每次更新前 Read 全文（~100 行）定位 old_string，建议改“只 Read 待改段”。
- **远端 gh / REST**：07-28 gh 认证过期（401）转公开 REST；PowerShell `Invoke-RestMethod` 数组枚举产生空字段误导，需显式单条查询 + 原始 `curl.exe` JSON 核对。**08-10 新增**：`gh pr checks --json bucket` 在本机 gh 返回空字段 → 轮询脚本判空空转，需 TaskStop；改用 `--json state -q '[].state'` 或解析文本表格。
- **验证日志**：`check-template --summary` 项数持续增长（1862 → 1895 → 1917 → 1922 → 1995）；Windows Git Bash 跑 1900+ checks 耗时 >2min（08-10 实测超 180s 转后台执行），需 `run_in_background` 或长 timeout。
- **check-markdown-clean 参数漂移（08-11 新增）**：MAINTAINERS §3 步骤 10 固定参数是 `_proposals ai-records`；误扩 `_archive` 会扫出 29 个历史 BOM/EOF 问题、失败日志截断 4547 字符污染上下文。应严格限定参数范围，历史归档不在提交前清洁检查范围。
- **chore 归档 PR 单独建 → CI 往返翻倍（08-11 新增）**：实施 PR 与归档 PR（单文件 rename）分开各跑一轮 CI；低价值重复往返。可考虑实施 + 归档同 PR，或归档类 CI 轮询降频。
- **目录 Glob 大列表**：`_archive/proposals/`（90+ 文件）、`ai/prompts/`、`_proposals/`。
- **Grep 稀疏匹配核实失误（08-13 新增，重要）**：用 Grep `-C 1` 看 `implementation-lifecycle §6.2` 漏掉中间 3 条编号列表，误判「§6.2 无 3 条」，差点把提案对的描述当错改；Read 全段后纠正。教训：Grep 定位 + Read 全段应配对，稀疏上下文不能单独作结构判断（与 [[self-check-continuity-blindspot]] 同类的「检查存在不查连续性」盲区）。
- **check-template 长输出（08-12 新增）**：默认 1800+ 行，应优先 `--summary`（v1.61.1 落地），避免多次 Read 大输出费 token。
- **双报告核对（08-12 新增）**：两份长评估报告（首轮 122 行 + 复评 348 行）+ 4 issue 全文是评估对象本身、不可摘要替代；未来先 grep 事实锚点（章节号 / 引用 / 版本规则行）再精读可减少全文读取。

## 4. 已形成的改进建议（必须保留 / 应压缩 / 应沉淀 / 应拆会话）

- **必须保留**：规则门禁（写入前确认 + 任务路由）、check-template 全量验证（发布 gate）、远端单步确认 + 代理（7897）、issue 镜像硬门禁、逐批次 commit（可审计）、Checkpoint Mode（有效阻止误碰并发仓 agent-system-template）、逐项核实 + 用户拍板（评审先核实 feedback）、跨 CLI 交叉验证（Claude 实现 + codex 独立复现）。
- **应压缩**：
  - handoff 大段更新改“只 Read 待改段”而非全文（08-05）。
  - 提案批量读让 Explore agent 只返回矩阵 + 异常项，正常项省全文摘要（08-05）。
  - 评估类「提案原文 vs 落地」四列对照模板化（issue → 提案 → 实际 diff → CHANGELOG，07-29）。
  - PR 闭环 checklist 速查（07-10 ~ 07-26 反复出现仍未沉淀——**最高频压缩候选**，建议正式起提案）。
  - registry note 用短状态短语（`local synced` / `PR open` / `merged` / `paused`，07-29 / 07-30）。
  - `check-markdown-clean` 严格限定 MAINTAINERS §3 步骤 10 参数 `_proposals ai-records`，不扩 `_archive`（08-11）。
  - `gh pr checks` 轮询用 `--json state` 或文本解析，避免 `bucket` 字段空转（08-10）。
  - chore 归档类 PR 与实施 PR 合并或 CI 轮询降频（08-11）。
- **应沉淀**：
  - CLOSED issue 关闭时同步补“Local Triage / Implementation Notes”（#276 / #285 范式，#273 / #275 缺，08-02）——维护纪律，无需提案。
  - 提案收口矩阵模板（组 / 真实状态 / 归档判断 / 残留待办，已部分落 `_archive/proposals/README.md`，08-05）。
  - check-template 断言收敛为单一循环（从 template-sync.json 动态读，减少新增能力时的注册点，08-09 候选）。
  - CHANGELOG-PLAIN 漂移检测断言（顶部版本 == CHANGELOG.md 顶部，07-26 候选）。
  - **模板维护「最小必读清单」**（08-10 / 08-11 连续命中）：给模板维护类任务前置固化必读文件（index + rules-core + CONTRIBUTING + MAINTAINERS + global-rules + 目标文件相邻规则），避免临场决定读哪些——**新提案候选**。
- **应拆会话**：跨仓批量同步（sync-all-derived）、9 提案收口 + 归档 + A13 叠加（08-05）、多 issue triage（C1）应独立会话。
- **08-12 ~ 08-13 新增应压缩**：评审核实用 Read 全段而非 Grep 稀疏匹配；check-template 优先 `--summary`；双报告先 grep 锚点再精读。
- **08-12 ~ 08-13 新增应沉淀**：plan mode Explore agent 落点结论完整可直接当 Plan（复杂规则改造复用「Explore 即 Plan」）；check-markdown-clean 本地预检缺口（→ `ai-records/pitfalls/SUMMARY.md` + `_proposals/TEMPLATE-UPGRADE-local-preflight-coverage.md`）。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案，去项目化边界）

- **`TEMPLATE-UPGRADE-template-maintenance-must-read-checklist.md`**（模板维护最小必读清单，08-10 / 08-11 连续命中）：**最高频新候选**，建议正式起提案，降低模板维护实施的临场规则读取决策成本。
- **`TEMPLATE-UPGRADE-pr-closure-checklist.md`**（PR 闭环速查，07-10 ~ 07-26 反复出现）：最高频压缩候选，建议正式起提案。
- **`TEMPLATE-UPGRADE-check-template-assertion-consolidation.md`**（断言收敛单一循环）：08-09 候选，降低新增能力成本。
- **`TEMPLATE-UPGRADE-changelog-plain-drift-check.md`**（CHANGELOG-PLAIN 漂移检测）：07-26 候选。
- **C1 硬门禁显式化**（命令文件步骤补“先列镜像路径 + Updated/Mirrored at 再出计划”）：08-02，先观察是否反复触发。
- **已落地（无需新提案）**：Windows Git Bash（v1.58.1 PR #278 / #279）、ai-record-lifecycle（v1.57.2，本汇总机制自身）、模板能力现状索引（rd-data-chain 延伸，观察中）、**document-language-style 语言规范（v1.60.5 #321）**、**agent-command-preflight 失败域隔离（v1.60.4 #317）**、**worktree-registration 会话恢复可见性（v1.60.6 #324 / #325，本次 rollup 期间闭环）**。
- **领域仓自有流程（不回流母模板）**：agent-system-template 提案归档批注 + followups 转出（08-05，已落领域仓 `_archive/proposals/README.md` + `_proposals/_archive-followups.md`，母模板 `_proposals/` 已有完整收件箱 + `_archive/` 机制，无可复用改进）。
- **`TEMPLATE-UPGRADE-local-preflight-coverage`**（check-markdown-clean 本地预检缺口，08-11 + 08-13 双实证）：本次已起提案，见 `_proposals/`；跨派生通用（`check-markdown-clean.ps1` 在 files_all 下行同步）。详细坑见 `ai-records/pitfalls/SUMMARY.md`。

## 6. 第六次扩展新增（08-13 后半 ~ 08-15，7 份）

- **08-13 后半 4 份任务类型**：
  - 08-13 模板治理手册 / 机制与工具注册表报告（跨层权威源分散为主要成本；去重核对避免重复建设）
  - 08-13 v1.61.5 预检对齐落地 + PR 闭环（完整规则回退包为主要成本）
  - 08-13 v1.62.0 Web UI Batch 1 实施（PR #348；Explore subagent + `--summary` 可复用为标准做法）
  - 08-13 Web UI 知识库提案起草（跨文件确认“现有流程已覆盖什么”+ 外部素材合并为不重复方案的成本）
- **08-14 ~ 08-15 新增 3 份任务类型**：
  - 08-13 Web UI 提案 triage（快速续接升级为提案评估后的长规则链读取）+ 08-14 Web UI Batch 2 启动评估（只读）
  - 08-15 派生 4 仓 dry-run 预演（跨仓 SOP Prompt + registry 全表 + sync 脚本源码探路 + 4 仓近似 diff 输出 ×4）
- **主要热点（本次新增观察）**：① Web UI 提案链（triage → Batch 1 → Batch 2）三天内连续触发完整规则链读取，但已见收敛——Batch 1 起用 Explore subagent + `--summary` 降低重复长输出；② 跨仓预演的重复列表输出（4 仓 19 文件 ×4）可合并为单循环一次性输出；③ 「dry-run 被脚本自身更新保护拦截」是 SOP 已知情形，预演可直接走「FETCH_HEAD + manifest diff」等价法跳过失败往返。

## 8. 第七次扩展新增（08-16 ~ 08-26，11 份）

> 生成日期：2026-08-26。11 份逐份通读后纳入（其中 08-24 一份为英文记录且「Summary status: Not summarized」字段格式不同，靠本地文件枚举对照识别——再次印证 §7 08-15 教训：计数用枚举不用字段）。

- **覆盖范围**：08-16 LUMEN 主题试点准备、08-18 延后池 triage、08-19 governance Batch 2 评估、08-19 template-docs 重组评估、08-21 workspace 评估 + project-container 闭环（×2）、08-22 resume action card PR 闭环、08-24 worktree 清理 handoff（英文）、08-25 registry flowkit 推送、08-26 C1 triage Batch A + webui-kb backlog/registry + Batch B 实施（×3）。
- **主要热点（本次新增观察）**：
  - **规则链读取成本随任务粒度不匹配**：08-25 registry 单行推送走了 8 份文件的路由包（其中 implementation-lifecycle / project-rules 关联度低）——「PR/CI/Git 收尾」包对「纯远端收尾（无本地代码改动）」可再裁一刀；08-19 Batch 2 评估读了 12 文件规则链 + 800 行提案分段两次。
  - **大输出任务的消化模式已成型**：审计/分类/check-template 全量交给后台任务或 `--summary`（08-21 / 08-26 Batch B 均如此）；`/tmp` 隔离跑 smoke 成为标准（08-26 首次误在工作区根建目录，教训入记录）。
  - **并行会话冲突排查成为新高频成本**（08-26 三连发：zhiyan / LUMEN / web-ui-kb 均被并行会话先动）——行动卡前置「先实查该仓 Git」设计的回报持续兑现；registry 滞后同源（pitfall `registry-lag-parallel-sync` 已记）。
  - **GitHub API 间歇故障处置模式稳定**：TLS 超时 → 先 `gh pr view` 核实是否实际执行 → 再重试（08-26 Batch B merge #402 实战）。
  - **triage 类任务的状态行成本**：部分落地提案在 C1 中只是「状态行确认」，可把「已落地/剩余」提炼为提案头部执行摘要（08-26 观点，复发 ≥2 再立案——本轮为第 1 次）。
- **模板回流判断**：本轮 11 份无新的必须回流项。「规则包按任务粒度再裁」观察与既往 §5 判断一致（维持观察）；「提案头部执行摘要」为窄提案候选，未达立案阈值；其余均已在 pitfall / hotspot 记录内闭环。

## 9. 第八次扩展新增（08-27 ~ 08-31，3 份）

> 生成日期：2026-08-31。3 份逐份通读后纳入；覆盖边界按本地文件枚举核对（08-27×2 + 08-31，无字段漏计）。

- **覆盖范围**：08-27 derived-init-trim 评估与落地（v1.70.0 模板维护）、08-27 flowkit + web-ui-kb 两仓同步（A13 ×2 同会话）、08-31 pitfall 第四批 rollup（PR #420）。
- **主要热点（本次新增观察）**：
  - **「快速续接 → 写任务」的路由包成本连续命中**：08-27 模板维护读完整回退包约 8-10k（document/implementation-lifecycle 与任务相关性低）；08-31 治理记录 rollup 读 5 份路由文件（implementation-lifecycle 实际仅用边缘内容）。加上第七批已记的 08-25 registry 单行推送（8 文件路由包），该模式已 **3+ 次命中**——从「维持观察」升级为**窄提案立案候选**：任务路由表为「纯治理记录 / PR 收尾（无本地代码改动）」类任务定义更窄必读集（remote-ci-sop-profile 速查层已可承载），下次 C1 triage 决定是否立案。
  - **同会话多仓复用收益验证（正向）**：08-27 第二仓同步跳过已加载规则重读（§3.2 复用边界成立），两仓约 8 个命令批次完成主链——跨仓连续任务的推荐姿势。
  - **坑 → 修正 → 当天验证闭环（正向）**：08-27 上午 grep head 截断返工（pitfall 单条），下午引用巡检改全量执行零漏项——pitfall 修正当天生效，观察机制价值实证。
- **模板回流判断**：仅「路由包按任务粒度裁剪」升级为立案候选（见上）；多仓复用与坑验证闭环均不回流。

## 10. 第九次扩展新增（08-31 漏网 1 份 + 09-03 ~ 09-04 共 2 份，3 份）

> 生成日期：2026-09-04。3 份逐份通读后纳入；按本地文件枚举对照覆盖清单（08-15 教训口径），捞出 08-31 webuikb-sync 一份早于上批「下次起点 09-01」的漏网记录（第八批 rollup 与该同步任务同日，SUMMARY 定起点后当天新写的记录无人认领——教训见尾部 09-04 条）。

- **覆盖范围**：08-31 web-ui-kb v1.71.0 同步（母仓会话内跨仓执行）、09-03 B-001 复核（快速续接 → 诊断任务）、09-04 handoff 缺口修正（快速续接 → 本地写入任务）。
- **主要热点（本次新增观察）**：
  - **「路由包 / prompt 按任务粒度裁读」持续命中且分型清晰（3/3 命中同一候选）**：08-31 是 **prompt 文件裁读**变体（15-post-sync-cleanup 全文 ~190 行仅用六类审计项清单段）；09-03 是**纯只读诊断类**（重读 5 份规则文件，实际只需 rules-core 硬规则 + session-rules §3.3）；09-04 是**纯本地记录写入类**（重读 index + rules-core）。累计 **6+ 次命中**，窄提案立案候选维持，下次 C1 triage 决定是否立案（输入已挂模板仓行动卡）。
  - **dry-run diffstat 防御性核实有效（正向）**：`git diff FETCH_HEAD --ignore-cr-at-eol` 一次核出真实内容差（~+67/-4），3 轮只读核实零误操作。
  - **材料编码假设沿用致返工（09-03）**：沿用上次会话 UTF-16 假设处理新日志（实为 UTF-8），解码返工 2 次——「先验证编码再解码」老教训复发，诊断材料每次都应先验编码。
- **模板回流判断**：无新增回流项；「路由包按任务粒度裁剪」为唯一持续候选（见上），其余均在单条内闭环。



- 07-22 教训：连续多轮 PR 闭环累积补记 → 建议每轮 PR 合并后即写单条。
- 07-25 执行：P0+P1/P2 实施完即时写单条（07-25），符合建议；规则复用（§3.2）降低二次成本。
- CI 轮询 sleep：template-check 实际 ~11–17s，15s 易二次轮询（07-25 实测 sleep 8–15 仍偶有 IN_PROGRESS）→ 建议 sleep ≥20s。
- **08-09 教训（rollup 断裂）**：SUMMARY 停在 07-26，之后 10 份未汇总（§4.2 阈值 3 份的 3 倍多），连续多个会话收尾时未触发 rollup 提示。根因：rollup 靠“AI 收尾自觉”，无累计计数器强制触发，属与 [[self-check-continuity-blindspot]] 同类的连续性盲区（检查项存在，但无计数器，全靠每次自觉）。用户视角后果：单条是 gitignored 本地不可见，SUMMARY 是唯一跨会话可见层，断了 → 用户误判“机制停转”。改进：每次会话收尾前显式检查“上次 SUMMARY 后本地新增未汇总份数 ≥3 即提示 rollup”；08-09 已补齐 10 份欠账。
- **08-10 教训（份数连续性盲区再现）**：归档 issue-312 时订正 SUMMARY 份数（29→30），发现 handoff「下次优先做」推测的份数不可当锚点——本地 `.ai/token-hotspots/` 文件枚举一度误判为 31（把 rollup 元记录 `08-09-rollup-catchup` 算入被汇总单条），需对照 §1 清单修正。印证 [[self-check-continuity-blindspot]]：**rollup 份数必须用本地文件枚举交叉验证，handoff 推测不能当稳定锚点**；check-template 不查 hotspot 份数（与 §4.2「无自检门禁」一致，仅观察）。
- **08-11 教训（改进验证）**：上次 §6 改进（收尾前显式查未汇总份数）生效——本次 08-11 收尾自检即触发 rollup 提示，未再出现断档欠账；间隔收敛到 2 日 7 份。
- **08-13 教训（Grep 核实盲区）**：评审核实 §6.2 时 Grep `-C 1` 稀疏匹配漏看中间 3 条编号列表，误判结构，差点错改提案；Read 全段纠正。与 [[self-check-continuity-blindspot]]（check-template 只查存在不查连续性）同类——**核实用 Read 全段，Grep 只作定位**。
- **08-15 教训（pitfall 漏计同源）**：C-010 记 3 条未汇总 pitfall，实际 4 条（serial-timeout 无「汇总状态」字段未被识别）——与 08-10 hotspot 份数盲区同源：**计数靠字段自觉，缺字段即漏计**；rollup 前应用本地文件枚举对照 SUMMARY 覆盖清单，不能只信字段。
- **08-26 教训（rollup 断档 11 天再现）**：第六次扩展停在 08-15，之后 11 天 11 份未汇总（再次超阈值 3 份近 4 倍）——与 08-09 断档同根因：连续多会话收尾时各自未达「本会话视角 ≥3」触发线（各会话只写 1-2 条），**阈值按会话计数而非按总量计数是盲区**。改进：会话收尾自检时应查「SUMMARY 末次覆盖日期 vs 本地最早未汇总日期」的间隔，间隔 ≥7 天或总数 ≥3 任一触发即提示 rollup（本次按总量 3 份提示生效，但已欠 11 份；间隔条件为新增补强）。
- **09-04 教训（同日记录落起点边界）**：第八批 rollup 与 web-ui-kb 同步同日（08-31）进行，SUMMARY 定「下次起点 09-01」后、当天晚些新写的 08-31 记录成为漏网——按日期起点切割会漏掉「rollup 定稿之后、当天之内」的新记录。改进：每次 rollup 以「本地文件枚举 vs SUMMARY 覆盖清单」的差额核对为准，日期起点只作辅助（08-15 教训的边界情形补强；本次按枚举捞出）。
