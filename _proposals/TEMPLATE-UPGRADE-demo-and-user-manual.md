# TEMPLATE-UPGRADE：演示手册扩展 + 用户手册分区

> 来源：模板维护者（双 AI 综合评估 P1，见 `TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`）
> 状态：候选（待评估 → 处理中）
> 目标版本：待确认（建议 patch；若决定新增必填 docs 分区则 minor）
> Release impact：patch（AI 建议，待维护者确认）—— 模板补强 + 可选指南，不改默认行为
> Release strategy：同主题聚合

## 1. 动机（WHY）

提案 1 拆成四个子断言，核对现状后**剔除「场景质量」无效项**，聚焦三个真实缺口：

- **演示手册缺回滚 + 未实例化**：`demo-runbook-template.md` 已有 8 节结构，但只有「关闭方式」（`:46`）无「回滚 / 清理」环节；仓库与 `_examples/` 均未实例化，新项目无真实填法参考。
- **缺用户手册**：全仓无 how-to 操作手册；`beginner-guide.md:6-8` 自定位为心智模型手册；操作知识散落 scenario-guides / commands / prompts / SOP 四处。
- **演示不与阶段耦合**：`show-demo` 是单一场景，不与 `03-prd §3` Phase 路线图绑定，无「阶段级演示」概念。

**明确剔除**：「场景质量」子断言 —— `scenario-guides.md:53-83` 已是三层表格 + 强制「先说为什么再执行」+ 完成判据，质量已高，不投入。

## 2. 现状证据（file:line）

| 现状 | 证据 |
|---|---|
| show-demo 单一场景，不替代验收 | `ai/commands/show-demo.md:17-19`、`:35,68` |
| demo-runbook 模板 8 节，缺回滚 | `template-docs/demo-runbook-template.md:1-87`（`:46` 只有关闭方式） |
| docs/env 只讲 local-env，未实例化 runbook | `docs/env/README.md`；`_examples/` 无 demo runbook |
| 无用户手册，beginner-guide 是心智模型 | `template-docs/beginner-guide.md:6-8` |
| 场景质量已高（剔除项） | `template-docs/scenario-guides.md:53-83` |
| docs 根目录只放核心文档（用户手册不能塞根） | `docs/README.md:48-56`（§4）、`:58-72`（§5 标准子目录） |

## 3. 拟改（WHAT）

### 3.1 扩展 demo-runbook-template（不新造命令）

- **补「回滚 / 清理」章节**：演示失败后如何回滚到稳定状态、清理演示产生的脏数据 / 临时资源、恢复 Mock / 降级开关。位置接在「关闭方式」后。
- **补「阶段演示脚本」**（可选）：在「推荐演示路径」节增加按交付物形态（Demo / MVP / 产品）的演示要点对照，但不强制拆成多份 runbook —— 复用现有 `local-demo-runbook.md`，按入口 / 阶段在节内分段，避免命令膨胀（`CONTRIBUTING §7`）。

### 3.2 用户手册走 docs/README 分区扩展（不塞 docs 根）

用户手册不放进 `docs/` 根目录（违反 `docs/README.md §4`）。两种归属（待确认）：

- **方案 A（扩展现有分区）**：把 how-to 用户操作手册归入 `docs/env/`（运行 / 演示 / 操作）或新增轻量 `docs/guides/` 子目录，在 `docs/README.md §5` 标准子目录表登记定位。
- **方案 B（template-docs 承载）**：用户手册作为模板能力放 `template-docs/user-guide-template.md`（与 `demo-runbook-template` 同级），派生项目按需实例化到 `docs/`。

用户手册内容范围：how-to 任务操作（怎么新建项目 / 怎么规划阶段 / 怎么跑演示 / 怎么同步），从 scenario-guides / commands / prompts / SOP 汇总成单一入口，**不重复**逐步细节，而是给任务→权威入口的导航表。

### 3.3 _examples 实例化

在一个 `_examples/`（如 `todo-api`）补一份实例化 demo runbook，含回滚章节，作为新项目真实填法参考。

### 3.4 明确剔除项

「场景质量」不投入：`scenario-guides.md` 现状质量已满足，避免无效工作。本提案不改动 scenario-guides 的引导结构。

## 4. 版本影响

- demo-runbook 补回滚 + 阶段脚本、`_examples` 实例化：**patch**（模板补强）。
- 用户手册：若方案 A 新增 `docs/guides/` 且为可选分区 → patch；若决定为必填分区 → minor。**默认按 patch 论证**（可选指南，不改默认行为）。

## 5. 影响面（拟改文件）

| 文件 | 改动 |
|---|---|
| `template-docs/demo-runbook-template.md` | 补回滚 / 清理章节 + 阶段演示要点 |
| `ai/commands/show-demo.md` | 视情况提示回滚章节存在 |
| `docs/README.md` | §5 登记 user-guide / guides 分区定位（方案 A） |
| （方案 B）`template-docs/user-guide-template.md` | 新增用户手册模板 |
| `template-docs/beginner-guide.md` | 导航表补用户手册入口 |
| `_examples/todo-api/`（或他例） | 实例化 demo runbook（含回滚） |
| `template-sync.json` | 若新增 template-docs 模板文件，登记同步 |

## 6. 待确认项

| ID | 待确认 | AI 建议 | 依据 |
|---|---|---|---|
| DM-1 | 用户手册归属：docs/guides 分区 vs template-docs 模板 | 方案 B（template-docs 模板），与 demo-runbook 同级，派生项目按需实例化 | 不污染 docs 根、与现有模板文件一致 |
| DM-2 | 阶段演示是否绑定 Phase 退出标准 | 软绑定：demo-runbook 内分段提示，不强制每个 Phase 退出必有演示（避免加重） | show-demo 已声明不替代验收 |
| DM-3 | 用户手册是可选还是必填 | 可选（patch），复杂项目按需采用 | 兼容轻量项目 |

## 7. 落地流程

1. 确认 §6 后，在维护分支改 demo-runbook-template + 用户手册模板 / 分区。
2. `_examples` 实例化 demo runbook。
3. `scripts/check-template.sh` 自检（`_examples` 完整性断言不破）。
4. PR 评审（重点：是否新造重复命令、用户手册是否塞 docs 根、是否过度强制）。
5. 合并后 patch / minor 版本递增 + CHANGELOG，下行同步。

## 8. 验证方式

- `scripts/check-template.sh` 通过（含 `_examples` 检查）。
- 实例化 demo runbook 含回滚章节且可执行。
- 用户手册导航表覆盖主要 how-to 任务且不与 scenario-guides 重复细节。

## 9. 关联

- 评估总览：`TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`（提案 1）。
- 关联 P0 `system-skeleton-gate`：阶段演示可绑 System Skeleton 验收的可演示证据。
