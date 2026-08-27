# 提案：派生项目初始化裁剪补全——模板仓自留内容不随 new-project 复制下行

> 来源：模板维护者（模板仓自产提案，2026-08-27 会话评估产出）
> 状态：**已落地 v1.70.0（PR #409 squash `e24be21`，2026-08-27）**；原拍板：用户 2026-08-27——①按 A 清单立项；②`CONTRIBUTING.md` 保留下行；③赶在 6 仓 v1.69.0 同步窗口前落地，窗口目标版本顺升 v1.70.0。

## 1. 动机

`scripts/new-project.sh` 采用「`git archive HEAD` 全量复制 + 显式删除清单」机制（黑名单裁剪，非白名单复制）。v1.65.0 删 5 个模板仓专用脚本、v1.66.0 删 `template-docs/maintainer/` 4 件后，仍有三类「模板仓自留内容」随全量复制进入每个新派生项目首提交：

| # | 条目 | 问题 | 实证（flowkit，2026-08-19 建、08-26 同步 v1.67.1 后复查） |
|---|---|---|---|
| 1 | `docs/research/` 母仓治理调研报告（当前 13 份） | 母仓评估记录进新项目首提交；AI 协作时可能误读为项目材料（撞「历史归档不作依据」边界） | 残留 2 份 2026-08-12 母仓 triage 报告 |
| 2 | `docs/archive/e2e/` 母仓 e2e 归档 | 同类历史包袱 | 残留 `e2e/` |
| 3 | `MAINTAINERS.md`（17KB） | 自述「普通派生项目使用者……不用读本文件」；纯维护者手册；且在 `files_all` 中每次同步覆盖派生仓（new-project 带入 + sync 覆盖双场景污染） | 残留且 08-26 同步时被覆盖至最新版 |
| 4 | `.github/ISSUE_TEMPLATE/`（`template-change.md` + `derived-feedback.md`） | 模板仓收件箱表单（表头写明「向 ai-project-template 模板仓库反馈」）；带进派生项目后其 GitHub 出现错误的 issue 入口 | 残留 |
| 5 | `.github/pull_request_template.md` | 模板治理 PR 检查单（提案归档 / VERSION 递增 / check-template / 下行同步四项），对派生项目 PR 无意义 | 残留 |

`docs/research/`、`docs/archive/` 是 `docs/README.md` 定义的正式分区，派生项目自用分区应保留——正确口径是**清空母仓内容 + 重建种子 README**（与 `new-project.sh` 对 `_governance/` 5 分区种子的既有做法同款），不是取消分区。

## 2. 拟改（7 项）

1. **`scripts/new-project.sh` 黑名单扩展**：
   - `rm -rf docs/research docs/archive` → 重建目录 + 种子 README（描述对齐 `docs/README.md` 分区表）；
   - `rm -f MAINTAINERS.md`；
   - `rm -rf .github/ISSUE_TEMPLATE` + `rm -f .github/pull_request_template.md`（保留 `project-check.yml`）；
   - 尾部完成提示同步说明裁剪范围。
2. **`template-sync.json`**：`files_all` 移除 `MAINTAINERS.md`；`description` 补「根级文档与仓库配置」边界说明。
3. **`scripts/sync-template.sh`**：兜底数组 `DEFAULT_SYNC_FILES` 同步移除 `MAINTAINERS.md`（`sync-template.ps1` 从 json 读取，无需改）。
4. **`ai/session-rules.md` §3.4「同步覆盖件保护」**：从覆盖件清单移除 `MAINTAINERS.md`，注明其为模板仓专用、存量残留走 post-sync-cleanup。
5. **`MAINTAINERS.md` §4 增补一条边界**（v1.70.0 起）：`MAINTAINERS.md` / `.github` 收件箱件 / `docs/research`、`docs/archive` 母仓内容均为模板仓自留，不随 new-project 复制；存量残留随 post-sync-cleanup 清理（同 4a/4b 口径）。
6. **post-sync-cleanup 审计扩展**（`ai/commands/post-sync-cleanup.md` + `ai/prompts/maintainers/15-post-sync-cleanup.md` 新增审计项 4e）：存量派生仓检测四类残留——`MAINTAINERS.md`、`.github/ISSUE_TEMPLATE/*`、`.github/pull_request_template.md`、`docs/research|archive` 中与母仓同名的治理记录——提示可安全删除；判定口径 = 与模板仓当前文件名对照。
7. **`scripts/check-template.sh` / `.ps1` 烟测断言扩展**：`require_absent_file` 五项（MAINTAINERS / PR 模板 / issue 模板 ×2）+ `docs/research`、`docs/archive` 仅含种子 README（`.md` 计数 == 1）。

## 3. 版本影响

**MINOR：v1.69.0 → v1.70.0**。派生初始化行为与同步清单变更属能力增强，非兼容性修复。落地后 6 仓同步窗口目标版本由 v1.69.0 顺升 v1.70.0（一趟携带 v1.68.0+v1.69.0+v1.70.0）。

## 4. 影响面与验证

- **修改文件**：上列 7 项 + `VERSION` + `CHANGELOG.md` / `CHANGELOG-PLAIN.md` + 本提案。
- **不受影响**：
  - `CONTRIBUTING.md` 维持下行（已拍板；§2 三方向文件流、§5.1 跨仓发起目录被派生仓会话与 `ai/session-rules.md` §3.4 实际引用）；
  - `docs/README.md` 分区定义不变（分区保留，仅初始化不带母仓内容）；
  - `check-template` 对模板仓自身 `MAINTAINERS.md` / `.github` 件的断言不变（模板仓文件保留在位）；
  - `check-derived-sync` 从 `template-sync.json` 动态解析清单，json 修改后自动一致。
- **验证**：`check-template.sh` + `.ps1` 全绿（内建 new-project 烟测即 smoke 验证，含新增断言）；`bash -n` 语法检查；`check-markdown-clean` 本轮改动 md 文件。
- **存量清理**：本机 5 仓（agent-system-template / digital-cs-demo / zhiyan / LUMEN-DEMO / flowkit）随 v1.70.0 同步窗口的 post-sync-cleanup 4e 一趟清理（先例：digital-cs v1.67.0 同步曾清 24 件模板仓残留）。

## 5. 与既有规则 / 提案关系（去重）

- **v1.65.0 脚本同步边界 + v1.66.0 template-docs 边界**（`MAINTAINERS.md` §4）：本提案是同类边界的第三批（根级文档 + `.github` 收件箱件 + `docs/` 自留内容），延续既有「模板仓专用 → 不进清单 + new-project 裁剪 + post-sync-cleanup 审计」三层模式，无重叠。
- **v1.69.0 点目录治理（原 #400 提案）**：正交——点目录管根级命名空间准入（该有什么点目录），本提案管「初始化复制什么下去」。
- **v1.69.0 #374 文件治理三层**：正交——职责表管文件归属层与阈值信号，不涉及初始化复制行为。
- **根 `README.md` 不下行（既有规则）**：本提案补齐其余根级文档的同类判定，`MAINTAINERS.md` 归入「模板仓专用」一侧。
