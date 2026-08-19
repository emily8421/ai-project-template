# Pitfall 汇总：2026-08-11 ~ 2026-08-19

> 生成于 2026-08-13（rollup，session-rules §4.3，首次创建）；2026-08-15 第二次扩展纳入第二批 5 份；2026-08-19 第三次扩展纳入第三批 3 份。本目录只保留 SUMMARY.md + summaries/；单条原始记录在本地 `.ai/pitfalls/`（gitignore，不询问不上传）。从单条脱敏提炼，剔除 token / 密钥 / 账号 / 对话正文 / 项目敏感细节。

## 0. 覆盖边界

- 已覆盖记录（本地 `.ai/pitfalls/`）：第一批 6 份（2026-08-11 ~ 08-13）+ 第二批 5 份（2026-08-13 后半 ~ 08-15）+ 第三批 3 份（2026-08-16 ~ 08-19）= **14 份**。
- 未覆盖记录：无（截至 2026-08-19 本地全部已纳入）。
- 下一次 rollup 起点：从 **2026-08-20** 起，只统计 `汇总状态：未汇总` 的本地新记录。
- 计数口径订正：首批 rollup 时漏计 `2026-08-13-serial-check-template-timeout.md`（旧记录无「汇总状态」字段，当时未被识别为未覆盖），本次一并收编。

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
