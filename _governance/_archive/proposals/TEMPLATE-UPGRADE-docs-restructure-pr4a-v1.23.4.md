# TEMPLATE-UPGRADE：文档体系重构 PR-4a（v1.23.4）

> 去项目化提案。覆盖用户诉求 #11（template-docs 可读性，PR-4a 部分：env-setup / ai-cli-setup / template-methodology）。v1.23 文档体系重构系列 PR-4a。

## 动机

3 份 template-docs 手册结构偏散、有重叠节与碎片节，可读性不够友好。延续 v1.23 主题（读者导向 + 通俗 + 条理 + 互相导航），做结构优化（去重叠、归组、加导航），不改规则实质。

## 拟改

- `env-setup.md`（15 节 → 10 节）：合并 3 个「顺序 / 路径」节（§6+§7+§8）为「怎么装：三种路径」；合并 2 个「脚本行为」节（§9+§10）为「脚本会做什么」；§1+§2 合并为「这页帮你做什么 + 先检测」；§5 折入 §4；§4 加速览表；§15 改导航表。
- `ai-cli-setup.md`（9 节 → 8 节）：§7「推荐操作顺序」并入 §2「推荐顺序」（去重复）。
- `template-methodology.md`（17 节碎片 → 6 主题）：①定位 ②当前权威源 ③解决什么问题+设计目标 ④核心设计原则 ⑤各子系统设计 why（信息架构 / docs·ai 分工 / 文档生命周期 / 阶段模型 / 运行环境 / Prompt·工具 / 治理同步）⑥演进策略+历史来源。

## 版本影响

- v1.23.3 → v1.23.4（PATCH，v1.23 文档重构系列 PR-4a；从已合并 main v1.23.3 序列推进，无版本冲突）。
- 无脚本 / 同步清单 / 断言变更；check-template 全过。

## 影响面

- 同步件：`env-setup.md`、`ai-cli-setup.md`、`template-methodology.md`（派生项目下次同步获得新结构）。
- 不影响：规则正文、脚本、同步机制、check-template 断言（env-setup 8 锚点 / ai-cli-setup 5+1 absent / template-methodology 仅 file-existence，全保留）。

## 落地流程

从 main（v1.23.3）切分支 `change/docs-restructure-pr4a-v1.23` → 重构 3 文件 → check-template 通过 → VERSION/CHANGELOG/提案 → PR-4a。之后 PR-4b（scenario-guides #11）/ PR-5（document-lifecycle-rules #12）。
