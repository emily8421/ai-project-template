# TEMPLATE-UPGRADE：Git 零基础入门手册下行

> 来源：模板维护者（现有 `template-docs/Git新手操作手册.md` 未跟踪草稿）
> 状态：处理中，待发布审查
> 目标版本：v1.78.0（候选）
> Release impact：minor（候选；`files_all` 新增用户文档）
> Release strategy：单独发布，不与派生项目 registry 登记合并

## 1. 动机

现有 `git-guide.md` 是模板与派生项目的操作 SOP，`template-docs/beginner-guide.md` 是使用模板的入门导航；Git 零基础用户还需要独立解释工作区、暂存区、提交、远端、分支、PR/MR 与撤销命令的参考材料。模板仓已有一份未跟踪的中文手册草稿，经用户确认计划发布。

## 1.1 与既有规则的关系（去重）

- `git-guide.md`（已发布）：具体 Git / 模板同步流程与风险约束，属权威操作口径；**层级不同**，新手册只解释概念并指回该 SOP。
- `template-docs/beginner-guide.md`（已发布）：模板使用导航；**对象不同**，新增手册只讲 Git 基础，不重复模板工作流。
- `template-docs/env-setup.md`（已发布）：Git for Windows 安装与环境配置；**互补不重复**，新手册不负责安装或权限排障。

**本提案不重复它们**：仅补新手理解 Git 命令之前的概念缺口，操作争议以现有 SOP 为准。

## 2. 拟改

1. 将现有草稿整理为 `template-docs/Git新手操作手册.md`，统一 Markdown 标题层级，补同步归属及 SOP 优先级说明，不改变草稿的核心示例。
2. 在 `template-docs/beginner-guide.md` 增加面向 Git 零基础读者的导航。
3. 将新文件登记到 `template-sync.json` 的 `files_all` 和 `scripts/sync-template.sh` 兜底清单，使普通与领域模板同步可获得手册；不修改派生项目业务文档。
4. 更新 `VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`。发布前按维护者流程评审、CI / 自检与 MINOR 端到端验证。

## 3. 影响与风险

- 新增可选参考文档，不增强制采用面或运行时依赖；同步清单新增一份下行文件，因此按新增下游采用面暂定 MINOR。
- 草稿篇幅较长，需核对标题结构、破坏性命令警告和与现有 `git-guide.md` 的差异；不将草稿中的示例改写为模板权威流程。
- 模板仓主目录仍有未跟踪原稿；在独立 worktree 审校与提交，不自动删除原稿。

## 4. 验证

- `git diff --check` 与 Markdown 卫生检查，核对导航链接和同步清单双入口一致。
- `scripts/check-template.sh --summary` 与 MINOR 发布要求的 L3 e2e；受限环境无法完整运行时明确标记待 CI/非沙箱复核，不伪称通过。
- PR 合并前人工确认版本影响和内容质量；合并后再按 A13 流程下行，不将候选版本写成已发布事实。
