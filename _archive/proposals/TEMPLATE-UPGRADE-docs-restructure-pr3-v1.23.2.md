# TEMPLATE-UPGRADE：文档体系重构 PR-3（v1.23.2）

> 去项目化提案。覆盖用户诉求 #6（git-guide 分场景重构）。v1.23 文档体系重构系列 PR-3。

## 动机

`git-guide.md` 按主题（账号 / 新建 / 日常 / 模板变更 / 同步 / 踩坑 / 速查）组织，git 初学者难以快速定位「我要做哪件事」。延续 v1.23 主题（读者导向 + 通俗 + 条理 + 互相导航），改为按**场景**组织。

## 拟改

- `git-guide.md` 重组为场景：§1 先准备（gh 账号）+ §2 场景速查表（你要做哪件事→去哪节）+ §3 场景 A 派生日常提交 + §4 场景 B 模板维护 + §5 场景 C 派生同步 + §6 场景 D 新建项目 + §7 踩坑 + §8 命令速查。SOP 细节逐字保留，只重排 + 加场景标签。
- **关键决策**：下行同步保持在 §5（原 §5），避免破坏 CONTRIBUTING / sync-methodology / commands-README 的 `git-guide §5` 引用与 check-template 断言；新建项目从 §2 移到 §6。
- 跨引用同步：`ai/commands/new-project.md`、`ai/prompts/setup/14-new-project.md` 的 `git-guide §2` → `§6（场景 D）`（无断言依赖 §号，安全）。

## 版本影响

- v1.23.1 → v1.23.2（PATCH，v1.23 文档重构系列 PR-3；从已合并的 main v1.23.1 序列推进，无版本冲突）。
- 无脚本 / 同步清单变更；check-template 全过。

## 影响面

- 同步件：`git-guide.md`、`ai/commands/new-project.md`、`ai/prompts/setup/14-new-project.md`（派生项目下次同步获得新结构）。
- 不影响：规则正文、脚本、同步机制、check-template 断言（§5=sync 保留，全部锚点保留）。

## 落地流程

从 main（v1.23.1）切分支 `change/docs-restructure-pr3-v1.23` → 重组 git-guide + 更新 2 跨引用 → check-template 通过 → VERSION/CHANGELOG/提案 → PR-3。PR-3b（7 个文件夹 README，#7）另轮。
