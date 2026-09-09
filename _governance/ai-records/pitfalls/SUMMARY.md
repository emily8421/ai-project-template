# Pitfall 汇总：2026-08-11 ~ 2026-09-04

> 生成于 2026-08-13（rollup，session-rules §4.3，首次创建）；2026-08-15 第二次扩展纳入第二批 5 份；2026-08-19 第三次扩展纳入第三批 3 份；2026-08-31 第四次扩展纳入第四批 9 份（2026-08-21 ~ 08-27）；2026-09-04 第五次扩展纳入第五批 3 份（2026-08-31 ~ 09-04）。本目录只保留 SUMMARY.md + summaries/；单条原始记录在本地 `.ai/pitfalls/`（gitignore，不询问不上传）。从单条脱敏提炼，剔除 token / 密钥 / 账号 / 对话正文 / 项目敏感细节。

## 0. 覆盖边界

- 已覆盖记录（本地 `.ai/pitfalls/`）：第一批 6 份（2026-08-11 ~ 08-13）+ 第二批 5 份（2026-08-13 后半 ~ 08-15）+ 第三批 3 份（2026-08-16 ~ 08-19）+ 第四批 9 份（2026-08-21 ~ 08-27）= 23 份 + 第五批 3 份（2026-08-31 ~ 09-04，§9）= **26 份**。
- 未覆盖记录：无（截至 2026-09-04 本地全部已纳入）。
- 下一次 rollup 起点：从 **2026-09-05** 起，只统计 `汇总状态：未汇总` 的本地新记录。
- 计数口径订正：首批 rollup 时漏计 `2026-08-13-serial-check-template-timeout.md`（旧记录无「汇总状态」字段，当时未被识别为未覆盖），本次一并收编。
- 计数口径订正（第四批）：按本文件覆盖边界（08-20 起）实得 9 份；此前 handoff 侧曾按「4 条（08-25~08-27）」计，漏了 08-21×2 / 08-22×2 / 08-24 共 5 份，以覆盖边界为准。

## 1. 汇总范围（第一批 6 份，2026-08-11 ~ 08-13）

| 日期 | 场景 | 根因分类 | 一句话现象 |
|---|---|---|---|
| 08-11 | pitfall 机制落地 PR（首次 dogfood） | 流程坑 | 本地 check-template 全绿 ≠ CI 绿（漏跑 check-markdown-clean，提案文件缺末尾换行） |
| 08-12 | 远端 issue 只读快照 | 环境 | 超时后返回 open=0，新鲜查询显 4 个；pending/terminated 输出不可信 |
| 08-12 | gh PR merge 收尾 | 流程坑 | `--delete-branch` 已删本地，再 `branch -D` 报 not found，误判 merge 失败 |
| 08-12 | 写 commit message | 流程坑 + 模板缺口 | `.ai/tmp` 文件被 `git add -A` 误 commit + preflight warning 断 `&&` 链 |
| 08-12 | 新建提案草稿 | 环境 / 工具链 | Windows PS 下 apply_patch 包装器不可用（多行 / stdin 编码传递失败） |
| 08-13 | #332 落地 PATCH v1.61.4 | 模板缺口 | 本地 check-template 不覆盖 `_proposals` markdown clean（同 08-11 类） |

## 2. 为什么触发 / 为什么此前未触发

v1.61.1 起启用 pitfall 观察日志（§4.3）；C1 提案批次 + v1.61.3 / v1.61.4 落地是多场密集模板维护，密集触发各类坑；累积 6 份超 rollup 阈值（≥3），本次首次入库 SUMMARY。

## 3. 重复坑模式

- **本地自检 vs CI 覆盖不一致**（08-11 + 08-13，同类 2 次）：本地 `check-template.ps1` 不覆盖 CI 的 `check-markdown-clean.ps1 _proposals ai-records` step，本地全绿仍 CI fail。出现 2 次，证据最强。
- **gh / git 命令语义误用**（08-12 merge）：`--delete-branch` 一步完成 merge + 删远端 + 删本地 + checkout base + pull，重复手动清理报错。
- **临时文件 / 工具链**（08-12 `.ai/tmp`、apply_patch）：`.ai/` 非整目录 gitignore + Windows 工具链兼容性。
- **远端命令超时不可信**（08-12）：pending / terminated 输出需独立交叉核对。

## 4. 已形成的改进建议

- **应沉淀（转提案）**：本地落地前补跑 `check-markdown-clean.ps1 _proposals ai-records`——纳入 `check-template.ps1` 预检或写进 implementation-lifecycle / remote-ci-sop-profile 本地验证清单（08-11 + 08-13 双实证）。（✅ 已落地 v1.61.5：`check-template.ps1` 追加调用 + `remote-ci-sop-profile` §B 说明 + `check-template.sh` 断言。）
- **应沉淀**：`.gitignore` 补 `.ai/tmp-*` 或 commit message 用 stdin heredoc（08-12 `.ai/tmp`）。
- **应沉淀**：`remote-ci-sop-profile §E` 补「`--delete-branch` 已含本地 + 远端清理，勿重复手动删」（08-12 merge）。
- **应沉淀**：Windows PowerShell 下 apply_patch 不可用 → 用 `[System.IO.File]::WriteAllText`（UTF-8 无 BOM）落盘（08-12 apply_patch）；可向上游反馈包装器问题。
- **行为约束**：远端 pending / terminated 命令的零结果不可信，独立交叉核对（08-12 timeout）。
- **保留本地**：已纳入 SUMMARY 的单条可标「已纳入」后归档 `.ai/pitfalls-archive/`。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案）

- **最值得转提案**：check-markdown-clean 覆盖缺口（08-11 + 08-13 同类，2 次实证 + 跨派生通用）→ `_proposals/TEMPLATE-UPGRADE-local-preflight-coverage.md`（本次已起）。
- **次优先**：`.ai/tmp` gitignore + commit heredoc；`gh --delete-branch` 勿重复删。
- **项目专属**（Windows apply_patch）：留 `git-guide.md` / SOP 提示，不必单立模板提案。

## 6. 第二批（2026-08-13 后半 ~ 08-15，5 份）

| 日期 | 场景 | 根因分类 | 一句话现象 |
|---|---|---|---|
| 08-13 | Batch 0 试点 flowkit RA 生成 | AI 引入 + 流程坑 | 误用 miiot `9-历史归档/` 过时材料 + 未核实现状重复造轮子（教训已入 memory `feedback-historical-archive-not-source`） |
| 08-13 | Batch 1 PR #348 ui-knowledge 起草 | AI 引入 | §10 表述自检流于形式，7 处口语比喻 + a11y 缩写漏进 PR，用户要求后才补审 |
| 08-13 | Batch 1 发布过程 | AI 引入（流程坑） | 新建 `.ai/e2e-reports/` 未先核对 `.gitignore`（逐项列出非整目录忽略），返工补一条 gitignore commit |
| 08-13 | v1.61.5 验证 | 行为教训 | 全量自检串行 3 次被 harness 判超时中断（实际均跑完）；教训 = 只跑一次 + 日志落盘为证据 |
| 08-15 | 派生同步 dry-run 预演 | 环境 / 工具链 | PowerShell `Out-File -Encoding utf8` 带 BOM，bash 脚本首行 shebang 失效；用 Bash 重定向或 WriteAllText（UTF-8 无 BOM） |

### 第二批重复坑模式

- **材料来源不核实现状**（08-13 wrong-archive，与第一批 08-12 Grep 稀疏核实同属「先做后核」）：调研前未区分当前正式 vs 历史归档、未查项目是否已有同类产出。
- **生成后清单式自检被挤掉**（08-13 §10）：起草时注意力在内容完整性，表述自检作为末项清单流于形式。
- **Windows 工具链编码坑持续**（08-15 BOM，与第一批 08-12 apply_patch 同主题）：PowerShell 5.1 的 utf8 写文件默认带 BOM，bash / 工具链不容忍。

### 第二批改进建议与回流判断

- **候选转提案（观察中）**：§10 表述自检条在 `00-generate-or-complete-docs.md` / `04-edit-single-doc.md` 中前移或加粗——按单条约定「下次生成复发即转窄提案」，暂不起（与 memory `rule-enforcement-via-execution-nodes` 的「接入执行节点」方向一致）。
- **已沉淀非提案渠道**：wrong-archive 教训入 memory；serial-timeout 属行为纪律（Checkpoint Mode 长输出），不改模板。
- **行为约束**：新建 `.ai/` 子目录前先 grep `.gitignore`；给 bash 的脚本文件不用 `Out-File -Encoding utf8` 落盘。
- **Windows 编码主题**（apply_patch + BOM 两条）已有共性结论，复发第三次可合并转一条窄提案（`git-guide.md` / SOP 附注级）。

## 7. 第三批（2026-08-16 ~ 08-19，3 份）

| 日期 | 场景 | 根因分类 | 一句话现象 |
|---|---|---|---|
| 08-16 | web-ui-knowledge-base 派生建仓 | 流程坑 | `new-project.sh` 未加 `--no-examples`，`_archive/` 归档文件自带 EOF 多余空行 + init 全新 root diff 全量检查 → 首提交 CI 红 |
| 08-17 | v1.62.1 双 PR 闭环 | AI 引入 | 误信「Actions 额度用完」未核实 public 仓免费政策，已 commit 的版本空窗 2 天，复核后当天闭环 |
| 08-19 | v1.66.0 template-docs 重组 | AI 引入 + 流程坑 | ① sed 批量迁移漏改 check-template 断言 pattern 本身（27 项失败）；② `git archive HEAD` 烟测跑在结构 commit 之前；③ 批量 rm 后残留空目录 |

### 第三批重复坑模式

- **自检断言 / 验证链与改动不同步**（08-19 ①②，与第一批「本地自检 vs CI 覆盖不一致」同主题不同面）：路径迁移类改动只改被检文件不改检查器匹配串；依赖 HEAD 的验证跑在 commit 之前。共性 = 把「改完」当「验证过」，验证链的时间点与对象没进改动清单。
- **远端 / 平台政策类信息未核实就落阻塞**（08-17，与第二批「材料来源不核实现状」同属「先信后核」）：额度 / 限额 / 权限信息收口进 handoff 前未查仓库可见性与官方政策。
- **一次性流程坑**（08-16 / 08-19 ③）：建仓默认复制归档材料、批量删除残留空目录——低频但每次必踩的机械操作缺口。

### 第三批改进建议与回流判断

- **候选窄提案（观察中）**：`new-project.sh` 默认不复制 `_archive/` 或复制时跑 whitespace 清理（08-16，所有派生首建都会遇到）——待 6 仓同步窗口实操后视复发情况决定是否起 `_proposals/` 提案，本次不起。
- **行为纪律（不改模板）**：远端阻塞类信息先核实仓库可见性 + 官方政策 + 实际 CI 记录再落 handoff，阻塞记录附依据来源与复核状态（08-17）。
- **候选沉淀点（暂不动）**：路径迁移三坑（断言 pattern / 验证时序 / 空目录）适合并入 `template-docs/maintainer/rd-data-chain.md` 维护者操作附注；该文件 v1.66.0 起为模板仓专用，改动需走窄提案，本次不动。

## 8. 第四批（2026-08-21 ~ 08-27，9 份）

| 日期 | 场景 | 根因分类 | 一句话现象 |
|---|---|---|---|
| 08-21 | workspace-root-structure 评估 | 流程坑 | miiot README/目录索引登记的子目录实际不在工作空间根（仅 .code-workspace 登记挂载），只读登记未 `ls` 物理目录，误判根目录条目数 |
| 08-21 | 归档提案 PR 收尾 | AI 引入 + 流程坑 | `git add -A` 把刻意未跟踪的 7 份评估卷入 commit，push 后 stat 复核才发现，reset 重加修正（与第一批 08-12 `.ai/tmp` 同模式，第二次实证） |
| 08-22 | 模板仓 PR 预检 | 流程坑 | 两个规则锚点的 rg 查询共用一个失败域，其中一个无匹配即 exit 1，按 Checkpoint Mode 误停远端流程 |
| 08-22 | 提案归档 PR #384 | 流程坑 | markdown-clean 把 `_archive/` 存量历史脏数据（BOM/EOF）误当本轮回归——CI 等效范围本不含 `_archive/`，全目录扫描制造假警报 |
| 08-24 | Codex 残留 worktree 清理 | 环境（Windows） | `git worktree remove` 注册已删但物理目录被其他进程占用删不掉；Git 视角与文件系统视角是两个独立结果，失败后须分别复查 |
| 08-25 | 6 仓同步窗口排期 | 流程坑（多会话并发） | 母仓 registry/handoff 显示两仓「待同步」，实际已被并行会话同步完；registry 是 point-in-time 快照非实时状态，排期前未实查派生仓 |
| 08-26 | flowkit 治理目录迁移方案 | AI 引入 | 方案把 PR 模板提案路径判为「已正确、无需改」，实查仍是根级旧路径；「不改」清单沿用调研印象、未当轮读文件原文，靠验证阶段全量复核拦下 |
| 08-27 | derived-init-trim 前置审计 | 流程坑 | `grep | head -30` 恰好截断，漏看 check-template.sh:949 冲突断言，实施后首次全量自检失败，二次定位返工约 10 分钟 |
| 08-27 | web-ui-kb 同步 A 阶段预检 | 流程坑 | 一条 Bash 拼接多个 ls，输出无分隔混排，把根级目录存在性检查误读成 docs/research 内容，2 轮补充实查才纠正 |

### 第四批重复坑模式

- **信息源新鲜度未核实（登记 / 印象 ≠ 当轮实况）**（08-21 登记挂载 + 08-25 registry 滞后 + 08-26 方案印象）：把文档登记、中心 registry、调研初期的印象当作实时事实，缺一步物理实查。与第二批 wrong-archive、第三批 CI 额度误判同主题，跨批次第三次集中复发——共性解法 = 清单里每一项动手前给出当轮实查证据，而不是沿用调研阶段的判断。
- **诊断输出域污染**（08-22 失败域合并 + 08-27 head 截断 + 08-27 ls 混排）：一次调用混杂多个问题域、或输出被截断 / 混排，导致信息丢失或归属误判。rules-core 现行「预检精确查询与失败域隔离」条目已覆盖该方向，剩余是执行纪律问题，不是模板缺口。
- **收尾 / 环境机械坑**（08-21 `git add -A` + 08-24 Windows worktree 半删）：`git add -A` 范围失控为第二次实证（第一次 08-12）；worktree 注册删除与物理删除在 Windows 上是两个独立结果。

### 第四批改进建议与回流判断

- **行为纪律（不改模板）**：含刻意未跟踪文件的仓库收尾用明确路径 `git add <清单>` + commit 后 `git show --stat` 复核 staged 集合；影响面审计 grep 全量输出不截断（先 `wc -l` 计数或落盘再筛）；结构预检一条命令只问一个问题、输出加分隔；方案「不改」清单逐项附当轮实查证据；派生仓状态以该仓 Git 实查为准，registry 只作 point-in-time 参考。
- **候选窄提案（计数观察中）**：`git add -A` 卷入未跟踪文件已两次实证（08-12 + 08-21）——复发第三次时转 `git-guide.md` / SOP 附注级窄提案（与第二批「Windows 编码主题第三次合并转提案」同款计数法）。
- **不回流（维持单条原判）**：08-25 registry 滞后属机制已知（registry 版本字段本就声明快照语义），不加治理；08-24 Windows worktree 为环境一次性坑，留本地记录。

## 9. 第五批（2026-08-31 ~ 09-04，3 份）

> 生成日期：2026-09-04。3 份逐份通读后纳入；按本地文件枚举对照覆盖清单（08-15 教训口径），本批与 handoff 计数一致、无漏网。

| 日期 | 场景 | 根因分类 | 一句话现象 |
|---|---|---|---|
| 08-31 | pitfall 第四批 rollup 归档 | 流程坑 | `.ai/pitfalls-archive/` 首建暴露 `.gitignore` 缺口（只有 `.ai/pitfalls/` 无 archive 项），9 份归档件 untracked；「新建 .ai/ 子目录先核对 gitignore」教训第二次实证（08-13 首次），随 PR #420 补一行修复 |
| 09-03 | B-001 自检故障复核 | 环境 | 自检死于 check-template.sh:490 spawn 阶段（Win32「找不到文件」，无断言失败输出）；同脚本非沙箱重跑 2104/0 → 定性 Codex CLI 沙箱限制进程创建；顺带复踩「诊断材料未先验编码」（UTF-16 假设 vs 实际 UTF-8，解码返工 2 次） |
| 09-04 | hotspot rollup 提交前预检 | 流程坑 | `check-markdown-clean.ps1 _proposals ai-records` 从仓库根执行时参数解析为不存在目录 →「skip missing path」+「OK: no Markdown files found」呈空跑通过外观；正确 cwd 为 `_governance/`，换目录重跑 18 文件 PASS |

### 第五批重复坑模式

- **已知教训当轮未执行（复踩型）**（08-31 gitignore 核对 + 09-03 编码先验证）：两条都不是新知识——分别是 SUMMARY 第二批既有建议与单条自身教训的再犯。已知教训的执行率（而非知识覆盖）是当前主要缺口。
- **空跑通过 / 静默降级**（09-04 md-clean）：可选路径类脚本对缺失输入静默 skip + 空集 OK 收尾，失败不 fail-closed；与 08-22「markdown-clean 误扫 `_archive/` 假警报」同主题不同面（那次多扫，这次漏扫）。
- **环境类故障定性分流**（09-03）：无断言失败输出的进程创建类错误优先怀疑沙箱 / 环境限制，换非沙箱复核一次再定性——该分流已沉淀为 v1.72.0 规则（rules-core §2，PR #429），坑 → 修正 → 规则闭环正向证据。

### 第五批改进建议与回流判断

- **已沉淀（无需动作）**：09-03 spawn 分流已随 v1.72.0 入规则；08-31 gitignore 缺口已随 PR #420 修复，均无残留。
- **行为纪律（不改模板）**：mkdir 任何 `.ai/` 子目录前先 `git check-ignore` 验证覆盖（08-31，两次实证）；诊断材料读取前先验证实际编码（09-03）；md-clean 固定从 `_governance/` 执行，读到「no Markdown files found」应视为路径解析失败信号而非通过（09-04）。
- **候选窄提案（计数观察中）**：① `.ai/` 本地目录 gitignore 覆盖提示级检查（08-13 + 08-31 两次实证，第三次复发再立案）；② md-clean cwd 敏感空跑通过（09-04 首次实证，脚本 fail-closed 或标注适用目录，跨派生通用，待复发再判断是否立案）。
- **不回流**：09-03 的编码教训与 09-04 的 cwd 口径均属执行纪律，单条 + 本 SUMMARY 记录即可。
