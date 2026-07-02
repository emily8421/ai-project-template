# TEMPLATE-UPGRADE：文档体系重构 PR-3b（v1.23.3）

> 去项目化提案。覆盖用户诉求 #7（关键文件夹 README）。v1.23 文档体系重构系列 PR-3b。

## 动机

关键文件夹（`template-docs/` / `scripts/` / `ai/` / 骨架目录）此前无 README，读者进入目录不知里面有什么、各看什么。延续 v1.23 主题（读者导向 + 互相导航），补齐文件夹级导航。

## 拟改

新增 7 个文件夹 README（**template-local，不进 `template-sync.json`**，对齐 PR-1 `docs/vision/README` 决策，避免破坏 `require_sync_dry_run_direction` 临时夹具）：

- `template-docs/README.md`：手册导航表（9 份手册各看什么）。
- `scripts/README.md`：脚本说明表（7 类脚本干什么 + 模板仓/派生检查区别 + Windows 入口）。
- `ai/README.md`：`ai/` 目录概览（index/global-rules/document-lifecycle/session/project-rules/commands/prompts/doc-standards 各是什么 + ai/-vs-template-docs 分工）。
- `frontend/` / `backend/` / `tests/` / `docker/` README：用途 + 按项目形态裁剪提示（指向 `project-rules` §3、`docs/README` 裁剪规则）。

## 版本影响

- v1.23.2 → v1.23.3（PATCH，v1.23 文档重构系列 PR-3b；从已合并 main v1.23.2 序列推进，无版本冲突）。
- 无脚本 / 同步清单 / 断言变更；check-template 全过。

## 影响面

- 非同步件：7 个新 README 仅在模板仓库（派生项目的目录指引已由同步的 `beginner-guide` §5 三层结构覆盖）。
- 不影响：规则正文、脚本、同步机制、check-template 断言。

## 落地流程

从 main（v1.23.2）切分支 `change/docs-restructure-pr3b-v1.23` → 写 7 README → check-template 通过 → VERSION/CHANGELOG/提案 → PR-3b。之后 PR-4a（template-docs 可读性 #11）/ PR-4b（scenario-guides）/ PR-5（document-lifecycle-rules）。
