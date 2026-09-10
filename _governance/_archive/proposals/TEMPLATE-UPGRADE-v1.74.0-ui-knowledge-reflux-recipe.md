# TEMPLATE-UPGRADE：UI 设计知识回流入口与配方类记录（REC-*）

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流（GitHub issue #447，镜像 `_governance/_archive/proposals/issue-447.md`）
> 状态：已落地归档（C1 triage 2026-09-10 通过；实施 PR #452 squash `68af597`，随 v1.74.0 发布——发版 PR #455 squash `6c83877`；本提案 2026-09-10 归档至 `_archive/proposals/`）
> 目标版本：v1.74.0
> Release impact：minor（AI 建议，维护者确认：REC-* 为知识模型新记录类型 = 新下游采用面；变更集 A 单独看为 patch 级，随本 PR 聚合）
> Release strategy：同主题聚合（与 issue #451 两变更集一版发布，先例 v1.68.0 / v1.73.0）

## 1. 动机（去项目化）

v1.62.0 的 `template-docs/ui-knowledge/` 核心层解决了「派生项目从哪里查设计依据」，Batch 2A（v1.62.1）补了来源核验与结构校验。但派生项目 UI 实践（数字客服类项目界面重设计，2026-09）暴露两个缺口：

1. **回流没有入口。**核心层定义了记录模型、选择流程和 core 晋升条件（「跨 ≥2 项目验证」，README §9），但没有说明项目侧的验证结果和设计观察往哪里交、按什么格式入库。只随同步读到核心层的项目，既不知道收集层是否存在，也不知道 core 晋升所需的「项目实证」由谁、以什么方式提交。
2. **缺选型与配方类记录。**组件库 / 设计系统选型是每个 UI 项目都要做的比选，结论高度收敛，但既有四类记录（Source / Principle / Pattern / Case）没有位置承载「某类产品在选型和组合上的推荐结论」。每个新项目从零比选，结论无法继承。

## 1.1 与既有规则的关系（去重）

| 既有能力 | 关系 |
|---|---|
| `TEMPLATE-UPGRADE-web-ui-design-knowledge-base`（已归档，v1.62.0） | 延伸不推翻：四类记录、字段、生命周期一律不动；本提案补第五类记录与回流入口 |
| `TEMPLATE-UPGRADE-web-ui-knowledge-quality-governance`（已归档，v1.62.1，Batch 2A） | 分工不同：Batch 2A 管来源核验与结构校验；本提案管项目回流入口与记录类型扩展，不碰自检断言 |
| `template-docs/ui-knowledge/README.md` §5 选择流程、§6 原型输入包契约 | 补全不重复：消费端已有，本提案补回流端 |
| `ai/document-lifecycle-rules.md` §5.2.1 与 UI-G 门禁 | 指针级引用，不新增阶段或门禁 |
| `ai/global-rules.md` §9 提案通道 | 沿用，不另建通道 |
| Batch 2 剩余（core 晋升节奏、证据升降级） | 补前置：本提案让「项目实证」有提交入口，Batch 2 的评审节奏在其上运转 |
| 项目族群自建收集层仓库（如 web-ui-knowledge-base） | 只约定接口（ID / 字段 / 上浮条件），不收编、不纳入同步 |
| 提案 `TEMPLATE-UPGRADE-v1.74.0-web-ui-carrier-declaration.md`（issue #451A） | 机制不同：#447 管知识消费 → 设计的回流机制；#451A 管设计 → 实现的选型承载声明；实施时互加交叉引用 |

**本提案不重复它们**：既有能力覆盖「查知识」与「校验知识」，本提案补「项目经验如何回流」与「选型结论记在哪」两块空白。

## 2. 拟改（实施位置按 C1 方案校正）

1. `template-docs/ui-knowledge/README.md`：
   - §2.1「四类记录」→「五类记录」，表新增 Recipe 行（`REC-*`）；
   - §4 新增 §4.3 Recipe 字段规范（最小集 + 与 §4.1/§4.2 对齐的「类型与维度」行）与使用边界（推荐起点非标准答案；整体证据等级不超过所引证据最高等级；证据或选型环境变化时复评）；条目承载写明：核心层暂不存放 REC 条目，由收集层仓库承接；
   - §9 新增 §9.1「两仓分工与项目回流」：两层分工（核心层 ↔ 收集层）、回流内容 / 回流边界 / 上浮通道三件事；上浮沿用 `ai/global-rules.md` §9 既有通道，不改变 core 晋升标准。
2. `ai/commands/ui-prototype-exploration.md` 执行流程第 2 步末尾加一行回流指针。
3. `ai/document-lifecycle-rules.md` §5.2.1 知识来源注加一行回流指针。

不做的事：不新增命令与 `ai/*-rules.md` 必读文件；不新增 `check-template` 断言（`check_ui_knowledge_structure` 暂不覆盖 REC-*，条目积累后按 Batch 2 断言哲学单独评估）；不改动既有四类记录的定义、字段与生命周期；不新增同步清单成员（REC 并入 README，不建独立 recipes.md）。

## 3. 版本影响

minor（见头部 Release impact）。无破坏性变更，派生项目零迁移。

## 4. 影响面

| 对象 | 影响 |
|---|---|
| 派生项目 | 下次同步后核心层多一节回流指引；UI 任务可查配方类型，也有明确的回流去处。不使用知识层的项目不受影响 |
| 模板维护者 | triage 时多一类回流来源（项目实证记录）；core 晋升有可操作的提交入口 |
| 收集层仓库 | 需同源增补第五类记录承接条目；该类仓库不在模板同步范围，由其自行跟进，模板侧不阻塞 |
| 自检 | 不新增断言；既有断言不受影响 |

## 5. 验证方式

1. 结构：增补后核心层 README 的 ID 体系、字段规范与 §9 生命周期自洽——`REC-*` 可走完 candidate → core 全程，不需另立生命周期或新工具。
2. 流程：下一批派生项目 UI 任务按增补后指引完整走一遍「查配方 / 查模式 → 参考分析引用 ID → 设计 → 观察按收集 SOP 回流收集层」（issue #447 §7 为首个完整案例）。
3. 回归：`check-template` 既有断言全部通过（基线 2112 项 / 0 失败，本轮零断言变更）；Markdown 清洁检查与同步 dry-run 正常。

## 6. 实践案例（摘要，全文见 issue #447）

zhiyan 数字客服项目 2026-09 界面重设计：参考分析命中核心层 12 条 Pattern + 收集层 8 条 SRC / CASE；Console 选 Ant Design 5（复用 `CASE-antd-v5-tokens` 令牌事实，比选一次会话完成）、H5 端选轻量自绘 + 共享令牌——两个选型结论即配方应承载的形态；实践分两批回流 5 篇 CASE 入收集层（全部 candidate 待评审）。机制全链路可跑通，无卡点。
