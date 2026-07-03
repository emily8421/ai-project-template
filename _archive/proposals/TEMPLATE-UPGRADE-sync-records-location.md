# TEMPLATE-UPGRADE: 派生同步运行记录移出 docs

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：待评估 / 待落地。
> 覆盖问题：派生项目模板同步运行记录放入 `docs/archive/template-sync/`，与项目开发文档体系混层。

## 1. 背景与问题

当前模板建议派生项目在完成方法论同步后，将同步运行记录保存到：

```text
docs/archive/template-sync/YYYY-MM-DD-sync-template-vX.Y.Z.md
```

该路径出现在 `template-docs/derived-sync-report-template.md`、`ai/prompts/maintainers/12-sync-template.md`、`ai/commands/sync-methodology.md`、`ai/prompts/maintainers/15-post-sync-cleanup.md`、`ai/prompts/maintainers/18-submit-feedback.md` 等位置。

问题在于：同步运行记录记录的是模板治理 / 方法论同步过程，不是派生项目自身的需求、设计、开发或验证事实。放在 `docs/archive/` 下容易与项目事实文档混层，增加新手理解成本，也与 `docs/` 作为项目事实层的定位不完全一致。

## 2. 设计目标

- 将模板同步运行记录与项目开发过程文档分离。
- 保留同步记录的可审计性与可回流能力。
- 不破坏现有派生项目中已生成的旧记录。
- 明确长期留痕与本地临时续接的区别。

## 3. 候选方案

### 方案 A：根目录 `sync-records/`（推荐）

```text
sync-records/template-sync/YYYY-MM-DD-sync-template-vX.Y.Z.md
```

优点：

- 与 `docs/` 项目事实层分离。
- 可提交、可审计、可供后续 `submit-feedback` 扫描。
- 语义清晰：这是同步运行记录，不是项目设计文档。

缺点：

- 新增一个根目录，需要 README / 分区说明更新。

### 方案 B：`.ai/sync-records/`

```text
.ai/sync-records/template-sync/YYYY-MM-DD-sync-template-vX.Y.Z.md
```

优点：

- 明确本地 AI 运行记录，不污染仓库正式文件。

缺点：

- 默认不提交，团队审计和回流提案扫描不方便。
- 不适合作为长期同步留痕。

### 方案 C：保留 `docs/archive/template-sync/`

优点：

- 无迁移成本。

缺点：

- 继续混淆项目事实文档和模板治理日志。

建议采用方案 A，并保留方案 B 作为“用户暂不想提交长期记录”的本地临时路径。

## 4. 迁移策略

- 新生成的同步运行记录默认写入 `sync-records/template-sync/`。
- 旧派生项目已有 `docs/archive/template-sync/` 不强制迁移；post-sync-cleanup 可提示“可按需移动”。
- `submit-feedback` 扫描时兼容新旧两个路径一段时间。
- 文档中说明 `.ai/session-handoff.md` 只适合临时续接，不替代长期同步运行记录。

## 5. 拟改范围

- 修改：`template-docs/derived-sync-report-template.md`
- 修改：`ai/prompts/maintainers/12-sync-template.md`
- 修改：`ai/commands/sync-methodology.md`
- 修改：`ai/prompts/maintainers/15-post-sync-cleanup.md`
- 修改：`ai/prompts/maintainers/18-submit-feedback.md`
- 修改：`ai/commands/submit-feedback.md`
- 修改：`SOP.md`
- 修改：`README.md` 或 `template-docs/beginner-guide.md`（如需解释根目录）
- 修改：`scripts/new-project.sh` 生成的派生 README 目录说明（如适用）
- 修改：`scripts/check-template.sh` / `.ps1` 断言路径说明一致
- 修改：`template-sync.json`（如新增记录目录说明文件）

## 6. 版本影响

建议作为 minor 版本落地。

理由：改变同步运行记录推荐路径，影响多个 prompt、command、SOP 与派生项目习惯，但不改变核心同步机制。

## 7. 验收口径

- 所有新文档入口推荐路径统一为 `sync-records/template-sync/`。
- `post-sync-cleanup` 与 `submit-feedback` 兼容旧路径 `docs/archive/template-sync/`。
- 文档明确区分长期同步记录、临时续接文件和项目事实文档。
- `check-template` 能检查关键路径引用不漂移。

## 8. 风险与缓解

- **旧项目已有记录分散**：兼容扫描新旧路径，不强制迁移。
- **根目录增加目录心智负担**：在 README 目录速览中简短说明，避免放入 `docs/`。
- **运行记录含敏感信息**：保留去敏提醒；敏感内容不应进入长期记录，可写入本地 `.ai/session-handoff.md`。
