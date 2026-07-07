# TEMPLATE-UPGRADE: 需求探索原型场景与模板

> 来源：模板维护者（当前维护会话）
> 类型：模板优化提案
> 状态：已实施，随 v1.40.0 归档
> 建议版本：MINOR
> 关联背景：用户提出“构思系统时先看原型、先与用户确认需求，再考虑架构 / 技术路线 / 技术栈”
> 落地版本：v1.40.0

## 1. 背景与问题

`v1.39.0` 已新增 UI 原型策略，解决“需求和设计链路中，前端实现前是否需要原型证据”的问题。但用户在更早阶段还有另一类需求：系统仍在构思时，希望先看到低保真 UI 原型、页面流或静态 Mock，用来与客户 / 用户确认需求，再决定是否进入正式 `00-03`、架构、技术路线和技术栈选择。

如果没有明确场景，AI 容易把这类探索原型混入 Demo、前端交互设计或技术选型讨论，导致原型中的页面、按钮、接口或数据字段被误写成已确认需求或实现依据。

## 2. 设计目标

1. **新增早期场景**：在 A5 输入评审和 A6 生成文档骨架之间增加“需求探索原型 / Demo 前原型确认”场景。
2. **明确边界**：探索原型不是需求权威源，不决定架构、技术栈、接口、数据库、任务或验收。
3. **提供模板**：新增 `template-docs/ui-prototype-exploration-template.md`，用于落盘 `docs/research/YYYY-MM-DD-ui-prototype-exploration.md`。
4. **新增命令 / Prompt**：提供 `ui-prototype-exploration` 命令和 22 号 Prompt，引导 AI 先输出原型定位、页面 / 流程 / 状态草案、待确认假设和回填建议。
5. **保证下行同步**：将新增模板、命令和 Prompt 纳入 `template-sync.json` 和 `check-template` 自检断言。

## 3. 落地范围

| 文件 | 落地内容 |
|---|---|
| `ai/document-lifecycle-rules.md` | 新增 §10.2 需求探索原型边界，原 §10.2 专题方案讨论顺延为 §10.3 |
| `template-docs/scenario-guides.md` | 新增 A5.5 需求探索原型场景和触发说法 |
| `template-docs/ui-prototype-exploration-template.md` | 新增探索原型记录模板 |
| `ai/prompts/docs/22-ui-prototype-exploration.md` | 新增需求探索原型 Prompt |
| `ai/commands/ui-prototype-exploration.md` | 新增命令路由 |
| `ai/commands/README.md` / `ai/prompts/README.md` | 更新索引 |
| `docs/README.md` | 说明探索原型默认放 `docs/research/`，确认后回填 `00-03` |
| `template-sync.json` | 纳入新增模板、命令和 Prompt |
| `scripts/check-template.ps1` / `scripts/check-template.sh` | 增加同步与场景关键断言 |
| `VERSION` / `CHANGELOG.md` | 升级到 `v1.40.0` 并记录变更 |

## 4. 规则摘要

- 需求探索原型发生在正式 `00-03` 定稿、架构和技术路线选择前。
- 默认只在会话中输出；如需落盘，推荐 `docs/research/YYYY-MM-DD-ui-prototype-exploration.md`。
- 原型可使用低保真草图、Figma、Penpot、截图标注、HTML 静态页、代码静态 Mock 或其他轻量形式。
- 原型中的页面、流程、文案、状态、接口想法或字段想法在用户确认并回填 `00-03` 前，不能写成正式需求或实现依据。
- 用户确认后的内容必须进入 `00-03`，再进入 `04-05`、`docs/design/*`、`08` 和 `09`。

## 5. 非目标

- 不替代 `v1.39.0` 的 UI 原型策略；后者是需求 / 设计链路内的实现前门禁。
- 不要求生成高保真视觉设计。
- 不要求选择 Figma 或任何特定工具。
- 不生成生产代码，不决定技术栈。

## 6. 验证方式

1. `git diff --check`
2. `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
3. `C:\Program Files\Git\bin\bash.exe scripts/check-template.sh`

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| 无 | 当前无阻塞项 | 按独立 MINOR 能力落地 | 该场景早于 #131 的实现前 UI 原型策略，职责不同 | 合并到 UI 原型策略 | 会混淆探索原型与实现前门禁 |
