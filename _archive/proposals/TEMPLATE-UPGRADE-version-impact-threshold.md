# TEMPLATE-UPGRADE: 版本影响门槛收敛

> 来源：2026-07-09 维护会话中对 `MINOR` 增长过快的复盘
> 状态：已在本 PR 落地，合并后归档
> 目标版本：`v1.44.1`
> Release impact：patch（治理规则收敛，不改变模板运行时默认行为）
> Release strategy：单独发布，作为 `v1.44.0` 后的版本策略校准

## 1. 背景

近期模板版本号中 `MINOR` 增长过快，实际原因不是 `MAJOR` 应该更频繁，而是 `MINOR` 门槛偏宽：兼容性脚本参数、可选能力补充和治理说明增强容易被误判为新增能力层级。

`v1.44.0` 的 `--summary` / `--no-stat` 属于可选、兼容、默认行为不变的脚本增强；按旧口径发布为 minor 可以保留历史事实，但后续同类变更应默认归为 patch。

## 2. 调整目标

- 将“可选脚本参数 / 兼容增强 / 默认行为不变”明确收敛为默认 `patch`。
- 将 `minor` 提升为“新增能力层级或新增下游采用面”的发布窗口，而不是功能次数计数器。
- 保持 `major` 只用于不兼容变化，不因为 minor 收敛而抬高 major 频率。
- 增加自检断言，防止版本治理口径漂移。

## 3. 拟改范围

- `CONTRIBUTING.md`：更新 Release impact 决策表和默认判断规则。
- `_proposals/README.md`：同步提案头部 release impact 说明。
- `MAINTAINERS.md`：更新发布 checklist 中 PATCH / MINOR 的验证与聚合口径。
- `scripts/check-template.sh`：增加关键断言。
- `VERSION` / `CHANGELOG.md`：按 patch 发布 `v1.44.1`。
- `_proposals/TEMPLATE-UPGRADE-a13-sync-closure-gate.md`：补充 `v1.44.0` 属旧口径历史事实，后续同类可选参数默认 patch。

## 4. 验收标准

- 文档明确：兼容、可选、不改变默认行为的脚本参数增强默认 `patch`。
- 文档明确：`minor` 只用于新增能力层级、强制采用面、同步范围结构扩展或推荐流程变化。
- 文档明确：疑难判断默认从 `patch` 开始，除非存在强制迁移 / 默认行为 / 同步结构变化证据。
- `scripts/check-template.sh` 通过。
