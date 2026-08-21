# TEMPLATE-UPGRADE: 区分模板仓与派生项目的 CI 检查入口

> 来源：GitHub issue #82（https://github.com/emily8421/ai-project-template/issues/82）。
> 类型：派生项目回流的模板优化提案。
> 状态：已处理并归档；v1.27.7 已补齐派生项目 CI 检查入口分离、新项目 workflow 生成、同步脚本迁移提示和自检断言。
> 覆盖问题：派生项目如果继承模板仓 `.github/workflows/template-check.yml`，普通 PR 会误跑 `scripts/check-template.sh`，被模板仓规则错误拦截。

## 1. 背景与问题

模板仓与派生项目当前已经有两类检查：

- 模板仓完整性自检：`scripts/check-template.sh` / `scripts/check-template.ps1`。
- 派生项目同步边界检查：`scripts/check-derived-sync.sh` / `scripts/check-derived-sync.ps1`。

但派生项目如果继承模板仓 `.github/workflows/template-check.yml`，普通 PR 仍可能运行 `scripts/check-template.sh`，导致派生项目被模板仓规则误拦截，例如要求派生项目 README、`docs/00-09`、`_proposals/README.md` 或 Product Vision 保留模板仓占位口径。

这些要求对模板仓正确，但对已项目化的派生项目错误。根因是模板方法论缺少“CI 入口派生化”规则。

## 2. 设计目标

- 明确区分模板仓 CI 与派生项目 CI。
- 防止派生项目普通 PR 被模板仓完整性自检误拦截。
- 保留模板同步提交的边界检查能力。
- 保留通用空白检查，避免降低基础质量门槛。
- 在新项目生成和模板同步流程中固化正确默认值。

## 3. 已落地范围

- `.github/workflows/template-check.yml`：标明仅供模板仓使用，继续运行 `scripts/check-template.sh`。
- `scripts/new-project.sh`：生成派生项目版 `.github/workflows/project-check.yml`，并移除模板仓 workflow。
- `scripts/sync-template.sh` / `scripts/sync-template.ps1`：检测旧派生 `.github/workflows/template-check.yml` 并提示迁移。
- `ai/commands/sync-methodology.md` / `ai/prompts/maintainers/12-sync-template.md`：同步闭环中加入派生 workflow 检查。
- `ai/prompts/maintainers/15-post-sync-cleanup.md`：同步后整理时提示旧 workflow 迁移。
- `git-guide.md` / `SOP.md` / `MAINTAINERS.md`：补充模板仓 CI 与派生项目 CI 边界。
- `scripts/check-template.sh`：增加派生 workflow、同步脚本迁移提示和模板 workflow 边界断言。
- `VERSION` / `CHANGELOG.md`：版本更新到 v1.27.7 并登记变更。

## 4. 验收口径

- 模板仓 PR 仍运行 `scripts/check-template.sh`。
- 新生成派生项目的普通 PR 不运行 `scripts/check-template.sh`。
- 新生成派生项目的普通 PR 仍运行 `git diff --check`。
- 新生成派生项目的模板同步提交会运行 `scripts/check-derived-sync.sh HEAD`。
- `scripts/check-template.sh` 能发现派生 workflow 口径回退。
- 文档明确说明：派生项目普通 PR 如果因模板占位失败，应优先检查 workflow 是否误用模板自检。

## 5. 风险与缓解

- **派生项目质量门槛降低**：保留 `git diff --check`；项目自己的测试 / lint 由项目后续补充。
- **模板同步提交漏检**：仅对匹配 `sync template vX.Y.Z from ai-project-template` 的提交运行 `check-derived-sync`。
- **workflow 双重语义混乱**：模板仓版和派生项目版分离命名。
- **老派生项目保留旧 workflow**：同步脚本和 post-sync cleanup 明确提示迁移。
- **Windows / Git Bash 兼容性**：GitHub Actions Ubuntu 使用 Bash 入口；本地仍可用 PowerShell fallback。
