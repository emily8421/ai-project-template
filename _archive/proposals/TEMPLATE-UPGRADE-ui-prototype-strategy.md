# TEMPLATE-UPGRADE: UI 原型策略与可视化验收门禁

> 来源：GitHub issue #131（`_proposals/_remote-issues/issue-131.md`）
> 类型：模板优化提案
> 状态：已实施，随 v1.39.0 归档
> 建议版本：MINOR
> 关联 issue：#131 `https://github.com/emily8421/ai-project-template/issues/131`
> 落地版本：v1.39.0

## 1. 背景与问题

模板已有前端交互设计触发规则，要求 UI 型项目在开发前补充 `docs/design/frontend-interaction.md` 或同类交互设计文档。但仅有文字交互设计仍可能让用户直到实现后才第一次看到界面效果，页面结构、状态反馈、信息密度、Demo / Mock / 降级口径和点击验收路径也可能在编码阶段才暴露问题。

该问题来自派生项目回流，但不依赖具体业务。凡是独立 Web、移动端、小程序、桌面端、多页面管理台、搜索 / 问答 UI、复杂表单、审批流、看板或数据密集界面，都需要在正式前端实现前明确是否需要可视化原型、采用何种原型形式以及如何与设计、计划和验证闭环追溯。

## 2. 设计目标

1. **条件必填**：UI 型项目满足触发条件时，必须选择 UI 原型策略或写明豁免。
2. **工具中立**：不绑定 Figma；允许 Figma、Penpot、Balsamiq、Axure、Storybook、代码原型、截图标注或其他形式。
3. **追溯闭环**：原型策略需要连接 `ai/project-rules.md`、`docs/05-tech-spec.md`、`docs/design/frontend-interaction.md`、`docs/08-dev-plan.md` 和 `docs/09-verification.md`。
4. **边界清晰**：原型不替代 `00-09`、不替代前端交互设计、不替代 `09` 验收，也不新增未授权需求、接口、权限行为或验收目标。
5. **可审计**：生成、修订、编码前 checklist、系统审计和文档评估都能发现缺失原型策略或缺少可视化证据的风险。

## 3. 落地范围

| 文件 | 落地内容 |
|---|---|
| `ai/global-rules.md` | 增加 UI 原型策略通用口径，并更新全局规则版本 |
| `ai/document-lifecycle-rules.md` | 新增 UI 原型策略触发与边界规则，更新 E3、剖面和 design 行 |
| `ai/project-rules.md` | 新增 §2.7 UI 原型策略字段，并在 §3 项目形态裁剪中加入适用 / 豁免决策 |
| `ai/doc-standards/05-tech-spec.md` | 增加 UI 原型策略记录位和 08 / 09 映射要求 |
| `ai/doc-standards/README.md` | 在前端交互设计基线中说明原型证据与设计文档的关系 |
| `ai/prompts/docs/00-generate-or-complete-docs.md` | 生成 UI 型项目文档时提示选择原型策略 |
| `ai/prompts/docs/04-edit-single-doc.md` | 修订前端交互设计时检查原型形式、位置、覆盖状态和未覆盖项 |
| `ai/prompts/review/10-docs-checklist.md` | 编码前检查 UI 原型策略是否缺失或越界 |
| `ai/prompts/review/16-docs-system-audit.md` | 审计 UI 型项目是否有可访问、可复核的可视化原型证据 |
| `ai/prompts/review/19-docs-evaluation.md` | E3 / E4 评估时检查原型是否足以支持前端 Sprint |
| `template-docs/scenario-guides.md` | 在“补前端交互设计 / 补 UI 设计”场景中加入原型策略选择 |
| `scripts/check-template.ps1` / `scripts/check-template.sh` | 增加 UI 原型策略关键断言 |

## 4. 规则摘要

- 满足前端交互设计触发条件，且用户需实现前预览界面、页面信息密度高、主流程依赖点击验收、存在多状态 / 多角色 / 权限可见性，或 Demo / Mock / 降级口径可能被误读时，必须选择并记录 UI 原型策略或写明豁免。
- 原型策略至少记录是否需要开发前可视化原型、原型形式、原型权威位置、覆盖页面 / 主流程 / 状态 / 设备范围、与 `08/09` 的追溯、未覆盖项和豁免理由。
- 工程驱动项目可优先“代码原型 + Mock 数据 + 截图 / smoke 证据”；设计协作强的项目可优先 Figma / Penpot；早期布局和流程确认可使用低保真草图或截图标注；组件库可组合 Storybook。
- 原型发现的新需求、接口、表字段、权限规则或验收目标必须回到正式文档链路修订。

## 5. 非目标

- 不要求所有项目使用 Figma。
- 不要求所有 UI 项目做高保真视觉设计。
- 不要求 Lean / CLI / 纯后端项目产出原型。
- 不把原型作为需求权威源。
- 不引入派生项目的页面、文案、数据、账号、路径或业务流程。

## 6. 验证方式

1. `git diff --check`
2. `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
3. `C:\Program Files\Git\bin\bash.exe scripts/check-template.sh`

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 是否将“UI 原型策略”设为 UI 型项目条件必填 | 建议条件必填：需要原型、选择形式或写豁免 | 仅有文字交互设计仍可能让 UX 决策拖到编码阶段 | 只作为推荐项 | 推荐项更轻，但 AI 容易跳过 |
| C-002 | 是否在 `project-rules` 增加原型工具偏好字段 | 建议增加 | 项目级工具偏好是横切事实，会影响 05、design、08、09 | 只写在 `frontend-interaction` | 入口较晚，不利于生成初始文档时决策 |
| C-003 | 是否把代码原型作为默认推荐之一 | 建议保留为默认推荐之一 | 工程驱动项目常常已有前端框架，代码原型能直接被用户看到和 smoke | 默认推荐 Figma / Penpot | 设计协作更强，但可能增加学习成本 |
| C-004 | 是否要求 09 引用原型证据 | 建议 UI 型项目在浏览器 smoke 或验收 TC 中引用 | 原型覆盖范围需要转成验收路径，避免只停留在设计稿 | 只在 design 文档记录 | 09 无入口会削弱验收闭环 |
