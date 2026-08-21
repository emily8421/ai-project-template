# TEMPLATE-UPGRADE：文档体系重构 PR-2（v1.23.1）

> 去项目化提案。覆盖用户诉求 #3（MAINTAINERS 重构）/ #4（CONTRIBUTING 修编号+重构）/ #5（README 目录速览）。v1.23 文档体系重构系列的 PR-2。

## 动机

治理文档（MAINTAINERS / CONTRIBUTING）长期「罗列堆积、没有条理性」，新维护者难以快速理解「维护者怎么干活」「贡献流程是什么」；CONTRIBUTING 编号别扭（0 / 2.5）；README 目录速览缺少对关键治理文档（SOP/CONTRIBUTING/MAINTAINERS/INIT-PROMPT/git-guide/template-sync）的说明，使用者/维护者划分不在入口可见。延续 v1.23 主题（读者导向 + 通俗 + 条理 + 互相导航）。

## 拟改

- `MAINTAINERS.md`：开头简化（使用者只看 README + beginner-guide，去掉冗长文件列表）；板块重构为「维护者怎么干活」递进——①你是谁 ②改模板全流程 ③发布 Checklist ④下行同步清单 ⑤自检与 CI ⑥README 边界与派生 README 规范 ⑦文档分区维护。
- `CONTRIBUTING.md`：去 0/2.5 编号；重构为「贡献流程」递进 1-9——①什么算模板改动（含一句话原则）②双向闭环 ③改模板流程 ④版本号纪律 ⑤派生回流 ⑥下行同步 ⑦分支命名 ⑧禁止 ⑨治理变更记录。
- `README.md`：开头加两类读者划分（使用者看 README+beginner-guide；维护者看 MAINTAINERS）；目录速览补 CONTRIBUTING / MAINTAINERS / INIT-PROMPT / template-sync 4 行。
- 全部保留 check-template 现有断言锚点（MAINTAINERS 10 个、CONTRIBUTING 5 个、README 14 个），只重组结构 + 补内容。

## 版本影响

- v1.22.5 → v1.23.1（PATCH，v1.23 文档重构系列 PR-2；与 PR-1 v1.23.0 文件无重叠）。
- **协调**：PR-1（#54, v1.23.0）须先合并；本 PR 合并时 CHANGELOG 保留 v1.23.1 / v1.23.0 两条降序，VERSION 取 v1.23.1。
- 无脚本变更、无同步清单变更；check-template 全过。

## 影响面

- 同步件：`MAINTAINERS.md`、`CONTRIBUTING.md`（派生项目下次同步获得新结构）。`README.md` 不同步（项目专属）。
- 不影响：规则正文（`ai/`）、脚本、同步机制、check-template 断言。

## 落地流程

从 `main`（`bfe43b9`）切分支 `change/docs-restructure-pr2-v1.23` → 重构 3 文件 → check-template 通过 → VERSION/CHANGELOG/提案 → PR-2。PR-3（git-guide / 文件夹 README）另轮，覆盖 #6/#7。
