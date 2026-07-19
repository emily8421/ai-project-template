# TEMPLATE-UPGRADE: post-sync 项目自有版本机制启用 checklist

> 来源：模板维护者（zhiyan / LUMEN-DEMO / digital-cs-demo 派生项目同步后版本机制启用经验去项目化）
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：patch（AI 建议；补充 SOP / Prompt，不改变默认同步行为）
> Release strategy：优先补 `15-post-sync-cleanup` 操作清单；必要时同步补 `git-guide.md` 与同步记录模板

## 1. 背景

派生项目从旧模板版本同步到新版本后，常出现“已继承模板版本机制，但项目自有版本机制尚未启用”的状态。实际启用步骤在多个项目中高度重复：设置项目自己的 `VERSION`，整理 `CHANGELOG.md` 顶部项目版本段，更新 `TEMPLATE-BASE.md` 的 Project version，补 `ai/project-rules.md` 版本管理章节，新增项目侧 `project-check.yml`，再用 `check-derived-sync` 的双信号判断确认。

当前 `ai/prompts/maintainers/15-post-sync-cleanup.md` 已能审计是否启用，但“怎么启用”的操作步骤仍主要靠参考项目和 AI 现场推断。LUMEN-DEMO 启用时通过 agent 读取 zhiyan 参考实现节省了主线上下文；digital-cs-demo 后续也需要同类阶段 3 操作。该模式已足够稳定，适合沉淀为 checklist。

## 2. 目标

1. 给 post-sync-cleanup 增加“启用项目自有版本机制”的明确步骤。
2. 区分普通派生项目与领域模板：普通派生使用项目自有版本，领域模板可使用 `--domain-template` 与领域版本策略。
3. 固化双信号验收：主信号为项目侧 check workflow，辅信号为 `ai/project-rules.md` 中“项目版本管理”章节或等价内容。
4. 减少每次从参考项目重新拼装 VERSION / CHANGELOG / TEMPLATE-BASE / workflow 的成本。

## 3. 非目标

- 不自动决定项目版本号；项目版本值必须由维护者确认。
- 不强制所有派生项目立即启用项目自有版本机制。
- 不移除 `template-sync.json` 中的 `VERSION` / `CHANGELOG.md`；覆盖保护仍依赖 `--preserve-project-version` 或对应角色参数。
- 不改变母模板版本发布流程。

## 4. Checklist 候选

### 4.1 前置判断

1. 确认项目类型：普通派生、领域模板、或领域派生项目。
2. 读取目标仓 `VERSION`、`CHANGELOG.md` 顶部、`TEMPLATE-BASE.md`、`ai/project-rules.md`、`.github/workflows/`。
3. 判断是否已具备双信号：项目侧 workflow + project-rules 版本管理说明。
4. 若 handoff / memory 与文件事实冲突，以文件和 Git 为准。

### 4.2 普通派生项目启用步骤

1. 将根 `VERSION` 调整为项目自有版本，例如初始 `v0.1.0`，具体值需人工确认。
2. 重构 `CHANGELOG.md` 顶部：项目版本记录在上，模板继承历史保留在分隔区或历史区。
3. 更新 `TEMPLATE-BASE.md`：记录当前继承模板版本、同步时间、Project version。
4. 在 `ai/project-rules.md` 增加“项目版本管理”章节，说明项目版本与模板版本分层。
5. 新增或补齐 `.github/workflows/project-check.yml`，至少校验项目版本信号与模板同步边界。
6. 运行 `check-derived-sync`，确认版本机制检测通过或明确非阻断提示。
7. 在 `sync-records/template-sync/` 记录启用状态、验证结果与后续待办。

### 4.3 领域模板差异

1. 使用 `--domain-template` 保留领域模板自己的 `VERSION` / `CHANGELOG.md`。
2. `TEMPLATE-BASE.md` 需记录母模板继承版本和领域标准件范围。
3. 不把普通派生项目 workflow 强行套到领域模板；按领域模板同步验收规则判断。

## 5. 拟改

| 文件 | 改动 |
|---|---|
| `ai/prompts/maintainers/15-post-sync-cleanup.md` | §5 后新增“启用项目自有版本机制 checklist”，覆盖前置判断、普通派生步骤、领域模板差异与验收。 |
| `git-guide.md` | 可选：在派生同步 §5 中引用 checklist，说明 sync PR 与版本机制启用 PR 可分阶段。 |
| `template-docs/derived-sync-report-template.md` | 可选：增加“项目版本机制状态”字段或检查项，方便 sync report 留痕。 |
| `scripts/check-template.sh` | 若新增同步范围内 prompt 关键段，增加轻量防回归断言。 |

## 6. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| AI 擅自选择项目版本号 | 高 | checklist 明确版本号需人工确认；示例只用占位 |
| 普通派生与领域模板混淆 | 中 | checklist 单独列角色分支，不共用同一操作步骤 |
| CHANGELOG 重构丢历史 | 中 | 明确保留模板继承历史和项目历史分区 |
| 增加 post-sync SOP 长度 | 低 | 只加执行 checklist，不复制完整参考项目内容 |

## 7. 验收标准

- `15-post-sync-cleanup` 能让 AI 在无参考项目全文的情况下完成启用步骤规划。
- checklist 明确 VERSION / CHANGELOG / TEMPLATE-BASE / project-rules / workflow / check-derived-sync / sync-record 七个检查点。
- 普通派生项目与领域模板分层清楚，不会把项目版本写回母模板版本语义。
- 无具体项目名、路径、PR 号或业务事实。

## 8. 后续

- 若 checklist 落地后仍需频繁复制参考 workflow，可再评估新增 `template-docs/project-check-workflow-template.yml` 或 prompt 片段。
- 若领域派生项目场景成熟，再补充第三层同步的专门 checklist。
