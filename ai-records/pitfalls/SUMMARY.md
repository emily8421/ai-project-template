# Pitfall 汇总：2026-08-11 ~ 2026-08-13

> 生成于 2026-08-13（rollup，session-rules §4.3，首次创建）。本目录只保留 SUMMARY.md + summaries/；单条原始记录在本地 `.ai/pitfalls/`（gitignore，不询问不上传）。从 6 份单条脱敏提炼，剔除 token / 密钥 / 账号 / 对话正文 / 项目敏感细节。

## 0. 覆盖边界

- 已覆盖记录（本地 `.ai/pitfalls/`，6 份）：2026-08-11 ~ 08-13 全部单条。
- 未覆盖记录：无（截至 2026-08-13 本地全部已纳入）。
- 下一次 rollup 起点：从 **2026-08-14** 起，只统计 `汇总状态：未汇总` 的本地新记录。

## 1. 汇总范围（6 份）

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

- **应沉淀（转提案）**：本地落地前补跑 `check-markdown-clean.ps1 _proposals ai-records`——纳入 `check-template.ps1` 预检或写进 implementation-lifecycle / remote-ci-sop-profile 本地验证清单（08-11 + 08-13 双实证）。
- **应沉淀**：`.gitignore` 补 `.ai/tmp-*` 或 commit message 用 stdin heredoc（08-12 `.ai/tmp`）。
- **应沉淀**：`remote-ci-sop-profile §E` 补「`--delete-branch` 已含本地 + 远端清理，勿重复手动删」（08-12 merge）。
- **应沉淀**：Windows PowerShell 下 apply_patch 不可用 → 用 `[System.IO.File]::WriteAllText`（UTF-8 无 BOM）落盘（08-12 apply_patch）；可向上游反馈包装器问题。
- **行为约束**：远端 pending / terminated 命令的零结果不可信，独立交叉核对（08-12 timeout）。
- **保留本地**：已纳入 SUMMARY 的单条可标「已纳入」后归档 `.ai/pitfalls-archive/`。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案）

- **最值得转提案**：check-markdown-clean 覆盖缺口（08-11 + 08-13 同类，2 次实证 + 跨派生通用）→ `_proposals/TEMPLATE-UPGRADE-local-preflight-coverage.md`（本次已起）。
- **次优先**：`.ai/tmp` gitignore + commit heredoc；`gh --delete-branch` 勿重复删。
- **项目专属**（Windows apply_patch）：留 `git-guide.md` / SOP 提示，不必单立模板提案。
