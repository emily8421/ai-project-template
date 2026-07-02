# TEMPLATE-UPGRADE：文档体系重构 PR-4b（v1.23.5）

> 去项目化提案。覆盖用户诉求 #11（scenario-guides 可读性）。v1.23 文档体系重构系列 PR-4b。

## 动机

`scenario-guides.md` §5 的 23 场景目录是核心价值，但读者难以一眼定位「我要做哪件事」。加场景速查索引（不动目录正文），让读者按角色 + 触发说法快速跳到场景。延续 v1.23 主题（读者导向 + 互相导航）。

## 拟改

- `template-docs/scenario-guides.md`：
  - §5 顶部加**场景速查索引**——A0–A14 / C1–C7 / M1 共 23 场景，按角色分组，每行「触发说法 + 一句话」。
  - §5 目录正文（各场景条目的说明 / 触发 / cwd·前置 / 步骤 / 完成判据 / 下一步 / cmd 指针）**原样不动**。
  - §1「给人」入口提示补「§5 顶部有速查索引」，提升可发现性。

## 版本影响

- v1.23.4 → v1.23.5（PATCH，v1.23 文档重构系列 PR-4b；从已合并 main v1.23.4 序列推进，无版本冲突）。
- 无脚本 / 同步清单 / 断言变更；check-template 全过。

## 影响面

- 同步件：`scenario-guides.md`（派生项目下次同步获得速查索引）。
- 不影响：规则正文、脚本、同步机制、check-template 断言（5 锚点全保留：场景路由入口 / 引导计划输出契约 / A0 冷启动 / mermaid / 当前 gh 登录账户）。

## 落地流程

从 main（v1.23.4）切分支 `change/docs-restructure-pr4b-v1.23` → §5 加速查索引 + §1 入口提示 → check-template 通过 → VERSION/CHANGELOG/提案 → PR-4b。之后 PR-5（document-lifecycle-rules #12 + global-rules 去重 #13，合并为一个 ai/ 规则 PR）。
