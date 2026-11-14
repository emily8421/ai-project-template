# GitHub Issue #543: 割接 / 迁移类任务的「下游引用 sweep + gitignored 本地态清单」收尾检查项

> Source URL: https://github.com/emily8421/ai-project-template/issues/543
> State: open
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-11-11T11:02:58Z
> Updated: 2026-11-11T11:02:58Z
> Mirrored at: 2026-11-14
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

## 动机

两次独立踩坑同构（来自派生项目实践），均属「变更 / 迁移类任务收尾清单缺隐性关联面」：

1. **下游引用面漏扫**（跨仓割接场景）：入口反代自业务仓迁至独立网关仓的割接任务，收尾更新了变更本体（编排 / 拨测配置）与两仓施工记录，但业务仓内「引用旧事实的其他文档」未 sweep——失效的回滚确认命令（仍指向已无监听的宿主端口）与过时的拨测目标表残留多日，直至后续维护任务做旧端口全仓 grep（命中 20+ 文件）才现形。
2. **本地态面漏迁**（换机迁移场景）：迁移恢复闭环覆盖 SSH 私钥 / 备份 / 依赖重装，未把 gitignored 本地观察目录列入迁移清单——目录不随 git 走、也不随「依赖重装」类恢复走，丢失后续接文件的历史摘要引用成悬空指针。

共性根因：收尾清单只覆盖「显性变更对象」，漏两类隐性关联面——①引用旧事实的下游文档（旧端口 / 旧路径 / 旧命令）；②不入库的本地态文件。

## 拟改（模板侧落点候选，供维护者裁量）

1. `session-rules.md` §4（自动更新触发点 / 收尾自检）或 `implementation-lifecycle-rules.md` §7（验收与留痕）：增补一条**可选检查项**——割接 / 迁移 / 端口调整 / 路径重组类任务收尾时，对旧标识（端口、路径、域名、命令中的关键字）做一次全仓 grep，逐命中区分「活事实（随动修改）vs 历史记录（保留）」；验证成本一次 grep，防同类漂移静默残留。
2. `template-docs/env-setup.md` 或迁移恢复类 SOP：增补「gitignored 本地态目录」清单项——迁移 / 备份恢复前显式列出（如 `.ai/` 观察目录、`.tmp/`），或明确声明接受丢失并在续接文件标注悬空指针。

## 版本影响

PATCH 级规则 / 文档增补；不引入 check-template 自检断言或 CI 门禁（与「避免过度治理」既定口径一致——grep 是否执行属语义判断，无法机械化）。

## 与既有规则的关系（去重）

- `rules-core.md` §4 已有「大范围搜索完成后回锚点汇报」：本提案不重复定义搜索行为，是其在变更类任务收尾的场景化应用提示。
- `document-lifecycle-rules.md` 的文档变更传播约束覆盖「需求 / 设计变更」的传播；基础设施 / 部署拓扑类变更（割接、端口、路径）的文档 sweep 属空白场景，本提案补位。
- `env-setup.md` 既有内容以环境搭建与运行时版本为主，未列 gitignored 本地态迁移项。

## 来源

zhiyan-digital-cs-platform 派生回流（本地提案 `TEMPLATE-UPGRADE-cutover-migration-impact-sweep.md`，关联派生仓 pitfall SUMMARY 批次 5，两条独立踩坑同构合并）。
