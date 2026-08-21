# TEMPLATE-UPGRADE：测试基础设施 PR-7（v1.24.1）

> 去项目化提案。覆盖用户诉求 #9（最小测试清单 + 回归机制 + 专用测试派生项目 + 报告）。v1.24 infrastructure release 第 2 个 PR（收官）。

## 动机

模板无 L3 端到端回归机制——每次大改（MINOR/MAJOR）后，同步链路、批量同步、场景引导、文档生成、PowerShell fallback 等端到端能力靠人工记得跑，易漏。需可自动化回归 + 人工清单 + 报告 + 发布门。

## 拟改

- **`template-docs/e2e-regression-checklist.md`**（template-local）：L3 回归 6 项（R1 同步链路 / R2 check-derived-sync / R3 sync-all-derived 批量 / R4 场景引导路由 / R5 文档生成 / R6 PowerShell fallback）+ 如何建专用测试派生项目 `ai-project-template-e2e` + 通过标准。
- **`scripts/e2e-sync-check.sh`**（template-local）：L3 发布门，聚合 `check-template`（含 doc-standards 镜像自检 + 新项目烟测 + 同步清单一致性）+ `sync-all-derived` 批量烟测；不重复 check-template 内部测试，只做发布门聚合 + 批量烟测。人工项指向 checklist。
- **`template-docs/e2e-report-template.md`**（template-local）：回归报告模板（自动化项 + 人工项 + 问题 + 结论）。
- **`MAINTAINERS` 发布 Checklist 补**：MINOR/MAJOR 发布前跑 L3 + 报告确认（PATCH 豁免）。
- 专用测试派生项目 `ai-project-template-e2e` 是**外部 repo**（维护者建），模板仓内只给文档 + 命令。

## 版本影响

- v1.24.0 → v1.24.1（PATCH：测试基建，不改用户可见行为；用户选 PATCH）。
- 新增 5 条 check-template 断言；`e2e-sync-check.sh` 运行通过（check-template + 批量烟测）。

## 影响面

- 非同步件：`e2e-regression-checklist.md`、`e2e-sync-check.sh`、`e2e-report-template.md`（template-local）。
- 同步件：`MAINTAINERS.md`（发布 Checklist 补 L3）。
- 不影响：同步机制、`template-sync.json`、现有脚本行为、规则正文。

## 落地流程

从 main（v1.24.0）切分支 `change/test-infra-pr7-v1.24` → 写 3 文件 + MAINTAINERS 补 + check-template 断言 → `e2e-sync-check.sh` 运行通过 → VERSION/CHANGELOG/提案 → PR-7。**#1–#16 + #9 全部完成。**
