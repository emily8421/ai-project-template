# TEMPLATE-UPGRADE: Issue 提案收件箱与维护者 triage 场景

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：已处理并归档；`change/issue-proposal-triage-flow` 补齐模板侧接收 GitHub issue 提案的场景路由与自检断言。
> 覆盖问题：派生项目可通过 `submit-proposal` / `submit-feedback` 把提案提交到模板仓 issue，但模板维护者 C1 / command / governance 文档仍偏向 `_proposals/` 文件收件箱，容易漏处理 issue 中的 `TEMPLATE-UPGRADE` 提案，尤其是未打 `proposal` / `feedback` 标签的 issue。

## 1. 背景与问题

当前派生侧已有 A15：成熟提案或反馈可通过 `submit-proposal` / `submit-feedback` 跨仓库开 GitHub issue，避免成员必须 fork 或直接提交模板仓分支。

模板侧已有 `ai/prompts/maintainers/11-template-proposal-summary.md`，其中要求读取带 `proposal` / `feedback` 标签的 issue；但上层入口仍存在缺口：

- `template-docs/scenario-guides.md` 的 C1 标题和说明只强调 `_proposals`。
- `ai/commands/template-proposal-summary.md` 适用场景和必读文件只列 `_proposals/TEMPLATE-UPGRADE-*.md`。
- `CONTRIBUTING.md` 与 `_proposals/README.md` 仍把模板仓 `_proposals/` 文件作为主要上行收件箱，未明确 GitHub issue 收件箱与本地文件收件箱的关系。
- 如果 issue 未打 `proposal` / `feedback` 标签，但标题是 `TEMPLATE-UPGRADE:`，现有维护流程容易漏读。

## 2. 设计目标

- 把 GitHub issue 作为模板侧提案收件箱的一等入口。
- C1 明确同时处理 `_proposals/` 文件、带 `proposal` / `feedback` 标签的 issue、以及标题为 `TEMPLATE-UPGRADE:` 的 open issue。
- 明确 triage 流程：补标签、去项目化审查、去重 / 冲突 / 依赖分析、实施后关闭 issue。
- 不改变派生侧 A15 的提交方式；只补模板侧接收与处理机制。

## 3. 拟改范围

- 修改 `template-docs/scenario-guides.md`：C1 改为“处理提案收件箱”，说明 issue 提案入口和 triage 步骤。
- 修改 `ai/commands/template-proposal-summary.md`：适用场景、必读文件和执行流程加入 GitHub issue 查询。
- 修改 `CONTRIBUTING.md`：说明上行可走 issue 或 `_proposals/` 文件；issue 处理后关闭。
- 修改 `_proposals/README.md`：说明本目录与 GitHub issue 收件箱的关系。
- 修改 `scripts/check-template.sh`：增加断言，防止 C1 / command / governance 回退成只读 `_proposals/`。
- 更新 `VERSION` / `CHANGELOG.md`。

## 4. 版本影响

建议作为 patch 版本：这是维护流程与文档路由增强，不改变下游文件结构或同步机制。

## 5. 验收口径

- C1 明确包含 GitHub issue 提案收件箱。
- `template-proposal-summary` 命令明确读取 `proposal` / `feedback` 标签 issue 和 `TEMPLATE-UPGRADE:` open issue。
- 治理文档说明 issue 与 `_proposals/` 文件收件箱的关系。
- 自检脚本含关键断言。
- `git diff --check` 与模板自检通过。

## 6. 风险与缓解

- **未打标签 issue 被漏读**：要求同时按标签和 `TEMPLATE-UPGRADE:` 标题扫描。
- **issue 与本地提案重复**：C1 必须做去重 / 冲突 / 依赖分析，并在 PR 中引用或关闭已处理 issue。
- **issue 含敏感信息**：triage 先做去项目化审查，不能直接复制敏感内容进模板文件。
