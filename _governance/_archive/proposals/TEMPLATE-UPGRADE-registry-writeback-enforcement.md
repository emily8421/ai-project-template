# TEMPLATE-UPGRADE：registry 回写挂钩 + 母仓登记对账（治 stale-shared-state 第三次实证）

> 来源：模板维护者（2026-10-29 治理评估 A3 建议 + 2026-10-30 派生同步窗口实查实证）
> 状态：已确认，随本 PR 实施（维护者拍板「先做①+②组合」；③推式上报挂多机 / 多用户触发）
> 目标版本：v1.75.7（PATCH）
> Release impact：patch（治理说明挂钩 + 模板仓专用 advisory 工具；不改默认行为、不要求派生迁移、不新增下游采用面）
> Release strategy：单独发布

## 1. 动机（三次实证）

派生项目自行开会话同步时，母仓 registry 回写（12-sync-template 步骤 6）是"有步骤、无完成判据"的弱触发——A13 完成判据矩阵不含 registry 行，同步会话在派生仓结束后回写全凭记忆：

- 2026-08-27 ~ 09-16：LUMEN 连续 4 轮未登记（09-18 实查补登，PR #475）；
- 2026-09-19：**v1.75.3 轮 3 仓（zhiyan / flowkit / web-ui-kb）全部未登记**（2026-10-30 实查补登，PR #492）；
- 2026-10-30 窗口：flowkit / web-ui-kb 同步 v1.75.6 后仍未回写，zhiyan 连同步本身都未覆盖（实查补登时发现）。

stale-shared-state 弱触发三次实证，治标（人工补登）已循环三次，需治本。

## 1.1 与既有规则 / 机制的关系（去重）

- **12-sync-template 步骤 6**（现行）：registry 回写的步骤来源，本提案不新增步骤，只把该步骤挂进收尾门禁的完成判据（对象相同、动作不同）。
- **#478 / #484**（v1.75.4 / v1.75.5）：管 squash 合并后的边界校验口径与同步 PR 组成，不管登记回写——主题不同。
- **TEMPLATE-UPGRADE-governance-decoupling.md**（Phase 1 已落地 v1.75.6）：评估报告 A3 项即本提案来源，治本动作由本提案承载；Phase 2 机制审计与其互补。
- **`check-github-context.ps1`**（TOOL-REMOTE-001）：模板仓专用单一 PowerShell 脚本先例，本提案工具沿用同款登记与 notice 模式。
- **rd-data-chain §4「避免过度治理」**：对账脚本为 advisory（退出码提示漂移，不自动回写、不进 CI、不进同步清单），不加 check-template 内容断言。

**本提案不重复它们**：现有体系有"步骤"、有"索引"、有先例工具形态，缺的是完成判据挂钩与例行发现机制——本提案补的就是这两块。

## 2. 拟改

| # | 文件 | 变更 |
|---|---|---|
| 1 | `ai/prompts/maintainers/12-sync-template.md` | 收尾门禁 A13 矩阵覆盖清单补「母仓 registry 回写登记」项（步骤 6 挂钩）：未回写必须标 `部分完成` 并列补登路径，不得标 `完成` |
| 2 | `ai/prompts/maintainers/11-template-proposal-summary.md` | 分析要求新增第 10 条「先期状态核实」：提案声称的缺口先核实现行版本是否已修复（#478 实证 v1.54.3 先期修复）；引用的姊妹提案 / 文件先核实存在性（#485 实证悬空引用） |
| 3 | `scripts/check-registry-drift.ps1`（新增） | 模板仓专用只读对账：逐仓比对 registry `Inherited` ↔ 各仓 TEMPLATE-BASE `Current synced template version`，输出差异表；`0` 一致 / `1` 漂移 / `2` 结构错误；头部 Template-only notice |
| 4 | `scripts/check-template.sh` | `check_scripts_sync_boundary` 模板专用脚本数组补新脚本（+3 断言：存在 / 不在同步清单 / notice 标注，自检 2114 → 2117） |
| 5 | `scripts/new-project.sh` | 模板专用脚本裁剪名单补新脚本（派生项目不携带） |
| 6 | `scripts/README.md` | §1 模板专用组计数 4 类 / 5 文件 → 5 类 / 6 文件；§2.2 登记 `TOOL-GOV-001`；§2.3 运行契约补行 |
| 7 | `VERSION` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md` | v1.75.7 PATCH 登记 |

## 3. 明确不做（范围裁决）

- **不做推式上报**（派生仓同步时自动 gh 回写母仓）：跨仓 token / 权限 / 脚本维护成本，单机单 owner 场景收益低——维护者拍板：多机器或多用户时再触发。
- 对账脚本不进同步清单、不进 CI、不自动回写登记（advisory，处置权在维护者）。
- 不给 12-sync-template / prompt 11 新增 check-template 内容断言。

## 4. 影响面与验证

- 派生项目零影响（新增脚本为模板仓专用，new-project 裁剪、同步清单不含）。
- 验证：①对账脚本实跑（补登后应全 MATCH、exit 0）；②全量自检非沙箱直跑 2117 / 0；③`git diff --check` + md-clean 触达面；④CI Template Check 终判。

## 处理记录

- 2026-10-30：PR #492 补登实查（09-19 轮全漏 + 10-30 窗口 2 仓）后立案；维护者拍板①（A13 挂钩）+ ②（母仓对账）组合、③推式上报挂多机 / 多用户触发。起草并同会话实施。
