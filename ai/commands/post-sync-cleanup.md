# Command: post-sync-cleanup

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

## 用户说法

- `/run post-sync-cleanup`
- 同步后整理项目
- 方法论同步后清理
- 整理项目专属内容

## 适用场景

派生项目完成模板方法论同步后，需要审计 docs 分区、README、project-rules 与运行环境约束。

## 必读文件

- `ai/index.md`
- `docs/README.md`
- `ai/project-rules.md`
- `docs/env/local-env.md`（如存在）
- `_governance/sync-records/template-sync/` 下最近一次同步运行记录（推荐路径，如存在）
- `docs/archive/template-sync/` 下旧版同步运行记录（兼容读取，如存在）
- `ai/doc-standards/README.md`（如需要理解规范镜像定位）
- `ai/prompts/maintainers/15-post-sync-cleanup.md`

## 执行流程

1. 确认已完成 `sync-methodology` 或等价同步流程。
2. 检查工作区状态和最近同步提交。
3. 如存在同步运行记录，优先读取 `_governance/sync-records/template-sync/`，兼容读取旧路径 `docs/archive/template-sync/`，提取问题、待确认项和可回流优化点。
4. 审计项包含「§3 裁剪决策 vs 目录结构一致性」：`ai/project-rules.md` §3 声明不启用 / 省略的目录或骨架文档（`project/frontend/`、`project/backend/`、`project/tests/`、`project/docker/`、`docs/06`、`docs/07`）仍以占位形态存在时，提示按 `ai/doc-standards/project-rules.md` §3 裁剪执行步骤补执行；该审计不限同步后，普通项目自查同样适用。
5. 审计项包含「准入清单外点目录」：根目录出现 `ai/global-rules.md` §5 点目录准入清单之外的点目录（含空目录）时，逐个列出并核对三问——谁创建的 / 还在用吗 / 该收容（gitignore）还是该删；空目录必删或必溯源，不留幽灵目录；`.ai/` 根部堆文件、无点 `tmp/`、任务级临时目录遗留同属本审计命中。该审计不限同步后，普通项目自查同样适用。
4a. 审计项包含「模板仓专用脚本残留」（v1.65.0 起）：`scripts/` 中存在 `check-template.*` / `sync-all-derived.sh` / `e2e-sync-check.sh` / `new-project.sh` 时提示可安全删除（已移出同步清单的模板仓专用工具，删除无需回填字段）；细则见 `ai/prompts/maintainers/15-post-sync-cleanup.md`。
4b. 审计项包含「模板仓 / 领域专用文档残留」（v1.66.0 起）：`template-docs/` 中存在 `e2e-regression-checklist.md` / `e2e-report-template.md` / `rd-data-chain.md` / `domain-derived-scenarios-template.md` 时提示可安全删除（同脚本残留口径）；细则见 `ai/prompts/maintainers/15-post-sync-cleanup.md`。
4c. 审计项包含「template-docs 旧路径残留」（v1.66.0 目录重组）：19 个文件迁入 `profiles/` / `templates/` / `maintainer/` 子目录后，派生项目根目录的旧路径副本不再被覆盖、与新路径重复，提示可安全删除；细则见 `ai/prompts/maintainers/15-post-sync-cleanup.md`。
4d. 审计项包含「目录布局变更挂接」（v1.68.0 起）：本次同步引入目录布局变更（如 `project/` / `_governance/` 容器标准化）时，提示挂接 `template-docs/root-reorg-execution-checklist.md`（根目录重组执行层核对清单：12 类载体 + 三段验证纪律），迁移收口按其核对。
5. 使用 `15-post-sync-cleanup` 先输出审计结果与迁移计划，并标注哪些问题应回写同步报告。
6. 用户确认后再执行移动、修改或补齐。
7. 输出变更清单、待复核链接、验证建议、同步报告更新建议和是否需要生成模板优化提案。

## 写入风险

可能移动或修改项目专属文档；执行实际修改前必须确认。

## 续接要求

迁移计划、同步运行记录中的问题、待确认项、同步报告回写建议和可回流提案建议必须写入续接文件，避免中断后丢失。
