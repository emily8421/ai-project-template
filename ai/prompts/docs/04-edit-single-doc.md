# 04 单文档修订

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

**用途**：只修订某一份文档或某个章节，不启动完整初始化流程。

**目的**：在变更原因明确时，保持文档局部更新并维持跨文档一致性。

**适用场景**：PRD 新增/调整需求、API 契约变化、DB 设计变化、Phase 标签需要同步，或按触发条件新增 / 补齐 `docs/design/frontend-interaction.md` 等详细设计文档。

**不适用场景**：需要重新生成或补齐 03-09 全套文档；这种情况先用 `ai/prompts/docs/01-review-inputs.md` 评审输入材料，再用 `ai/prompts/docs/00-generate-or-complete-docs.md`。

**使用前准备**：明确要修订的文档、变化原因、关联需求和受影响章节。

**预期产出**：修订方案、修改后的文档内容、影响范围说明；若来源是专题方案讨论，还必须包含人工确认依据和 open item 回填状态。

**使用后下一步**：用 `ai/prompts/review/10-docs-checklist.md` 或相关审查项检查一致性，再继续开发或提交。

```text
docs/07-api-spec.md 需要修订：（说明变化原因，例如PRD新增了XX需求）

请先阅读：
- ai/index.md 列出的全部规则文件
- 对应的 `ai/doc-standards/<doc>.md`（例如精修 `docs/02-srs.md` 时读取 `ai/doc-standards/02-srs.md`）
- docs/03-prd.md（相关章节）
- docs/07-api-spec.md（当前内容）

要求：
1. 只修改 docs/07-api-spec.md，不重新生成其他文档
2. 先说明本次修订的范围、理由、预计文件、变更摘要、风险和验证方式，等待确认后再修改
3. 修订前先按 `ai/document-lifecycle-rules.md` 判断该文档的上游输入、变更类型与下游影响
4. 修订 `00-03` 时必须对照 `ai/doc-standards/00-scenario.md` 至 `03-prd.md`，检查 `SC-ID → U-ID → REQ-ID → Phase → AC / TC` 是否仍闭合；新增 / 删除场景、U-ID、REQ 或 Phase 状态时，先指出下游影响清单和同步计划
5. 局部变更如影响 docs/06-db-design.md 或 08-dev-plan.md，先指出影响清单和同步计划，等待确认后再处理，不要自行连带修改
6. 若新增或补齐 `docs/design/frontend-interaction.md`，必须承接 `03/04/05/07/08/09`，覆盖页面 / 路由清单、REQ 追溯、核心用户流、组件职责、状态 / 空态 / 错误态、表单校验、文案、权限可见性、接口依赖和验收路径；不得新增需求、接口或验收目标
7. 若修订 `docs/04-architecture.md`，必须对照 `ai/doc-standards/04-architecture.md` 检查上下文图、COMP / MOD / Flow ID、运行拓扑、ADR、异常 / 降级 / 权限拒绝路径和 REQ / 功能追溯；新增真实依赖或外部系统时，同步评估 `docs/05-tech-spec.md`、`docs/09-verification.md` 和 `docs/08-dev-plan.md`
8. 若修订 `docs/05-tech-spec.md` 且项目涉及真实运行依赖，必须检查是否已有 `docs/research/*tech-env-evaluation*.md` 或同等评估结论，并对照 `ai/doc-standards/05-tech-spec.md` 补齐技术状态、依赖配置、密钥 / 敏感性、Risk-ID、readiness gate、`05 ↔ 09` 验证映射和 Sprint 解锁条件；缺失时先建议运行 `tech-env-evaluation`，或在 05 中记录跳过理由、风险和补做时点
9. 若 `04/05` 中存在候选、默认关闭、Mock、降级或禁止能力，必须确认不会被 `08` Sprint 或 `09` 必过用例误写为已启用
10. 横切事实 / 约束变更除外：必须主动列出所有受影响文档、权威源与引用同步计划，并在获得本次修改授权后按计划更新和做聚焦一致性检查
11. 若修订依据来自需求层人机交互、总体设计 / 技术选型或交互设计专题讨论，先确认用户已选择方案；未确认前只能写入“候选 / 待人工确认”，不得写成项目事实
12. 专题讨论确认后，必须说明回填位置、被关闭或更新的 open item ID，并检查是否需要同步 `docs-open-items`
13. 若新增或修改待人工确认项，必须补齐 `ID / 待确认项 / AI 建议 / 建议依据 / 备选方案 / 取舍影响 / 阻塞关系`；AI 建议不得写成已确认事实
```
