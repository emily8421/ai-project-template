# TEMPLATE-UPGRADE：派生同步续接模式与 GitHub 远端操作前预检

> 来源：模板维护者。
> 本提案为去项目化模板优化提案，不记录个人账号、邮箱、token、本机路径或派生项目业务细节。

## 1. 背景与问题

派生项目同步模板方法论时，旧版本项目可能只执行了 `sync-template` 同步提交，但没有继续完成后续边界验证、同步后整理、文档体系审计、项目验证建议和同步运行记录。由于完整同步闭环是后续模板版本才补强的，旧派生项目在拿到新版流程前，AI 不一定知道同步后还要继续执行这些步骤。

同时，在模板仓库和多个派生项目并行打开、多个 AI CLI / 终端并行工作时，远端操作前容易混淆当前仓库、分支、remote、Git 提交身份、`gh` 活跃账号和仓库权限。GitHub CLI 授权、OAuth scope、SSO 授权和 Git Credential Manager 属于本机配置问题，模板不能代替授权；但模板可以提供只读预检机制，降低 push / PR / merge 前的误操作风险。

## 2. 目标

1. 将旧派生项目首次同步纳入 A13 场景，明确先 bootstrap 最新同步脚本，再继续完整同步闭环。
2. 为“已完成同步提交但后续未跑”的项目提供 A13 同步后续接模式，避免重复 dry-run / commit。
3. 让同步脚本提交成功后直接提示后续闭环步骤，避免用户停在同步提交。
4. 增加 GitHub 远端操作前只读预检机制，帮助确认 cwd、remote、分支、Git 身份、`gh` 登录和仓库权限。
5. 将新增机制纳入下行同步清单和模板自检，确保派生项目可获得并持续验证。

## 3. 拟改范围

### 3.1 A13 同步流程补强

- `template-docs/scenario-guides.md`
  - A13 前置条件改为覆盖旧派生项目首次同步。
  - 增加“同步后续接模式”触发词和说明。
  - 明确已存在 `sync template vX.Y.Z from ai-project-template` 提交时，不重新执行 dry-run / commit，从边界验证开始补完后续。
- `ai/prompts/maintainers/12-sync-template.md`
  - 增加同步后续接模式识别。
  - 先读取 Git 客观事实、`VERSION` 和最近同步记录。
  - 确认已同步且只补后续时，跳过同步步骤，直接进入边界验证、workflow 检查、整理、审计、验证建议和同步记录。
- `ai/commands/sync-methodology.md`、`ai/commands/README.md`、`SOP.md`、`git-guide.md`
  - 增加自然语言入口和操作说明。
  - 明确旧派生项目 bootstrap 后不能停在同步提交。
- `scripts/sync-template.sh`、`scripts/sync-template.ps1`
  - `--commit` 成功后打印后续闭环步骤。

### 3.2 GitHub 远端操作前预检

- 新增 `scripts/check-github-context.ps1`
  - 只读输出 repo root、branch、origin、Git 提交身份、工作区状态、`gh auth status` 和 `gh repo view` 权限。
  - 支持 `-ExpectedOwner` / `-ExpectedRepo` 做目标仓库校验。
  - 出现未提交改动、`gh` 未安装 / 未授权、`gh repo view` 失败、owner / repo 不符时返回 warning，提醒停止远端操作。
- `git-guide.md`
  - 新增 GitHub 操作前预检小节，覆盖 push / PR / merge / tag / release。
  - 明确该预检不能替代 GitHub 授权，只提供操作前门禁。
- `SOP.md`
  - 增加远端操作前预检入口和常用命令。
- `ai/commands/commit-message.md`、`ai/prompts/git/06-commit-message.md`
  - 在准备 push / PR / merge 前提醒运行预检。

### 3.3 同步与自检接入

- `template-sync.json`
  - 将 `scripts/check-github-context.ps1` 加入派生项目下行同步清单。
- `scripts/sync-template.sh`
  - 将新脚本加入兜底同步清单。
- `scripts/check-template.ps1`、`scripts/check-template.sh`
  - 增加新脚本存在性、同步清单和文档入口断言。

## 4. 版本影响

建议作为 PATCH 或 MINOR 版本发布，取决于维护者对“新增 GitHub 预检脚本 + 同步流程续接模式”的能力级别判断：

- PATCH：若视为既有同步流程的修复和安全提示增强。
- MINOR：若视为新增可复用操作能力，尤其是 `scripts/check-github-context.ps1`。

建议倾向 MINOR，因为新增了下行同步脚本和 SOP 入口。

## 5. 影响面

- 模板仓库维护者：在多仓 / 多会话并行时，可用预检降低远端误操作风险。
- 派生项目使用者：旧项目同步后能继续补完完整闭环；远端操作前有统一检查入口。
- 派生同步：新增脚本会随 `template-sync.json` 下行同步。
- CI / 自检：模板自检需覆盖新脚本和文档入口，避免后续漂移。

## 6. 验证计划

1. `git diff --check`。
2. PowerShell 语法解析：`scripts/check-github-context.ps1`、`scripts/sync-template.ps1`、`scripts/check-template.ps1`。
3. Git Bash 语法检查：`scripts/sync-template.sh`、`scripts/check-template.sh`。
4. `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
5. 只读试跑 `powershell -ExecutionPolicy Bypass -File scripts/check-github-context.ps1`，确认可输出上下文，并在未授权 / 工作区不干净时返回 warning。

## 7. 归档计划

本提案随对应 PR 落地后，应从 `_proposals/` 移动到 `_archive/proposals/`，并在 PR / 同步记录中注明已处理。若 PR 拆分为多个提交，本提案仍作为同一组变更的归档入口。

## 8. 安全与隐私边界

- 不记录具体个人账号、邮箱、token、OAuth scope、SSO 组织名或本机私有路径。
- 预检脚本只读，不执行 `gh auth login`、账号切换、remote 修改、push、PR 创建或 merge。
- GitHub 授权仍由用户在本机按官方流程处理，模板只提供操作前风险识别。
