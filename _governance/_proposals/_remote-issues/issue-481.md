# GitHub Issue #481: TEMPLATE-UPGRADE：Sprint 完成包回写表补 CHANGELOG/VERSION 行（版本管理执行挂钩）

> Source URL: https://github.com/emily8421/ai-project-template/issues/481
> State: OPEN
> Labels: proposal, from:gmbl_project
> Author: emily8421
> Created: 2026-10-26T14:08:14Z
> Updated: 2026-10-26T14:08:14Z
> Mirrored at: 2026-10-27
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：Sprint 完成包回写表补 CHANGELOG/VERSION 行（版本管理执行挂钩）

> 来源：gmbl_project（emily8421/gmbl_project）派生项目回流
> 提出日期：2026-10-26；状态：草案（待 submit-proposal 回流模板仓收件箱）

## 动机

派生项目实测暴露：`project-rules §2.4 项目版本管理`（保持 `VERSION` 与 `CHANGELOG.md` 顶部一致）只是**字段约定**，模板的执行链路上没有任何检查点触达它——

- `implementation-lifecycle-rules §7.1` Sprint 完成包回写职责表只列 08/09/残留风险，**无 CHANGELOG/VERSION 行**
- Sprint/Task 收尾、Phase 升级、docs 审计清单均不含版本回写

结果：该派生项目单日完成 4 个 Sprint（14 个 feat 提交，含"全桩→全真管线"级里程碑）后 VERSION 仍停在 v0.1.0，靠用户人工发现才补记。约定与执行脱钩，任何派生项目都会复现。

## 拟改（模板仓）

1. **`ai/implementation-lifecycle-rules.md` §7.1 回写职责表**新增一行：

   | 触发 | 必须检查 / 回写 |
   |---|---|
   | Sprint 完成 | （既有行）…；**`CHANGELOG.md`（+ 存在 `CHANGELOG-PLAIN.md` 时同步）与 `VERSION`——0.x 阶段 Sprint 收口 minor bump、纯修复 patch，与 §7 完成包同批提交** |

2. **`ai/doc-standards/project-rules.md` §2.4 字段规范**补一句执行语义（供生成 / 审计对照）：

   > 该字段不止是初始值约定：Sprint 收口提交必须同批回写 CHANGELOG 并 bump VERSION（回写位置见 `implementation-lifecycle-rules §7.1`）；项目可在实例 `project-rules.md §2.4` 细化节奏（如按功能里程碑 minor）。

3. **`ai/doc-standards/08-dev-plan.md`**（完成包 / 进度记录要素处）加一行指针：完成包检查项含版本回写（避免 08 侧漏看）。

## 版本与影响

- 目标版本：v1.75.0（与收件箱既有两提案同批，或维护者归入相邻批次）
- 影响面：`implementation-lifecycle-rules.md`、`ai/doc-standards/project-rules.md`、`ai/doc-standards/08-dev-plan.md`；无脚本断言变更（不引入 check-template 门禁——版本节奏是语义判断，无法机械化判定 bump 时机，仅挂执行清单）
- 同步注意：改动文件均在下行同步清单内，需随下一次模板同步覆盖到派生项目

## 验证方式

- 模板仓侧：本提案不引入 `check-template` 新断言（见「版本与影响」——版本节奏是语义判断，bump 时机无法机械化判定），验证以文档核对为主：`implementation-lifecycle-rules.md §7.1` 回写表、`project-rules.md §2.4` 字段规范、`08-dev-plan.md` 完成包要素三处指针互指一致、无悬空引用。
- 派生侧前置验证：脱钩事实为实测（单日 4 Sprint / 14 提交后 VERSION 滞留 v0.1.0，用户走查发现）；实例侧执行挂钩已随补记账提交落地（实例 `project-rules.md §2.4`，2026-10-26），但该挂钩尚未经历下一次 Sprint 收口实测——诚实状态为「挂钩已就位、未复跑」。
- 下行同步后回归点：模板改动随同步覆盖派生项目后，以下一次 Sprint 收口为回归——完成包回写职责表出现 CHANGELOG/VERSION 行，且该收口提交同批含版本回写，无需用户人工发现。

## 与既有规则关系（去重）

- 不新增版本语义（Keep-a-Changelog / MAJOR.MINOR 语义各文档已各就各位），只把既有约定**接入执行检查点**
- 与 §7.1 既有"Sprint 完成→08/09 回写"行同表扩展，不另立 Gate / 不改提交门禁
- 派生项目侧已先行本地补丁（实例 `project-rules.md §2.4` 执行挂钩，2026-10-26）；本提案为该补丁的去项目化上游版本，回流合并后派生侧补丁随同步收敛

## 附：派生项目证据

- 单日 4 Sprint / 14 提交后 VERSION 停留 v0.1.0（用户走查发现）；补记提交 `30cebad`（CHANGELOG v0.2.0 + 实例侧挂钩），教训原文见该提交信息与实例 §2.4
