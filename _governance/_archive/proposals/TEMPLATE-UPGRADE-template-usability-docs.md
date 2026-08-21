# TEMPLATE-UPGRADE: 模板易用性文档补强

> 来源：模板维护者
> 状态：处理中（Batch 1 / Batch 2 / Batch 3 已落地；Batch 4 扩展 scaffold 模板落地中，待 PR 合并后归档）
> 目标版本：`v1.42.0`

## 1. 背景与现状证据

本轮维护从三个使用者问题出发：

1. `ai/doc-standards/00-09` 与 `ai/doc-standards/design-doc.md` 已经提供核心文档和通用详细设计标准，但前端交互设计、UI 原型策略 / 实现前原型、需求探索原型的规范仍分散在多处。
2. `docs/00-09` 在模板仓库中是带目录大纲、占位表格和 `【撰写提要：...】` 的结构模板；派生项目生成文档体系后，这些文件会变成项目事实文档，原始结构模板不再有显式长期副本。
3. 模板术语已经覆盖文档链路、阶段、状态、ID、原型、会话续接、同步治理等多个领域，但没有集中人读术语表。

现状证据：

| 主题 | 现有位置 | 当前问题 |
|---|---|---|
| 前端交互设计基线 | `ai/doc-standards/README.md`、`ai/document-lifecycle-rules.md`、`docs/README.md`、`ai/prompts/docs/04-edit-single-doc.md` | 有触发和边界，但缺少独立细粒度标准；用户难以直接对照“前端交互设计应写哪些章节 / 表格 / checklist”。 |
| UI 原型策略 / 实现前原型 | `ai/project-rules.md` §2.7、`ai/document-lifecycle-rules.md` §5.3、`ai/doc-standards/README.md`、`docs/05-tech-spec.md` | 有记录位和触发规则，但缺少独立标准与记录模板；场景只混在 A7 触发词里，没有像 A5.5 那样独立路由。 |
| 需求探索原型 | `template-docs/scenario-guides.md` A5.5、`ai/document-lifecycle-rules.md` §10.2、`ai/commands/ui-prototype-exploration.md`、`template-docs/ui-prototype-exploration-template.md` | 场景相对完整，但与“实现前原型 / UI 原型策略”的边界需要更显式，避免用户把探索原型当实现依据。 |
| `docs/00-09` 结构模板 | 模板仓库 `docs/00-09` 当前文件本身；规范镜像在 `ai/doc-standards/00-09` | `ai/doc-standards` 是规则标准，不是完整可复制的大纲模板；派生项目生成内容后，原始结构模板只能从模板仓或 Git 历史找。 |
| 术语说明 | README、SOP、global/document/implementation/session rules、doc-standards、scenario-guides | 新用户需要跨文件理解 `Phase`、`Sprint`、`REQ-ID`、`handoff stale`、`Mock`、`Readiness Gate`、`UI 原型策略` 等术语。 |

## 2. 问题拆解

### 2.1 原型 / 前端交互概念边界不够集中

需要明确区分三类对象：

| 对象 | 使用时点 | 权威位置 | 能否驱动实现 | 核心作用 |
|---|---|---|---|---|
| 需求探索原型 | `00-03` 正式定稿前 | `docs/research/YYYY-MM-DD-ui-prototype-exploration.md` | 否；确认后必须回填 `00-03` | 帮用户确认目标用户、页面结构、主流程、信息密度和需求假设。 |
| UI 原型策略 / 实现前原型 | 已有需求链和基本设计后，进入前端实现前 | `ai/project-rules.md` §2.7、`docs/05-tech-spec.md`、`docs/design/frontend-interaction.md` 或独立策略记录 | 仅能作为已授权需求的实现参考 | 确认可视化原型形式、权威位置、覆盖范围、未覆盖项、Mock / 降级口径和验收映射。 |
| 前端交互设计 | 详细设计阶段，前端实现前 | `docs/design/frontend-interaction.md` 或 `docs/design/*interaction*.md` | 是，但仅限已授权需求、接口和验收目标 | 细化页面 / 路由、用户流、组件职责、状态、文案、接口依赖、权限可见性和验收路径。 |

当前规则已经包含这些边界，但分散在生命周期规则、README、Prompt 和模板文件中。对 AI 来说可执行，对使用者来说不够直观；对维护者来说缺少防漂移的单点标准。

### 2.2 docs 结构模板与项目事实文档职责混用

模板仓库 `docs/00-09` 同时承担两种角色：

- 模板使用者首次看到的结构模板。
- 派生项目生成后承载项目事实的正式文档路径。

这种设计让派生项目目录保持简洁，但会产生副作用：AI 生成文档体系后，原始结构模板从当前项目工作区消失；使用者若想参考“模板原本要求怎么写”，只能看 `ai/doc-standards`（规则型，不是结构模板）或回模板仓库。

### 2.3 术语缺少集中人读入口

模板里的术语可以从规则中推导，但新用户很难知道该去哪里查。术语表不应替代规则权威源，但可以作为“人读索引”，把术语定义、权威文件和常见误用集中起来。

## 3. 设计策略与取舍

### 3.1 原型与前端交互：新增独立标准，而不是继续堆在 README / lifecycle

建议：

- 新增 `ai/doc-standards/frontend-interaction.md`。
- 新增 `ai/doc-standards/ui-prototype-strategy.md`。
- 保留 `ai/doc-standards/design-doc.md` 作为通用详细设计标准。
- `ai/doc-standards/README.md` 只做索引和基线摘要，不再承载详细表格。

取舍：

| 方案 | 优点 | 缺点 | 结论 |
|---|---|---|---|
| 继续放在 `design-doc.md` | 文件少，概念集中 | `design-doc.md` 会膨胀，UI 特化字段淹没通用设计标准 | 不推荐 |
| 继续放在 lifecycle / README | 易被所有人看到 | 规则分散，难以作为审计标准，防漂移弱 | 不推荐 |
| 新增独立 doc-standards | 可直接对照生成 / 精修 / 审计；便于自检断言 | 新增同步文件，需要维护索引和脚本 | 推荐 |

### 3.2 UI 原型策略：新增 A7.5 场景，而不是混在 A7

建议新增 A7.5：`UI 原型策略 / 实现前原型`。

原因：

- A5.5 需求探索原型已经覆盖 `00-03` 前的探索。
- A7 是“PLM 文档精修”大场景，包含太多触发词；UI 原型策略有明确门禁语义，适合独立路由。
- 独立场景能明确“需求未定 → A5.5；需求已定且前端实现前 → A7.5”。

### 3.3 UI 原型策略模板：放在 `template-docs/`，不放 `docs/`

建议新增 `template-docs/ui-prototype-strategy-template.md`。

理由：

- 这是人读 / 可复制模板，不是项目事实文档。
- 具体项目可以把策略内容回填到 `ai/project-rules.md` §2.7、`docs/05-tech-spec.md` 或 `docs/design/frontend-interaction.md`。
- 不污染 `docs/` 根目录，不新增 `docs/10-ui-design.md` 之类编号。

### 3.4 docs 结构模板长期副本：后续放入 `template-docs/docs-scaffold/`

建议 Batch 2 新增 `template-docs/docs-scaffold/00-09` 或等价目录。

理由：

- `ai/doc-standards/00-09` 是“写什么 / 审什么”的规范，不是“文档长什么样”的结构模板。
- `template-docs/docs-scaffold/` 可作为人读和 AI 引用的结构模板副本，派生项目同步后长期保留。
- 不应放入 `docs/` 根目录，避免与项目事实文档冲突。

取舍：

| 方案 | 优点 | 缺点 | 结论 |
|---|---|---|---|
| 不保留副本，只依赖 `ai/doc-standards` | 文件少 | 结构模板丢失，用户不易参考 | 不推荐 |
| 放在 `docs/_scaffold/` | 靠近项目事实文档 | 旧路径已有迁移历史，且可能污染 docs 事实区 | 不推荐作为主路径 |
| 放在 `template-docs/docs-scaffold/` | 人读模板定位清晰，随模板同步 | 新增多个同步文件 | 推荐 |

### 3.5 术语表：新增人读索引，不替代规则源

建议 Batch 3 新增 `template-docs/glossary.md`。

策略：

- 术语表只解释和索引，不作为规则权威源。
- 每个术语尽量包含：中文名、英文 / 缩写、简短定义、权威文件、常见误用。
- 分类建议：文档链路、ID / 追溯、阶段 / 交付物、状态词典、原型 / 前端交互、会话续接、模板治理 / 同步。

## 4. 分批计划

### Batch 1：原型与前端交互规范补齐（本轮落地）

拟改文件：

| 文件 | 修改策略 |
|---|---|
| `ai/doc-standards/frontend-interaction.md` | 新增前端交互设计细粒度标准，覆盖页面 / 路由、角色权限、用户流、组件职责、状态、接口依赖、响应式、原型证据和 TC 追溯。 |
| `ai/doc-standards/ui-prototype-strategy.md` | 新增 UI 原型策略 / 实现前原型标准，区分需求探索原型，规定原型形式、权威位置、覆盖范围、未覆盖项、Mock / 降级口径和回填关系。 |
| `template-docs/ui-prototype-strategy-template.md` | 新增可复制记录模板。 |
| `template-docs/scenario-guides.md` | 新增 A7.5 场景；A7 保留 PLM 精修，UI 原型策略路由到 A7.5。 |
| `ai/doc-standards/README.md` | 增加新标准索引和基线说明。 |
| `ai/document-lifecycle-rules.md` | 将前端交互设计 / UI 原型策略触发规则指向新标准。 |
| `ai/prompts/docs/00-generate-or-complete-docs.md` | 生成 docs 时按范围读取新标准。 |
| `ai/prompts/docs/04-edit-single-doc.md` | 精修前端交互设计或 UI 原型策略时对照新标准。 |
| `docs/README.md` / `template-docs/README.md` | 增加人读入口。 |
| `template-sync.json` / `scripts/sync-template.sh` | 加入新增同步文件。 |
| `scripts/check-template.sh` / `.ps1` | 增加防回归断言。 |

验收标准：

- `template-sync.json` 与 `scripts/sync-template.sh` 均包含新增标准和模板。
- `check-template` 能断言新增文件存在、关键章节存在、Prompt 引用新标准、场景包含 A7.5。
- 需求探索原型和实现前原型的边界在标准和场景中均明确。
- 不新增 `docs/10-*` 编号，不改变 `00-09` 编号体系。

### Batch 2：文档结构模板长期保留（已落地）

拟改策略：

- 新增 `template-docs/docs-scaffold/README.md`。
- 复制当前模板 `docs/00-09` 的结构模板到 `template-docs/docs-scaffold/00-scenario.md` ~ `09-verification.md`。
- 在 `docs/README.md`、`template-docs/README.md`、`README.md` 或 `beginner-guide` 中说明：
  - `docs/00-09` 是项目事实文档。
  - `template-docs/docs-scaffold/00-09` 是长期参考结构模板。
  - `ai/doc-standards/00-09` 是规则 / 审计基线。
- 加入 `template-sync.json` 和自检断言。

非目标：

- 不把 scaffold 放回 `docs/` 根目录。
- 不让 scaffold 成为开发事实源。
- 不要求派生项目手工同步 scaffold 到 `docs/00-09`。

验收标准：

- 派生项目同步后，即使 `docs/00-09` 被项目内容覆盖，仍能在 `template-docs/docs-scaffold/` 查到结构模板。
- README / docs README 能清楚区分三者：事实文档、结构模板、规范标准。

### Batch 3：术语表（已落地）

拟改策略：

- 新增 `template-docs/glossary.md`。
- 分类汇总术语：
  - 文档链路：PLM、Scenario、URS、SRS、PRD、Architecture、Tech Spec、DB Design、API Spec、Dev Plan、Verification。
  - ID / 追溯：SC-ID、U-ID、REQ-ID、NFR、COMP-ID、MOD-ID、Flow-ID、API-ID、TC-ID、Risk-ID、ADR。
  - 阶段 / 交付物：Phase、Sprint、Task、Demo、MVP、产品、愿景。
  - 状态词典：草案、候选、待人工确认、待技术验证、Mock、降级、默认关闭、预留 / 未启用、已验证、已启用、禁止。
  - 原型 / 前端交互：需求探索原型、UI 原型策略、实现前原型、前端交互设计、可视化证据。
  - 会话续接：handoff、fresh / stale、主动中断、被动中断、快速续接。
  - 模板治理：proposal、feedback、mirror、sync、template-sync、下行同步、回流、归档。
- 从 `README.md`、`template-docs/README.md`、`beginner-guide` 或 `template-methodology` 增加入门链接。

非目标：

- 术语表不替代规则文件，不作为新的权威流程定义。
- 不在术语表里复制大段规则正文；只给短定义和权威文件指针。

验收标准：

- 使用者能通过一个入口查到核心术语定义和权威来源。
- check-template 断言 glossary 存在并包含关键分类。

### Batch 4：详细设计与门禁记录 scaffold 扩展（本轮追加）

拟改策略：

- 扩展 `template-docs/docs-scaffold/`，从仅覆盖 `docs/00-09` 升级为项目文档结构模板库。
- 新增 `template-docs/docs-scaffold/design/subsystem-design.md`，对应 `docs/design/<subsystem>.md` 与 `ai/doc-standards/design-doc.md`。
- 新增 `template-docs/docs-scaffold/design/frontend-interaction.md`，对应 `docs/design/frontend-interaction.md` 与 `ai/doc-standards/frontend-interaction.md`。
- 新增 `template-docs/docs-scaffold/design/ui-prototype-strategy.md`，对应实现前 UI 原型策略记录；保留根部 `template-docs/ui-prototype-strategy-template.md` 作为兼容入口。
- 新增 `template-docs/docs-scaffold/research/ui-prototype-exploration.md`，对应 `docs/research/YYYY-MM-DD-ui-prototype-exploration.md`；保留根部 `template-docs/ui-prototype-exploration-template.md` 作为兼容入口。
- 新增 `template-docs/docs-scaffold/research/tech-env-evaluation.md`，对应 `docs/research/YYYY-MM-DD-tech-env-evaluation-<scope>.md` 与真实运行依赖 readiness gate。
- 更新 `template-docs/docs-scaffold/README.md`、`template-sync.json`、`scripts/sync-template.sh` 和 `check-template` 断言。

非目标：

- 不一次性补齐所有 P1 / P2 辅助模板，如 ADR、会议纪要、归档说明、task 模板；后续按使用频率单独评估。
- 不删除既有 `template-docs/ui-prototype-*-template.md` 兼容入口，避免破坏已有链接。
- 不让 scaffold 替代 `ai/doc-standards/` 规则权威源；若两者冲突，以标准文件为准。

验收标准：

- `docs-scaffold/README.md` 明确 `00-09`、`design/` 与 `research/` 模板职责。
- `template-sync.json` 与 `scripts/sync-template.sh` 包含新增 scaffold 模板。
- `check-template` 断言新增模板存在、包含 Sync notice 和关键章节。
- README / template-docs 入口不产生双重权威，既有根部 UI 原型模板仍可作为兼容入口。

### 后续候选池：本轮未执行的 P1 / P2 scaffold 与机制优化

> 状态：候选 / 待后续评估。以下项目不进入本轮 PR 必做范围，避免继续扩大 `v1.42.0` 的审查面；后续若确认价值，再单独拆 Batch 或新提案。

本轮评估结论：P0 已覆盖，P1 仅落地 `tech-env-evaluation`；其余 P1 / P2 暂不执行。

| 优先级 | 候选项 | 建议落位 | AI 建议 | 暂缓原因 / 后续触发 |
|---|---|---|---|---|
| P1 | Product Vision 结构模板 | `template-docs/docs-scaffold/vision/product-vision.md` | 后续补充 | `docs/vision/product-vision.md` 已有模板形态，但未纳入 scaffold；当用户反馈愿景入口不清或 scaffold 要覆盖 vision 时补。 |
| P1 | 输入评审报告结构模板 | `template-docs/docs-scaffold/inputs/input-review-report.md` | 后续补充 | 当前有 Prompt 流程但缺可复制报告模板；当 review-inputs 输出需要稳定落盘结构时补。 |
| P1 | 待确认事项总览正式模板 | `template-docs/docs-scaffold/research/docs-open-items.md` 或继续使用 `template-docs/docs-open-items.example.md` | 先评估是否由 example 升级为 template | 已有 example，是否迁入 scaffold 涉及兼容入口与命名取舍。 |
| P1 | ADR / 决策记录模板 | `template-docs/docs-scaffold/decisions/ADR-template.md` | 后续补充 | 横切事实权威源常用，但当前缺独立标准；宜先评估 ADR 最小字段与 `docs/decisions/` 命名约定。 |
| P2 | 环境记录 / 服务器预案轻模板 | `template-docs/docs-scaffold/env/local-env.md`、`server-plan.md` | 仅做轻模板或说明 | `local-env` 多由脚本生成，重模板可能误导人工维护；服务器预案项目差异较大。 |
| P2 | 会议 / 访谈纪要模板 | `template-docs/docs-scaffold/meetings/meeting-notes.md` | 可选 | 留痕价值有，但不直接驱动实现；等实际使用反馈再补。 |
| P2 | 归档说明模板 | `template-docs/docs-scaffold/archive/archive-note.md` | 可选 | 低频场景，暂不扩大同步清单。 |
| P2 | Task 文件模板 | `template-docs/task-template.md` 或 `template-docs/docs-scaffold/tasks/task-template.md` | 单独评估路径 | `tasks/` 不在 `docs/` 下，是否归入 docs-scaffold 需要先决定信息架构。 |
| 机制评估 | 模板版本号策略 | `MAINTAINERS.md` / `CHANGELOG.md` / `template-sync.json` 相关规则 | 单独评估，不混入 scaffold Batch | 最近模板改动频繁，`MINOR` 增长较快；需评估是否引入“日内变更聚合 / prerelease / sync revision”等机制。 |

## 5. 非目标 / 禁止项

- 不强制所有项目启用前端目录、前端交互设计或 UI 原型策略；触发条件不满足时可豁免，但必须写明理由。
- 不强制所有 UI 项目使用 Figma 或高保真设计；可选低保真草图、截图标注、Storybook、代码原型等。
- 不把需求探索原型、UI 原型策略或任何原型产物写成需求权威源。
- 不允许原型新增未授权需求、接口、权限规则、表字段或验收目标。
- 不新增 `docs/10-ui-design.md` 等新编号；`00-09` 编号体系不变。
- 不把模板结构副本放入 `docs/` 根目录，避免污染项目事实区。
- 不让术语表替代规则文件或 doc-standards。

## 6. 版本影响

Batch 1 / Batch 2 / Batch 3 均新增同步文件与模板能力，合并为同一个 `MINOR`：`v1.42.0`。

## 7. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 新增标准过多，增加学习负担 | 使用者可能不知道先读哪个文件 | 在 README / scenario-guides 中只暴露场景入口；详细标准由 AI 按 scope 读取。 |
| 前端交互设计与通用 design 标准重复 | 维护成本上升 | `design-doc.md` 保持通用职责，`frontend-interaction.md` 只放页面 / 交互特化字段。 |
| UI 原型策略被误解为强制高保真原型 | 增加不必要成本 | 标准中明确可选低保真 / 截图 / 代码原型 / Storybook，并允许豁免。 |
| 结构模板副本与 `docs/00-09` 漂移 | 模板参考失真 | Batch 2 增加自检断言或同步脚本检查。 |
| 术语表与规则定义漂移 | 用户查到过时解释 | 术语表只做短定义 + 权威文件指针；关键术语加自检断言。 |

## 8. 验证方式

Batch 1：

- `git diff --check`
- `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
- `C:\Program Files\Git\bin\bash.exe scripts/check-template.sh`

Batch 2 / Batch 3：

- `git diff --check`
- `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
- `C:\Program Files\Git\bin\bash.exe scripts/check-template.sh`
- 额外关注同步清单、自检断言、README 入口和派生同步 dry-run 影响。
