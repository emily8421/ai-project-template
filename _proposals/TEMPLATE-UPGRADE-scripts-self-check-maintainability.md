# TEMPLATE-UPGRADE: scripts 说明与模板自检可维护性

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：部分落地；v1.26.2 已完成 scripts 说明与 fallback 权威边界，v1.27.4 已完成 `check-template.sh` 小步分组整理与重复断言收敛；是否拆分 `scripts/checks/*.sh` 留待后续评估。
> 覆盖问题：scripts README 说明不全；`.sh` / `.ps1` 关系不清；`check-template.sh` 体积与自检体系可维护性。

## 0. 落地状态（2026-07-04）

已随 `change/scripts-self-check-v1.26.2` 主体落地：

- `scripts/README.md` 补齐 `e2e-sync-check.sh` / `sync-all-derived.sh`，并补充运行位置、读写边界和使用者。
- `scripts/README.md`、`SOP.md`、`MAINTAINERS.md` 明确 `.sh` / `.ps1` 主从关系与 fallback 权威边界。
- `scripts/check-template.ps1` fallback 输出明确“非完整权威检查”。
- `CHANGELOG.md` 与 `VERSION` 已更新到 `v1.26.2`。

尚未落地，保留后续排期：

- 是否拆分为 `scripts/checks/*.sh` 并由 `check-template.sh` 作为总入口调度。

已随 `change/check-template-maintainability` 小步落地：

- `scripts/check-template.sh` 增加结构说明，区分基础 helper、专项检查函数与主流程分组。
- 新增 `require_files` helper，将 scripts 文件存在性断言改为列表式调用。
- 新增 `check_script_entrypoints`，集中维护 `.ps1` 入口、fallback 与权威边界断言。
- 新增 `check_project_bootstrap_scripts`，集中维护 `new-project`、环境采集、前置检查与 bootstrap 断言。
- `CHANGELOG.md` 与 `VERSION` 更新到 `v1.27.4`。

因此本提案暂不归档；若后续决定把已完成部分归档，应先拆出新的 `TEMPLATE-UPGRADE-*check-template-maintainability.md` 承接未完成项。

## 1. 背景与问题

当前 `scripts/` 已承担新建项目、模板同步、派生边界检查、模板完整性自检、环境采集、一键安装、批量同步等任务。

已观察到以下问题：

- `scripts/README.md` 中脚本说明不完整，漏列 `e2e-sync-check.sh` 与 `sync-all-derived.sh`。
- `scripts/README.md` 没有清楚解释 `.sh` 与 `.ps1` 的关系，容易被误解为冗余双轨。
- `check-template.sh` 约 980 行，包含大量结构断言、同步清单校验、doc-standards 镜像检查、示例项目检查和防滞后检查，单文件继续增长会降低维护性。
- PowerShell fallback 是实用兜底，但并不等价于 Bash 权威检查；如说明不清，用户可能误把 fallback 通过理解为完整模板自检通过。

## 2. 判断结论

`.sh + .ps1` 双入口总体合理，不建议简单删除其中一类：

- `.sh` 适合作为主实现 / 权威逻辑，便于 CI、Git Bash、类 Unix 环境复用。
- `.ps1` 是 Windows 用户友好入口，优先委托 Git Bash，Git Bash 无法从 PowerShell 启动时才走 native fallback。
- 该设计降低 Windows 环境问题对模板使用的阻断。

真正需要优化的是说明、边界提示和自检脚本可维护性，而不是取消双入口。

## 3. 建议方案

### 3.1 短期：补齐 `scripts/README.md`

建议补充：

- `e2e-sync-check.sh`：端到端同步检查脚本。
- `sync-all-derived.sh`：维护者批量同步多个派生项目。
- `.sh / .ps1` 入口关系：`.sh` 为主实现，`.ps1` 为 Windows 包装入口，优先委托 Git Bash，fallback 仅为兜底。
- 哪些脚本在模板仓运行，哪些在派生项目运行，哪些在父目录运行。
- 哪些脚本只读，哪些会写入文件 / 提交。

### 3.2 中期：整理 `check-template.sh`

建议分阶段优化，不一次大重写：

1. 先按函数分组并加目录式注释：入口文件、文档标准、命令路由、同步清单、脚本、示例项目、派生烟测。
2. 将历史 PR 来由型长注释压缩为稳定机制说明，详细历史留给 `CHANGELOG.md`。
3. 把重复断言模式抽成表驱动数组，减少连续 `require_contains` 长列表。
4. 评估是否拆成 `scripts/checks/*.sh`，由 `check-template.sh` 作为总入口调度。

### 3.3 明确 fallback 权威边界

建议在 `check-template.ps1` 输出、`scripts/README.md` 和 `MAINTAINERS.md` 中明确：

- Bash `check-template.sh` / CI 是完整权威模板自检。
- PowerShell native fallback 是结构性兜底检查，用于 Git Bash 无法启动时提供最低保障。
- fallback 通过不等价于完整自检通过；发布前仍应以 CI 或 Bash 自检为准。

## 4. 拟改范围

- 修改：`scripts/README.md`
- 修改：`scripts/check-template.sh`
- 修改：`scripts/check-template.ps1`
- 修改：`MAINTAINERS.md`
- 修改：`SOP.md`
- 修改：`template-docs/scenario-guides.md` C3 / C5 / C8 相关说明（如适用）
- 修改：`scripts/check-template.sh` 自检断言，确保 README 覆盖脚本清单与 fallback 说明

## 5. 版本影响

建议分两步：

- README 与 fallback 说明补齐：patch 版本即可。
- `check-template.sh` 结构性拆分或新增 `scripts/checks/`：minor 或 patch，取决于是否改变维护者工作流。

## 6. 验收口径

- `scripts/README.md` 覆盖 `scripts/` 下所有非占位脚本。
- 用户能从 README 判断每个脚本在哪里运行、是否写入、是否模板仓专用。
- README 明确 `.sh` / `.ps1` 主从关系。
- `check-template.ps1` fallback 输出明确“非完整权威检查”。
- `check-template.sh` 至少完成分组整理，后续新增断言有明确落位。
- 模板自检仍通过。

## 7. 风险与缓解

- **过早模块化引入脚本路径复杂度**：先做分组和表驱动，确认收益后再拆文件。
- **fallback 说明打击 Windows 用户信心**：措辞强调 fallback 是可用兜底，但发布 / CI 以完整检查为准。
- **自检断言过度绑定文案**：新增检查优先使用稳定关键词，不绑定长段落。
