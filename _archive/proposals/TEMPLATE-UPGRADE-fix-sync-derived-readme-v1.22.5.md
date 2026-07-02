# TEMPLATE-UPGRADE: 修复 sync/check-derived-sync + 派生 README 规范（v1.22.5）

> 状态：草案（待维护者评审）
> 提案目标版本：v1.22.5
> 提出日期：2026-07-02
> 维护分支：`change/fix-sync-derived-readme-v1.22.5`
> 来源：`zhiyan-digital-cs-platform` 端到端验证发现的灰色地带

## 1. 动机

端到端验证（派生项目同步 v1.22.4）发现 check-template 抓不到的问题：

- **#1 sync-template.ps1 PowerShell fallback Null bug**：`sync-template.ps1 --dry-run` 报「不能对 Null 值调用方法」（v1.21.3 与 v1.22.4 都有）。bootstrap 最新 + Bash 入口（`sync-template.sh`）可绕过，但 PowerShell fallback 本身的 Null bug 值得修。
- **#2 check-derived-sync 工作区干净过严 + 误导提示**：派生项目有未跟踪的项目输入（`docs/inputs/` 用户材料），触发行 70「工作区不干净」fail；行 131 失败提示固定输出"scripts/check-template"，与真实失败原因（工作区不干净）无关，误导。同步提交本身边界正确。
- **派生 README 规范缺失**：模板 README 不同步到派生（派生写自己的说明），但派生 README 也应含「简介 / 能力 / 快速开始 / 目录速览」等结构（内容是派生自己的）；当前无明确规范指导 `new-project.sh` 生成 + sync 维护。

## 2. 拟改

### 2.1 修 sync-template.ps1 PowerShell fallback Null bug（#1）
- 定位 fallback（`Invoke-NativeTemplateSync`）里的 Null 根因（疑似 Git Bash 启动失败后某变量未初始化）。
- 修复 + 加防御性判空。

### 2.2 修 check-derived-sync（#2）
- 行 70 工作区干净检查：放宽——未跟踪的项目内容（`docs/`、`tasks/` 等项目产物）不触发 fail；只关心同步提交（HEAD）的变更边界。或改为 warning。
- 行 131 提示精准化：失败时输出真实失败项，不再固定"scripts/check-template"。
- 同步改 `check-derived-sync.ps1`（PowerShell fallback 版）。

### 2.3 派生 README 规范
- 在 `MAINTAINERS.md`（README 边界）明确派生 README 的 section 结构（简介 / 它能做什么 / 快速开始 / 当前阶段 / 目录速览 / 文档入口 / 模板关系 等）+ 内容约束（派生项目自己的说明，不照搬模板）。
- `scripts/new-project.sh` 的 README 模板更新：对齐规范（含「它能做什么」能力段占位，提示派生项目填写自己的能力）。
- README 仍不同步（项目专属），规范在模板，`new-project` 生成 + sync 维护（人工/AI 依据规范补充）依据。

## 3. 非目标
- 不改同步机制（只修 bug + 放宽检查）。
- 不把模板 README 同步到派生（仍项目专属）。

## 4. 影响
`scripts/sync-template.ps1` / `scripts/check-derived-sync.sh` / `scripts/check-derived-sync.ps1` / `MAINTAINERS.md` / `scripts/new-project.sh` / `VERSION` / `CHANGELOG.md`；提案归档。
