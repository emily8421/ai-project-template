# TEMPLATE-UPGRADE: 阶段准出档位判据基准（stage exit level criteria，L0-L3）

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流（GitHub issue #439，镜像 `_governance/_proposals/_remote-issues/issue-439.md`）
> 状态：已落地（PR #445，squash `933b535`，v1.73.0）；issue #439 关闭（裁决点：可试用不升标签）；2026-09-09 归档
> 目标版本：v1.73.0（MINOR，LUMEN 回流批三提案一版聚合）
> Release impact：minor（新增同步范围内规范基线文档 1 份 + 指针挂接 + 防滞后断言，属「新增文档骨架规范 / 新同步结构文件」；存量项目不强制回溯采用）
> Release strategy：同主题聚合（Batch B 三提案 #441 / #440 / #439 各自 PR，统一 v1.73.0 发版，先例 v1.68.0）

## 1. 动机（去项目化）

AI 辅助开发走「先 MVP 后产品级」路线时，若「完成」没有可验证定义，生成物倾向退化为**表面系统**：有界面样子、无真实通道、错误路径缺失、权限靠前端隐藏、无验证证据。

**已有地基（本提案不重复建设）**：`ai/global-rules.md` §8.1 双维度阶段模型 + 三档一句话定义（缺逐项判据）；`ai/document-lifecycle-rules.md` §2.1 阶段产物对照（管「做什么产物」不管「做到什么程度」）；§7.1 状态词典（可直接引用）；`ai/doc-standards/09-verification.md` §3 §4 证据体系（已备）。

**缺口（本提案补）**：①档位无判据——同档不同 Phase 水位不可比；②准出条目无强制证据形式——「我觉得做完了」可通过验收；③判据文件 / 指针被静默删除无报警；④判据质量无校准机制——纸面自洽的判据照样放走表面系统。

## 1.1 与既有规则的关系（去重）

- **`ai/global-rules.md` §8.1**：**层级递进，不改变定义**——§8.1 给档位名称与一句话定义，本提案给逐维度判据，是其预留「项目可在 project-rules 细化」钩子的通用化上行；§8.1 挂指针引用（2026-09-09 triage 核实钩子原句存在）。
- **`ai/document-lifecycle-rules.md` §2.1**：**对象不同，互补**——产物清单 vs 档位判据；同源动机，互相引用。
- **§7.1 状态词典 / `09-verification.md` §3 §4**：**被引用，不改动**——状态词与证据形式只收既有体系产物，不新增。
- **`ai/doc-standards/03-prd.md` §4（退出标准行）**：**挂接点**——补三要素与判据基准指针。
- **`scripts/check-template.*` 结构检查**：**复用机制，不新增体系**——防滞后断言复用既有 `require_contains` 模式（#374 同类）。
- **#408（stage-artifacts-exit-criteria，已落地）**：**对象不同**——#408 回答「交什么」，本提案回答「做到什么程度算数」；不合并（合并会产出难对照的单表）。

**本提案不重复它们**：补的是「档位判据与准出条目证据形式无基准文档」这块空白。

## 2. 拟改（已实施形态）

- **新增 `ai/doc-standards/stage-exit-baseline.md`**（规范基线，随模板下行）：判据阶梯 L0-L3 及格线、7 维 × 4 档判据矩阵（含增量判据读法）、跨档位红线（5 条）、准出条目三要素与证据形式枚举、反浮于表面对照表（9 模式 fail-closed）、阶梯 ↔ 交付物形态标签映射、判据质量校准方法论（五步流程 + 逐格回测）。
- **挂接 ×2**：`ai/global-rules.md` §8.1 三档定义处、`ai/doc-standards/03-prd.md` §4 退出标准处，各加一行指针。
- **同步清单登记（triage 增补，原提案未列）**：`template-sync.json` `files_all` 新增该文件；`check-template.sh` fixture 循环与 doc-standards 生成计数断言 11 → 12；+3 条防滞后断言（清单登记、global-rules 指针、03-prd 指针）。
- **裁决点（2026-09-09 维护者拍板）**：「可试用 / Beta」（L2）**不升**为正式交付物形态标签——维持 §8.1 三标签枚举，L2 判据照用、对外宣称仍 MVP（写入基准文件 §6）。

## 3. 版本影响

MINOR（v1.73.0，与 Batch B 另两提案聚合发版）：新增同步范围内规范文档 1 份 + 指针 2 处 + 防滞后断言 3 条；不改既有规则语义，不破坏既有项目流程。版本递增在发版 PR 统一执行。

## 4. 影响面

- 新文件：`ai/doc-standards/stage-exit-baseline.md` ×1（含 Sync notice）。
- 修改：`ai/global-rules.md` §8.1、`ai/doc-standards/03-prd.md` §4 各 +1 指针；`template-sync.json` +1 行；`scripts/check-template.sh`（fixture 计数 + 断言）。
- 对派生项目：新项目同步即获得判据基准；存量项目不强制回溯补标注，采用节奏与回测样本由各项目自行决定。
- 不新增需求 / 表 / 接口 / 验收目标，只约束「做到什么程度算数」。

## 5. 验证方式

- `git diff --check` + `bash scripts/check-template.sh --summary` 全量自检（含 doc-standards 镜像同步临时工程——fixture 已扩至 12 文件，验证新文件随同步下行且不覆盖派生 `docs/00-09`）。
- 人工核对：基准文件引用的 §8.1 / §2.1 / §7.1 / 09 §3 §4 编号属实（triage 已核实）；指针位置语义正确。
- 来源项目实证：判据经两阶段真实证据逐格回测（2 阶段 × 7 维 = 14 主格：修条目 0、记账 7），转正后进 CI 一次绿；判据文件 / 指针被静默移除时 CI 直接红。
- MINOR 发版前按 MAINTAINERS §3 跑 L3 端到端回归（`e2e-sync-check.sh` + R4-R6 人工项）。
- PR CI（Template Check）通过后合并。
