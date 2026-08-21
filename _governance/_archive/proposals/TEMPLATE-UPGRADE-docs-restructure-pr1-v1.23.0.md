# TEMPLATE-UPGRADE：文档体系重构 PR-1（v1.23.0）

> 去项目化提案。覆盖用户最初诉求 #1（docs 输入/输出区分）、#2（beginner-guide 全貌）、#8（docs 文档体系介绍 + 规范）。

## 动机

模板文档长期「规则堆砌」：beginner-guide 不够通俗、缺全貌心智模型（不看 README 就不懂模板是什么、输入怎么变代码）；docs/README 只讲分区、不区分人工输入与 AI 输出、无 00-09 总体介绍与规范约束。新用户难以从单份文档建立完整心智。v1.23 主题：模板文档从「规则堆砌」转向「读者导向 + 通俗 + 条理 + 互相导航」。

## 拟改

- `template-docs/beginner-guide.md`：5 章 → 7 节全貌重构，新增「输入材料 → 文档体系 → 实现代码」核心心智图 + 目录三层结构（模板方法 / 文档事实 / 代码骨架）+ 导航表。
- `docs/README.md`：改标题为「项目文档体系与分区规则」；新增 §1 输入/输出二分、§2 00-09 各自干什么、§3 规范约束；保留分区 / 裁剪 / 根目录约束等。
- `docs/vision/README.md`（新增）：人工输入区定位，呼应 docs/README §1。
- `docs/inputs/README.md`：顶部补「人工输入区」显式标注。
- 关键决策：docs/ 输入/输出区分用「逻辑标注 + 分区导航」而非物理拆分（避免破坏 `global-rules §5` + `document-lifecycle §3-5` + check-template 断言 + 同步清单 + 派生项目路径）。

## 版本影响

- v1.22.5 → v1.23.0（MINOR：文档结构重构，向下兼容，不影响同步机制）。
- 无脚本变更、无同步清单变更（`docs/vision/README.md` 不进 `template-sync.json`，避免破坏 `require_sync_dry_run_direction` 临时夹具）；check-template 全过。

## 影响面

- 同步件：`beginner-guide.md` / `docs/README.md` / `docs/inputs/README.md`（派生项目下次同步即获得新内容）。
- 非同步件：`docs/vision/README.md`（模板仓本地增强；#1 机制主力为已同步的 docs/README §1）。
- 不影响：规则正文（`ai/`）、脚本、同步机制、check-template 断言。

## 落地流程

切分支 `change/docs-restructure-pr1-v1.23` → 落地 4 文件 → check-template 通过 → VERSION / CHANGELOG / 提案 → PR-1 合并。PR-2（治理文档）/ PR-3（操作 + 导航）另轮。
