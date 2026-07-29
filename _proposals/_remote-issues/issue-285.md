# GitHub Issue #285: TEMPLATE-UPGRADE: add domain-derived-scenarios-template for L2-to-L3 playbooks

> Source URL: https://github.com/emily8421/ai-project-template/issues/285
> State: CLOSED
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-07-29T07:49:37Z
> Updated: 2026-07-29T08:36:50Z
> Closed: 2026-07-29T08:36:50Z
> Mirrored at: 2026-07-29T16:36:50+08:00
> Mirror status: remote issue closed as implemented; GitHub issue remains source of comments and closure state.

## Local Triage / Implementation Notes

> Local triage updated: 2026-07-29T16:36:50+08:00
> Remote issue state at triage: CLOSED

Implemented by PR #287:

- PR: https://github.com/emily8421/ai-project-template/pull/287
- Merge commit: `08f389ed11f0ea1cd7fe93a1f8383e26b5ea1358`
- Version: `v1.59.0`
- Scope: added syncable `template-docs/domain-derived-scenarios-template.md`, wired domain-template docs / scenario guides / `domain-template-lab` command and Prompt, updated `template-sync.json`, Bash fallback list, and `check-template.*` assertions.
- Explicitly not included: `new-project --profile <domain>`, mother-template sync protocol changes, multi-level sync automation, or any domain-specific scaffold content.
- Validation before merge: `git diff --check`; Markdown clean check; `scripts/check-template.ps1`; `scripts/check-template.sh --summary` (`1922` checks / `0` failures). CI `template-check` passed on PR #287.

Closure source:

- #285 was auto-closed by PR #287 at 2026-07-29T08:36:50Z.

## Raw Issue Body

# TEMPLATE-UPGRADE: add domain-derived-scenarios-template for L2-to-L3 playbooks

> 来源：agent-system-template 真实领域模板项目需求；从 #276 拆分
> 状态：候选 · 待母模板维护者评估
> 目标版本：待确认；若新增同步范围内通用骨架文件，AI 建议评估为 minor
> Release impact：minor（AI 建议；新增可下行同步的 L2→L3 通用剧本模板会形成新的下游采用面）
> Release strategy：独立小批次；先只做通用剧本模板，不动 `new-project --profile <domain>`，不改同步协议，不写任何 agent-specific 内容

## 背景

#276 已通过 PR #283 在母模板中落地三层路径矩阵，并明确每个领域模板必须维护自己的 L2→L3 场景剧本入口。现在已有真实领域模板项目需要一个通用起步骨架，避免每个领域模板重复从零设计 `template-docs/<domain>/domain-derived-scenarios.md`。

## 目标

1. 新增通用骨架文件：`template-docs/domain-derived-scenarios-template.md`。
2. 覆盖领域模板 L2→L3 剧本最小章节：适用性判断、创建领域派生项目、同步领域模板更新、初始化后整理与领域自检、日常开发、L3→L2 回流、领域模板发布后的下游同步。
3. 更新必要入口引用：`template-docs/domain-templates.md`、`template-docs/scenario-guides.md`、`ai/commands/domain-template-lab.md`、`ai/prompts/maintainers/23-domain-template-lab.md`。
4. 如该文件进入下行同步范围，同步更新 `template-sync.json`、`scripts/sync-template.sh` fallback 清单和 `check-template.*` 断言。

## 非目标

- 不实现 `new-project --profile <domain>`。
- 不修改母模板主同步协议或引入多级同步自动化。
- 不把 agent / OCR / IoT 等具体领域内容写入母模板。
- 不改变普通 L3 派生项目默认两层路径。

## 验收建议

- `template-docs/domain-derived-scenarios-template.md` 存在，带 Sync notice，内容保持通用、去项目化。
- 模板文件包含 L2→L3 剧本最小章节和替换占位说明。
- `domain-template-lab` 能指向该模板作为领域模板实验线的起步骨架。
- 若纳入下行同步，`template-sync.json` 与 fallback / 自检断言一致。
- 本地与 CI 验证通过：`git diff --check`、Markdown clean、`scripts/check-template.*`。

## 关联

- Split from #276.
- #276 Batch 1 implementation: PR #283.
- #276 mirror record: PR #284.
