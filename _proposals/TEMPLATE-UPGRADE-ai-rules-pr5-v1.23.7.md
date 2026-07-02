# TEMPLATE-UPGRADE：ai/ 规则件 PR-5（v1.23.7）

> 去项目化提案。覆盖用户诉求 #12（document-lifecycle-rules 读者导向）+ #14（global-rules 去重）。v1.23 文档体系重构系列 PR-5（最后一个内容 PR）。

## 动机

- #12：`document-lifecycle-rules.md` 需延续读者导向（说明文档体系是什么 / 为什么 / 怎么做 / 规范）。
- #14：`global-rules.md` §6「最佳实践流程总览」与 §1.1「文档驱动开发」是同一条 Scenario→Code 链的内部重复，需去重。
- 关键约束：两个文件都被多处 §N 跨引用（global-rules §1.2/§1.3/§4/§8/§8.1/§8.2-3；doc-lifecycle §2/§3/§5/§6/§13），**不能重编号**——否则断 6-7 处跨引用。

## 拟改

- `document-lifecycle-rules.md`（#12，不重组不重编号）：
  - 顶部加**阅读地图**——按「是什么/为什么/怎么做/规范/AI 流程/图表」映射到现有 §1–§13。
  - §1 加「文档体系是什么 + 为什么需要这套规则」framing（保留 7 条基本原则）。
  - §2–§13 内容保留，6 锚点（多入口生成策略 / docs/inputs / 横切事实 / 外部文档接入规则 / 设计文档图表规范 / mermaid）全保留。
- `global-rules.md`（#14，不重编号）：
  - §6 改为 stub 指针：「开发顺序与流程见 §1.1；核心避免『想法→AI→代码』」。**保留 §6 号**（§7/§8/§9 跨引用不断），只删重复链子。
  - §8 阶段双维度**不动**——复核确认它与 doc-lifecycle §4「文档剖面」（Full/Standard/Lean）是**不同概念**（阶段模型 vs 文档剖面），非重复（纠正 #13 评估误判）。

## 版本影响

- v1.23.6 → v1.23.7（PATCH，v1.23 文档重构系列 PR-5；从已合并 main v1.23.6 序列推进，无版本冲突）。
- 无脚本 / 同步清单 / 断言变更；check-template 全过。

## 影响面

- 同步件：`document-lifecycle-rules.md`、`global-rules.md`（派生项目下次同步获得）。
- 不影响：脚本、同步机制、check-template 断言（17 个直接锚点 + 全部 §N 跨引用保留）。

## 落地流程

从 main（v1.23.6）切分支 `change/docs-restructure-pr5-v1.23` → doc-lifecycle 加阅读地图+§1 framing、global-rules §6 stub → check-template 通过 → VERSION/CHANGELOG/提案 → PR-5。v1.23 文档体系重构（#1–#16）至此全部完成；之后 v1.24（#9 测试基础设施 + #15 批量同步）。
