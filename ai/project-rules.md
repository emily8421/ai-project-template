# 项目专属规则

> 本文件是项目专属规则的**种子实例**（不参与跨项目同步）。字段规范、填写要求、审计项与禁止项的
> 单一事实源在 `ai/doc-standards/project-rules.md`（规范基线，随模板同步）；生成 / 审计 / 精修本文件时对照规范基线。规则分层原则见 `ai/global-rules.md` §5。
>
> 判断标准：一条规则换到另一个完全不同的项目上是否还成立——
> 不成立（涉及具体技术栈/具体功能/具体Phase定义）就属于本文件（实例）；成立属规范基线或通用层。
>
> 填写时机：§1 Phase边界、§2 技术栈与项目约束、§3 项目形态与文档裁剪在生成 docs/03-09 **之前**填
> （作为约束）；§4 目录特例、§5 编码约定与禁区在审核 03-09 **之后**补。

## 初始化必填检查（生成 docs/03-09 前）

在使用 `ai/prompts/docs/01-review-inputs.md` 评审输入材料并用 `ai/prompts/docs/00-generate-or-complete-docs.md` 生成或补全 `docs/03-09` 前，必须确认以下项目已填写，不得保留占位说明直接进入设计阶段：

- `项目名称` 与 `代号/缩写` 已明确；若暂不需要缩写，写“无”。
- `§1 Phase边界` 已明确当前阶段允许、禁止与下一阶段预告；禁止项不得留空。
- `§2 技术栈与项目约束` 已列出本项目确定使用的主要技术；不确定版本写“待确认”，不得虚构。
- `§2.1 运行环境与资源约束` 已通过 `scripts/collect-env.ps1` 生成 `docs/env/local-env.md`，并完成人工确认项；若暂不能采集，必须说明原因。
- `§2.2 图表格式偏好` 已确认（默认 mermaid，可改 plantuml）；未确认则按默认 mermaid，不阻断。
- `§3 项目形态与文档裁剪` 已明确持久化、对外接口、演示形态、`docs/06`、`docs/07` 与需要保留的代码目录。
- `§2.4 项目版本管理` 已确认：默认从 `v0.1.0` 起步，并保持 `VERSION` 与 `CHANGELOG.md` 顶部项目版本一致；如需改规则，先在本节写明。
- 不适用的模板目录或文档已有“保留 / 省略 / 删除”决策；省略 `docs/06` 或 `docs/07` 时必须在 §3 留下说明。
- 新增项目文档的类型与路径已按 `docs/README.md` 分区规则判断；不得把新增文档直接放到 `docs/` 根目录。
- 若以上任一项无法判断，AI 必须先向用户提问或提出待确认项，不得继续生成后续设计文档。

## 0. 项目标识

项目名称：（如 DigitalCustomerService_Demo）
代号/缩写：（用于数据库表前缀、包名等，如 cs_sessions）

## 1. Phase边界

当前阶段：Phase1

允许：
- （本项目当前阶段允许使用的技术/功能）

禁止：
- （本项目当前阶段禁止使用的技术/功能）

下一阶段预告：
- （Phase2大致会开放什么）

## 2. 技术栈与项目约束

（本项目确定使用的前端/后端/数据库/AI模型等，及禁止引入的替代品）

## 2.1 运行环境与资源约束

> 字段规范见 `ai/doc-standards/project-rules.md` §4 §2.1（约束架构与技术方案选择；Demo / MVP 优先本机可运行，资源不足须在 `docs/05-tech-spec.md` 写降级策略或服务器预案；`docs/env/local-env.md` 只记录本机事实，不等于技术路线已被环境支撑）。

- 本机环境文档：`docs/env/local-env.md`（由 `scripts/collect-env.ps1` 生成，人工补充确认项）
- 技术环境评估报告：需要 / 不需要 / 豁免（若需要，推荐 `docs/research/YYYY-MM-DD-tech-env-evaluation-<scope>.md`；若豁免，说明原因、风险和补做时点）
- Demo 阶段必须能在本机运行的部分：待确认
- 允许降级 / Mock / 远程运行的部分：待确认
- 禁止在本机运行的重资源部分：待确认
- 是否允许使用公司服务器：待确认
- 若需服务器，资源申请口径：待确认

## 2.2 图表格式偏好

> 字段规范见 `ai/doc-standards/project-rules.md` §4 §2.2；图表格式规范见 `ai/document-lifecycle-rules.md` §13，场景引导见 `template-docs/scenario-guides.md` §7。

- 图表格式：`mermaid`（默认）/ `plantuml`
- 若选 mermaid 以外格式，说明原因（如团队工具链、渲染环境）

## 2.3 UI 原型策略（如适用）

> 字段规范与触发边界见 `ai/doc-standards/project-rules.md` §4 §2.3（触发与边界见 `ai/document-lifecycle-rules.md` §5.3；原型只作为已授权需求的可视化证据，不是需求权威源）。

- 是否涉及可点击 UI：是 / 否
- 是否需要开发前可视化原型：需要 / 不需要 / 豁免
- 原型形式：Figma / Penpot / Balsamiq / Axure / Storybook / 代码原型 / 截图标注 / 其他
- 原型权威位置：链接或仓库路径（如设计文件、Storybook、代码原型入口、截图目录）
- 原型覆盖范围：主流程 / 页面状态 / 响应式范围 / 权限与降级状态
- 原型与文档关系：承接 `docs/design/frontend-interaction.md`，并映射到 `docs/08-dev-plan.md` Sprint 与 `docs/09-verification.md` 验收用例；不得新增未授权需求、接口或验收目标
- 豁免理由：仅当不需要原型或暂不补原型时填写，并说明风险、影响范围和补做时点

## 2.4 项目版本管理

默认从 `v0.1.0` 起步，并保持 `VERSION` 与 `CHANGELOG.md` 顶部项目版本一致；`VERSION` / `CHANGELOG.md` / `TEMPLATE-BASE.md` 关系与 `PATCH` / `MINOR` / `MAJOR` 规则见 `ai/doc-standards/project-rules.md` §4 §2.4。可按项目交付节奏覆盖默认规则，但必须在本节写明；是否使用 git tag / GitHub Release：（待确认；默认不强制）。

## 2.5 运行时版本锁定

> 字段规范见 `ai/doc-standards/project-rules.md` §4 §2.5（与 §2.1 运行环境与资源约束正交：§2.1 管硬件资源，§2.5 管运行时版本与切换工具；工具推荐见 `template-docs/env-setup.md`「运行时版本管理」；声明落点 `docs/05-tech-spec.md` §1）。

- 是否启用运行时版本锁定：是 / 否 / 豁免
- 锁定的运行时与版本：（如 Node 16.13.0 / Python 3.11 / 多运行时）
- 版本声明文件：（如 `package.json` 的 `volta` 字段 / `.node-version` / `.python-version` / `.tool-versions` / `package.json#engines` / `pyproject.toml#requires-python`）
- 切换工具：（如 Volta / fnm / pyenv-win / asdf / Dev Container / 无）
- CI 校验方式：（如 `volta run` / `pyenv local` / Dev Container 自动切 / CI 显式断言 / 无）
- 锁定原因：（为什么必须锁这个版本，如“米家插件运行时要求 Node 16.x”）
- 豁免理由：仅当不启用或暂不补声明时填写，并说明风险、影响范围和补做时点

## 3. 项目形态与文档裁剪

> 本节用于初始化阶段，决定 docs/06、07 是否保留，以及 frontend/backend/tests/scripts/docker
> 哪些目录真正需要。此节应在生成 docs/03-09 之前先填好。

- 是否有持久化存储：（如有数据库 / 文件存储 / 无）
- 是否有对外接口：（如 REST API / SDK / CLI / 无）
- 演示形态：[消息通道内交互 / 独立 Web 页面 / 移动端 / CLI / 不需演示]（决定 `frontend/` 是否启用、`docs/04-05` 是否体现前端架构）
- 前端交互设计：需要 / 不需要 / 豁免（若需要，推荐 `docs/design/frontend-interaction.md`；若豁免，说明原因）
- UI 原型策略：需要 / 不需要 / 豁免（若需要，在 §2.3 记录原型形式、位置、覆盖范围和追溯；若豁免，说明原因）
- 通用详细设计：需要 / 不需要 / 豁免（若存在非平凡子系统、复杂权限 / 安全、AI / 外部服务、导入 / 异步任务、跨模块状态机、Mock / 降级差异或高风险愿景能力，推荐 `docs/design/<subsystem>.md`；若豁免，说明原因、风险和补做时点）
- System Skeleton Gate：需要 / 不需要 / 豁免（non-trivial 项目——多模块 / 有对外接口 / 有运行依赖——默认需要，首个业务 Sprint 前在 `docs/08-dev-plan.md` Sprint 0 + `docs/09-verification.md` 系统框架测试大纲落地框架验收；quick-script / 纯计算库 / 单文件工具可豁免，须说明原因、风险和补做时点；规则见 `ai/implementation-lifecycle-rules.md` §3）
- docs/06-db-design.md：保留 / 省略
- docs/07-api-spec.md：保留 / 省略
- 需要保留的代码目录：（如 frontend/ backend/ tests/ scripts/ docker/；不用的目录可删除）

按项目形态裁剪规则（docs/06 / 07 何时省略、`frontend/` 启用条件、详细设计 / 前端交互 / UI 原型触发条件、目录裁剪等）见 `ai/doc-standards/project-rules.md` §4 §3；本节裁剪决策须与 `docs/00-09` 实际结构一致，省略项留下说明，不适用的裁剪行可删除。

## 4. 目录规范的项目特例

（如本项目目录结构与 global-rules.md 的通用骨架有差异，在此说明；
 没有差异则写"无，遵循global-rules通用目录标准"）

## 5. 编码约定与禁区

> Phase 级功能禁止见 §1，技术栈替代品禁止见 §2，本节只管代码层。字段规范见 `ai/doc-standards/project-rules.md` §4 §5。
> 每条尽量具体可执行；没有则写“无”，不要留空占位。

### 5.1 既有约定（新代码必须向其看齐）
- 命名：（如后端 snake_case、前端 camelCase、组件 PascalCase）
- 分层与目录：（如 backend 分 api / service / model 三层，接口只进 api 层）
- 既有模式：（如统一用某基类 / 统一走某中间件鉴权，新代码沿用，勿另起炉灶）
- 错误处理 / 日志：（如统一异常类型、统一日志格式）

### 5.2 禁区（未经人工确认不得触碰）
- 不得擅改的文件 / 模块：（如鉴权模块、数据库迁移脚本、公共配置）
- 不得擅自引入的依赖：（列出，或写“任何新依赖须先确认”）
- 不得自行实现的功能：（点名为禁区，与 §1 互为补充）
- 愿景 / 01 中的功能点不等于已批准实现；阶段归属以 `docs/03-prd.md` §3 路线图为准，编码以 §1 当前阶段为准

## 6. AI修改确认规则

AI 修改确认规则（写入前说明目的 / 影响范围 / **预计文件** / 预计变更摘要 / 风险与验证方式；批量操作先列全部文件与每文件变更摘要；只读分析无需逐次确认但不借只读之名修改；单次授权仅限该次任务；**模板只能约束 AI 行为和项目期望**，不能替代工具权限模型，建议启用写入前确认 / patch 预览并用 `git status` / `git diff` 兜底）见 `ai/doc-standards/project-rules.md` §5。
