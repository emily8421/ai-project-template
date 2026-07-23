# Token Hotspot 记录：check-template 失败诊断增强 + PR #244 闭环

> 日期：2026-07-22
> 任务类型：模板维护（check-template 失败诊断增强，patch v1.56.2）+ PR/CI 闭环（commit / push / PR / squash merge / 分支清理）
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入模板维护 + PR/CI 闭环长任务；读完整规则包 + 多个大文件 + 多次 git/gh + CI 轮询）
> 汇总状态：已纳入 SUMMARY.md

## 热点工作

- **续接与规则路由**：快速续接读 Git 事实（无 `.ai/session-handoff.md`，判 missing）；升级执行后按 `ai/index.md` 路由读 `rules-core.md`；模板维护 / 自检脚本变更补读 `CONTRIBUTING.md`、`git-guide.md`（§1.1 / §1.2 / §3.1 / §4 / §5.7）、`template-sync.json`、`ai/project-rules.md` §6、`_proposals/README.md`、归档提案样本 `TEMPLATE-UPGRADE-scripts-self-check-maintainability.md`、`CHANGELOG.md` 头部。
- **验证诊断（高成本往返）**：`check-template.ps1` 在 PowerShell 5.1 下因 git LF/CRLF warning → stderr → `NativeCommandError` 提前终止（**非断言失败**）；`check-template.sh` 完整本地跑 >2min 超时（卡在 `require_new_project_local_smoke`，**既有 smoke test，非本次引入**）；改用 grep 等价验证 5 条新断言（PASS）。
- **本地写入**：新增提案（59 行，直接归档）、VERSION v1.56.1→v1.56.2、CHANGELOG v1.56.2 条目、check-template.ps1/.sh 失败诊断增强（+22/-2）。
- **PR/CI 闭环**：stash → 切 main → 新分支 → pop；`check-markdown-clean.ps1` 预检（33 文件 OK）；`check-github-context.ps1` 预检（ADMIN / scopes OK，warning=未跟踪文件）；push（直连成功）；`gh pr create` #244（--fill）；CI `template-check` pass(17s)；`gh pr merge --squash --delete-branch`；`git fetch --prune` + `gh api` 404 确认远端分支已删。

## 热点判断

- **主要成本**：① 规则门禁读取（模板维护按路由读 6+ 规则 / 文档全文，CONTRIBUTING / git-guide 较长）；② check-template 两次失败的诊断（PowerShell stderr 包装 + new-project smoke 超时，各耗一次完整运行 + 静态分析定位根因）；③ 归档提案目录 Glob 返回 90+ 文件名（定位 patch 级格式样本）。
- **输出控制**：规则按任务路由定向读（未预读全 `ai/`）；check-template 验证改用 grep 等价（避免反复跑卡住的完整脚本）；git/gh 输出用 exit code + 关键行摘要；CI 只查一次（17s 即 pass）；归档 Glob 后只读 1 份样本。
- **远端风险点**：push + PR + merge + 删分支，均单步确认（用户三次 `AskUserQuestion` 授权：push / PR / 合并）；直连 GitHub 网络（fetch / push / gh 均直连成功，**未实际启用代理 7897**）。
- **不确定性控制**：本地 check-template 卡住严格归因到 `require_new_project_local_smoke`（既有逻辑），不臆断为本次断言问题；grep 等价验证 + CI 兜底双保险；未跟踪文件全程不纳入任何 commit。
- **总量级**：medium-high（规则门禁 + 失败诊断往返 + 完整 PR/CI 闭环 + 分支清理 + hotspot 记录）。

## 质量影响

- **正向**：改动主题与 C1 triage 分支隔离（单独 fix 分支 + PR）；实现 + 5 自检断言 + 提案 + 版本 + CHANGELOG 一致；CI 权威验证通过；分支及时清理（本地 + 远端 404 确认）。
- **风险控制**：5 条新断言锁定失败输出（防回归）；`check-template.ps1` fallback 不镜像（既定边界保持）；提案去项目化归档；Co-Authored-By trailer 按 Claude Code 指示加入本地 commit。
- **附带发现**：`check-template.sh` 本地 Windows 完整运行受 `require_new_project_local_smoke` 阻塞（>2min），既有环境问题，值得后续评估（独立议题，已记入提案「非目标」+ SUMMARY「模板回流判断」）。

## 优化建议

- **规则读取**：模板维护 + PR 闭环的规则门禁（CONTRIBUTING + git-guide + template-sync + project-rules + proposals）可压缩为「PR 闭环 checklist」速查，减少每次全文重读。
- **check-template 本地可用性**：`require_new_project_local_smoke` 在 Windows 慢，可评估加超时跳过 / 标记 CI-only（独立提案候选）。
- **PowerShell stderr 陷阱**：`check-template.ps1` 在 `$ErrorActionPreference=Stop` + native stderr 下脆弱，本次以 Bash 工具绕开；可考虑脚本内 `2>$null` 或宽松 ErrorActionPreference。
