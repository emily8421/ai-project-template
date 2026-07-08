# TEMPLATE-UPGRADE: docs scaffold 后续模板补强

> 来源：模板维护者
> 状态：P1 已落地；P2 候选 / 待评估
> 目标版本：`v1.43.0`（P1 批次）
> Release impact：minor（新增同步 scaffold 模板）
> Release strategy：同主题聚合；P1 已在 `v1.43.0` 落地，P2 延后候选池

## 1. 背景与来源

`v1.42.0` 的模板易用性文档补强已经落地 `template-docs/docs-scaffold/` 的核心结构模板、设计类模板、研究类模板、术语表、同步清单和自检断言。归档提案 `_archive/proposals/TEMPLATE-UPGRADE-template-usability-docs.md` 仍保留“后续候选池”，其中部分未执行项属于后续文档模板优化，不应只留在归档历史里。

本提案从该归档提案的“后续候选池：本轮未执行的 P1 / P2 scaffold 与机制优化”拆出文档模板相关候选项，重新放入 `_proposals/` 作为 active 收件箱条目，避免后续维护时遗漏。

版本治理机制候选已单独拆到 `_proposals/TEMPLATE-UPGRADE-version-governance.md`，不纳入本提案范围。

## 2. 待评估项

| 优先级 | 候选项 | 建议落位 | AI 建议 | 暂缓原因 / 后续触发 |
|---|---|---|---|---|
| P1 | Product Vision 结构模板 | `template-docs/docs-scaffold/vision/product-vision.md` | 本轮落地 | `docs/vision/product-vision.md` 已有模板形态，但未纳入 scaffold；当用户反馈愿景入口不清或 scaffold 要覆盖 vision 时补。 |
| P1 | 输入评审报告结构模板 | `template-docs/docs-scaffold/inputs/input-review-report.md` | 本轮落地 | 当前有 Prompt 流程但缺可复制报告模板；当 review-inputs 输出需要稳定落盘结构时补。 |
| P1 | 待确认事项总览正式模板 | `template-docs/docs-scaffold/research/docs-open-items.md`，保留 `template-docs/docs-open-items.example.md` 作为兼容示例 | 本轮落地 | 已有 example，迁入 scaffold 后需保留兼容入口并说明 example / template 边界。 |
| P1 | ADR / 决策记录模板 | `template-docs/docs-scaffold/decisions/ADR-template.md` | 本轮落地 | 横切事实权威源常用，但当前缺独立标准；本轮补最小字段与 `docs/decisions/` 命名约定。 |
| P2 | 环境记录 / 服务器预案轻模板 | `template-docs/docs-scaffold/env/local-env.md`、`server-plan.md` | 仅做轻模板或说明 | `local-env` 多由脚本生成，重模板可能误导人工维护；服务器预案项目差异较大。 |
| P2 | 会议 / 访谈纪要模板 | `template-docs/docs-scaffold/meetings/meeting-notes.md` | 可选 | 留痕价值有，但不直接驱动实现；等实际使用反馈再补。 |
| P2 | 归档说明模板 | `template-docs/docs-scaffold/archive/archive-note.md` | 可选 | 低频场景，暂不扩大同步清单。 |
| P2 | Task 文件模板 | `template-docs/task-template.md` 或 `template-docs/docs-scaffold/tasks/task-template.md` | 单独评估路径 | `tasks/` 不在 `docs/` 下，是否归入 docs-scaffold 需要先决定信息架构。 |

## 3. 与已完成 docs-scaffold 的关系

- 已完成的 `template-docs/docs-scaffold/00-scenario.md` 至 `09-verification.md` 是 `docs/00-09` 核心文档结构副本。
- 本轮新增的 `inputs/` 与 `vision/` scaffold 覆盖 `00-09` 上游输入评审与产品愿景结构副本。
- 已完成的 `template-docs/docs-scaffold/design/*` 和 `research/*` 覆盖实现前原型、前端交互、技术环境评估等 P0 / 高触发频率场景。
- 本轮新增的 `decisions/ADR-template.md` 和 `research/docs-open-items.md` 覆盖横切事实权威源与待确认事项总览的常用结构。
- 本提案只评估周边辅助目录模板，不改变 `00-09` 编号体系，不替代 `ai/doc-standards/` 规则权威源。
- 若后续落地，应同步更新 `template-docs/docs-scaffold/README.md`、`template-sync.json`、`scripts/sync-template.*` 和 `scripts/check-template.*` 的自检断言。

## 4. 分批建议

### P1：本轮落地范围

1. `vision/product-vision.md`：补足愿景入口与 scaffold 的可发现性。
2. `inputs/input-review-report.md`：让输入评审结果有稳定落盘结构。
3. `research/docs-open-items.md`：判断是否从 example 升级为正式结构模板。
4. `decisions/ADR-template.md`：补齐横切事实 / 决策记录的最小模板。

### P2：按反馈评估

1. `env/*`：优先说明脚本生成与人工补充的边界，避免把采集事实写成技术评估通过。
2. `meetings/*`：仅在会议 / 访谈留痕频率提高后补。
3. `archive/*`：仅在归档场景需要标准化说明时补。
4. `task-template`：先决定是否放在 `template-docs/` 根部、`template-docs/docs-scaffold/tasks/`，或继续只依赖 `docs/08-dev-plan.md` / `tasks/` 规则。

## 5. 非目标 / 禁止项

- 不在当前归档 PR 中直接新增上述 scaffold 模板。
- 不把版本治理机制与文档 scaffold follow-up 混在同一提案中落地。
- 不新增 `docs/10-*` 编号或改变 `docs/00-09` 固定编号体系。
- 不让 scaffold 模板替代 `ai/doc-standards/`、`ai/document-lifecycle-rules.md` 或正式项目事实文档。
- 不要求派生项目必须启用所有辅助目录；模板应保持可裁剪。

## 6. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| scaffold 目录继续膨胀 | 新用户学习成本上升，派生项目同步文件变多 | 按 P1 / P2 分批，只纳入高频且可复用的模板。 |
| example 与 template 双入口冲突 | 用户不清楚哪个是权威复制入口 | 落地前先决定命名与兼容策略，在 README 中说明。 |
| `local-env` 模板误导 | 用户可能把环境采集事实当作技术路线评估通过 | env 模板若落地，必须显式区分采集事实、人工确认和 tech-env-evaluation。 |
| Task 模板位置不清 | `tasks/` 不属于 `docs-scaffold`，目录语义可能混乱 | 先做信息架构决策，再决定是否新增模板。 |

## 7. 验收标准

- `_proposals/` 中能看到本提案，未执行文档模板优化不再只留在归档提案里。
- `_archive/proposals/README.md` 明确说明模板易用性文档补强归档后，未执行文档模板候选已拆到本提案。
- 本提案与 `_proposals/TEMPLATE-UPGRADE-version-governance.md` 边界清楚，互不重复。
- 后续若执行本提案，应在落地 PR 中补齐同步清单、自检断言、README 入口和版本 / changelog 决策。

## 8. 建议后续步骤

1. 保留本提案为 active 候选，聚焦 P2 候选评估。
2. 下一轮优先单独评估 Task 文件模板的信息架构与落位路径。
3. 若 P2 落地新增同步文件，按当时版本治理规则判断是否 bump minor。
