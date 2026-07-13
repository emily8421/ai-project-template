# TEMPLATE-UPGRADE: 派生项目登记与 Web App 架构 Runway

> 来源：模板维护者评估（基于 `ai-project-template`、`agent-system-template`、zhiyan / LUMEN / 后续 OA-PLM 类系统使用经验）
> 状态：候选 / 收件箱汇总完成（已纳入远端 issue #182/#184/#186/#187/#191/#192）
> 目标版本：分批确认
> Release impact：patch / minor（按批次拆分；AI 建议，待维护者确认）
> Release strategy：分批落地；先补收件箱汇总与低风险 Demo 检查，再落 UI 输入 / 原型 / Web Skeleton 主线

## 1. 背景与问题

当前模板已经支持普通派生项目和领域模板的部分版本治理：

- 普通派生项目可用 `sync-template.* --preserve-project-version` 保留项目自身 `VERSION` / `CHANGELOG.md`。
- 领域模板可用 `sync-template.* --domain-template` 保留领域模板自身版本，并由领域版 `TEMPLATE-BASE.md` 记录继承母模板版本。
- `agent-system-template` 已验证母模板 → 领域模板同步链路，并通过同步记录和 README 口径回梳收口。

但随着模板使用范围扩大，出现三个新的治理问题：

1. 模板维护者同时也是多个派生项目的使用者时，缺少一个轻量的“我维护了哪些普通项目 / 领域模板 / 领域派生项目”的可选登记表。
2. 直接从母模板派生普通项目、从母模板派生领域模板、从领域模板派生具体项目这三类场景尚未形成完整可执行路径。
3. Web 后端 + 前端交互类系统（如 zhiyan、LUMEN 知识库、后续 OA / PLM 子系统）如果只按小功能逐步堆叠，容易长期停留在 `App.jsx` / 少数文件内，后端跑通但前端无整体 UI shell、目录结构和演示体验，后续越改越重。

本提案将三者合并评估，但建议分批落地，避免一次性把母模板变重。

## 2. 非目标

- 不把所有用户的派生项目强制登记到母模板仓库。
- 不要求团队其他使用者公开或上报项目清单。
- 不在本提案阶段新增真实代码脚手架或强制技术栈。
- 不立即实现 `new-project --profile <domain>`。
- 不把 OA / PLM / 知识库等业务专属结构写入通用母模板。

## 3. 提案 A：派生项目 / 领域模板可选登记

### 3.1 目标

提供一个维护者侧、可选、低侵入的项目谱系登记方式，方便同时作为使用者和模板维护者的人管理自己的项目。

登记对象包括：

- 从母模板直接派生的普通项目。
- 从母模板派生的领域模板。
- 从领域模板派生的具体领域项目。

### 3.2 建议原则

- **项目内谱系仍以 `TEMPLATE-BASE.md` 为准**：每个项目自己记录“我从哪里来、当前同步到哪个上游版本”。
- **维护者侧 registry 只做索引**：记录项目名、简介、仓库、上游、最近同步等，不替代项目内事实。
- **默认不下行同步**：registry 是维护者私有 / 仓库治理记录，不应默认进入所有派生项目。
- **团队其他使用者可选**：如果愿意登记，只作为留痕；不应成为使用模板的前置条件。

### 3.3 候选字段

| 字段 | 说明 |
|---|---|
| Project name | 项目名 |
| Project type | ordinary project / domain template / domain-derived project |
| Repo URL | 仓库地址 |
| Short description | 项目简介 |
| Upstream template | 直接上游：`ai-project-template` 或某个领域模板 |
| Current inherited version | 当前同步到的模板版本 |
| Own version | 项目 / 领域模板自身版本 |
| Last sync date | 最近同步日期 |
| Status | active / paused / archived / experiment |
| Maintainer notes | 回流提案、风险、特殊同步说明 |

### 3.4 候选落地位置

可选方案：

| 方案 | 路径 | 优点 | 风险 |
|---|---|---|---|
| A | `ai-records/project-registry/` | 与 token-hotspots 类似，偏维护者记录 | 需明确不下行同步 |
| B | `template-records/project-registry.md` | 名称更直观 | 新增顶层目录可能增加模板复杂度 |
| C | `.ai/project-registry.md` | 明确本地私有 | 容易被忽略 / 不入版本控制 |

建议先采用 A 或 B，且不加入 `template-sync.json`。

## 4. 提案 B：三类派生场景分流

### 4.1 需要明确的三类场景

| 场景 | 角色 | 同步路径 | 当前状态 |
|---|---|---|---|
| 母模板 → 普通项目 | ordinary project | 普通项目 sync 母模板 | 基本成熟：`--preserve-project-version` |
| 母模板 → 领域模板 | domain template | 领域模板 sync 母模板 | 已验证：`agent-system-template` + `--domain-template` |
| 领域模板 → 具体领域项目 | domain-derived project | 具体项目 sync 领域模板 | 待设计 / 待验证 |

### 4.2 建议补充的场景入口

- A9 / `new-project`：普通项目直接从母模板派生。
- A20 / `domain-template-lab`：从母模板创建或维护领域模板。
- 新增候选场景：从领域模板派生具体领域项目，待 `agent-system-template` 形成领域同步清单和自检后再落地。

### 4.3 与现有提案关系

本部分应与 `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` 对齐，作为其中 Batch 3 / Batch 4 的补充输入，而不是替代原提案。

## 5. 提案 C：复杂 Web App 架构 Runway

### 5.1 问题判断

对 Web 后端 + 前端交互系统，当前“一个 Sprint 一个功能”的小步快跑容易出现：

- 初期所有前端内容写在 `App.jsx` 或少数文件中。
- 后端功能逐步跑通，但前端 UI shell、导航、信息架构和交互状态长期缺失。
- 真正要演示时，只能局部修字体、布局、组件，缺少总体框架。
- 后续重构成本越来越高，AI 也难以判断新功能应放在哪个目录。

结论：小步快跑原则仍然正确，但复杂 Web App 需要在功能 Sprint 前增加一个**架构骨架先行**的最小 runway，而不是先堆功能再重构框架。

### 5.2 建议实现路径

推荐路径：**先做最小总体框架，再做垂直功能切片**。

1. Sprint 0：Web App Architecture Runway / UI Shell
   - 前端目录结构。
   - 路由与 Layout。
   - 导航、主工作区、辅助面板。
   - 主题、字体、信息密度、spacing token。
   - API client 层。
   - Mock 数据层。
   - loading / empty / error / unauthorized / degraded 状态占位。
   - 基础 smoke test。
2. Sprint 1：第一个端到端 vertical slice
   - 一个真实功能从前端 → API → 后端 → 验证跑通。
   - 必须放入 Sprint 0 建立的目录和边界。
3. 后续 Sprint：逐步补功能
   - 不允许长期继续把功能堆进单文件。
   - 每个功能按 feature module / API contract / TC 追溯进入。

### 5.3 候选通用目录结构

不强制具体技术栈，但建议 Web App 类项目默认选择并记录一套目录结构。例如：

```text
frontend/
├─ src/
│  ├─ app/                 # app bootstrap, router, providers
│  ├─ layouts/             # shell layout, navigation
│  ├─ pages/               # route-level pages
│  ├─ features/            # feature modules
│  │  └─ <feature>/
│  │     ├─ components/
│  │     ├─ hooks/
│  │     ├─ api.ts
│  │     ├─ types.ts
│  │     └─ index.ts
│  ├─ shared/
│  │  ├─ components/
│  │  ├─ api/
│  │  ├─ utils/
│  │  └─ styles/
│  ├─ mocks/
│  └─ tests/
backend/
├─ src/
│  ├─ api/                 # routes / controllers
│  ├─ application/         # use cases / services
│  ├─ domain/              # domain models / rules
│  ├─ infrastructure/      # db / external services
│  ├─ schemas/             # DTO / validation
│  └─ tests/
shared/
└─ contracts/              # API contracts / shared schemas if needed
```

### 5.4 AI 编程 / 验证 / 审核收益

| 维度 | 收益 |
|---|---|
| AI 编程 | 减少“顺手写进当前文件”；新功能有明确归属 |
| 验证 | 固定检查路由、状态、API client、Mock、smoke test |
| 审核 | 可判断功能是否越界、是否破坏分层、是否绕过契约 |
| 长期演进 | 不同项目风格接近，模板维护者更容易 review |

### 5.5 建议规则补强位置

- `docs/05-tech-spec.md`：增加 Web 代码结构决策。
- `docs/design/frontend-interaction.md`：增加 UI shell / 信息架构 / 信息密度基线。
- `docs/08-dev-plan.md`：复杂 Web 项目要求 Sprint 0 scaffold。
- `docs/09-verification.md`：增加 UI shell smoke、关键路径 smoke、信息密度验收。
- `ai/implementation-lifecycle-rules.md`：明确复杂 Web 项目不能长期把实现堆在单文件中。

## 6. 母模板 vs 领域模板评估

### 6.1 建议结论

短期：放在母模板，但必须做成**触发式 / 可选 profile**，不要成为所有项目强制负担。

中期：在 zhiyan、LUMEN、OA / PLM 子系统等 2–3 个项目验证稳定后，再评估是否拆成 Web App / Knowledge Workbench / PLM 等领域模板或技术 profile。

### 6.2 分界原则

| 内容类型 | 母模板 | 领域模板 |
|---|---|---|
| 是否需要 Web 框架判断 | 是 | 否 |
| Web 项目何时需要 Sprint 0 | 是 | 否 |
| 通用目录分层原则 | 是 | 可继承 |
| React + FastAPI 具体 scaffold | 候选 / 谨慎 | 更适合 |
| OA / PLM 专用模块结构 | 否 | 更适合 |
| 知识库工作台 UI 风格 | 示例 / 候选 | 若反复复用则适合 |
| 真实代码生成脚手架 | 谨慎 | 更适合 |

母模板应负责规则、判断和最低边界；领域模板负责具体实现套路和领域标准件。

## 7. 综合汇总后的分批落地计划

### Batch 0：收件箱镜像与汇总提案收口（当前批次，低风险）

- 新增远端 issue 镜像：`_proposals/_remote-issues/issue-191.md`、`_proposals/_remote-issues/issue-192.md`。
- 更新本提案的远端 issue / 本地提案去重映射，把 #191 / #192 纳入 UI / Web 主线。
- 不修改正式模板规则、同步清单、自检脚本或版本文件；不关闭远端 issue。
- 版本影响：无功能版本 bump；若单独提交可作为 proposal-only / docs-only 维护提交。

### Batch 1：Demo 展示验证补强（来自 #184，低风险 patch）

- 补强 Demo runbook：端口占用预检、实际端口记录、页面身份校验。
- 补强 `show-demo` / demo 检查口径：不仅确认服务启动，还确认打开的是目标 Demo 页面。
- 与 Web App runway 关系：#184 解决“演示检查是否可靠”，不解决代码架构；可独立小 PR 落地。
- 版本影响建议：`PATCH`。

### Batch 2：Scenario Guide 编号治理（UI/Web 批次前置，minor）

- 先重梳 `template-docs/scenario-guides.md` 的场景编号规则，再新增 UI / Web 场景入口。
- 顶层场景编号只使用角色前缀 + 整数，例如 `A0`、`A1`、`C1`、`M0`；不再新增 `A5.6`、`A5.7` 这类小数编号。
- 阶段内分支 / 子流程使用语义化局部 ID，而不是小数插入：例如 `A5-UI-Brief`、`A7-PLM-01`、`A8-TechEnv`（最终命名在本批次内统一）。
- 迁移现有不规则编号：顶层 `A5.5`、`A7.5`、`A8.5` 以及 A7 PLM 子场景 `A7.1`–`A7.7` 需要统一为“顶层整数场景 + 语义化子流程 / 分支”，并保留旧编号 alias 表用于过渡。
- 场景先后关系不靠小数表达，改由“前置 / 下一步 / 触发条件 / 转入场景”字段表达，避免后续再插入 `A5.x`。
- 版本影响建议：`MINOR`，因为会调整使用者导航与多处场景引用。

### Batch 3：UI Brief Intake / 前端交互输入补齐（来自 #192，minor）

- 新增或扩展使用者场景：不使用 `A5.6` / `A5.7`；在 Batch 2 的编号规则下新增语义化入口（候选名：`A5-UI-Brief`），并在输入评审、需求探索原型、实现前 UI 原型策略中引用。
- 在 `ai/prompts/docs/01-review-inputs.md` 中增加 Web / UI 项目的交互体验抽取：参考产品、演示主线、页面结构、信息密度、首屏目标、设备范围、视觉禁区等。
- 新增 `template-docs/ui-brief-intake-template.md`，支持 `docs/inputs/ui-brief.md` 与 `docs/research/YYYY-MM-DD-ui-brief-intake.md` 两类落点。
- 在 `ai/document-lifecycle-rules.md`、`ai/commands/README.md`、`ai/prompts/docs/22-ui-prototype-exploration.md`、`ai/prompts/dev/02-run-task.md` 增加“缺 UI brief 时先补齐，不直接实现”的门禁。
- 与后续批次关系：UI brief 解决“输入够不够 / 用户想要什么体验”，是 #191 / #182 / #186 / #187 的前置输入。
- 版本影响建议：`MINOR`。

### Batch 4：UI Exploration Pipeline + Prototype Gate（合并 #191 + #182，minor）

- 将 UI brief、参考分析、需求探索原型、视觉效果探索、体验 brief、正式前端交互设计、实现前 UI 原型、08/09 验证串成可审计路径。
- 明确区分两类原型：需求探索原型（确认需求 / 信息架构 / 视觉方向）与实现前 UI 原型（确认正式设计的视觉和点击路径）。
- 增加晋级 Gate：从 inputs → reference analysis → exploration prototype → experience brief → frontend-interaction → 08/09 → 实现 / 验证。
- 补充默认行业 UI 标准原则：AI 应给出成熟产品 / 设计系统基线、信息密度和布局建议，而不是把专业 UI 判断从零抛给用户。
- 补充 UI 优先 / 后端优先 / 双轨并行判断，避免后续 Web Skeleton 只重代码结构、不重用户体验。
- 版本影响建议：`MINOR`。

### Batch 5：Web App Structure Profile + Walking Skeleton Gate（合并 #186 + #187，minor）

- 新增 `template-docs/web-fullstack-profile.md`，作为复杂 Web / 全栈交互项目的 Profile 说明、目录结构、Gate checklist 与示例位置。
- 在文档标准 / implementation lifecycle 中加入复杂 Web 项目的 Sprint 0 / UI Shell / 目录结构决策。
- 统一命名为 **Web App Structure Profile + Walking Skeleton Gate**，避免 #186 / #187 落成两套 Web skeleton 规则。
- 候选内容包括：推荐前后端目录结构、vertical slice、文件膨胀阈值、前端交互设计到代码结构追溯、审查 / 验证检查项。
- 与 #182 / #191 / #192 对齐：UI 输入与原型解决“长什么样 / 体验原则是什么”，Web Skeleton 解决“代码按什么结构长 / 最小纵切如何跑通”。
- 与 #184 对齐：Walking Skeleton 通过后，Demo runbook 负责验证启动端口和页面身份。
- 版本影响建议：`MINOR`。

### Batch 6：候选 profile / scaffold 实验

- 在真实项目或实验仓验证 Web App scaffold。
- 决定是否需要 `new-project --profile web-app`、`template-docs/web-app/` 或更具体的领域模板。
- 不在 Batch 5 之前直接实现真实脚手架，避免母模板过重。

### Batch 7：领域模板迁移评估

- 如果 2–3 个真实 Web 项目反复复用同一结构，再考虑拆出 `web-fullstack-app-template`、`knowledge-workbench-template`、`enterprise-admin-system-template` 或 `plm-management-system-template`。
- 若技术栈、组件库、权限模型、审计日志、表格 / 表单 / 工作流模式趋同，再从母模板轻量 Profile 迁移为独立领域模板。

## 8. 远端 issue 与本地提案去重评估

### 8.1 本轮参与分析的远端镜像

| 镜像路径 | Updated | Mirrored at | 核心主题 | 建议归属 |
|---|---|---|---|---|
| `_proposals/_remote-issues/issue-182.md` | `2026-07-12T16:12:24Z` | `2026-07-13 10:06:53 +08:00` | UI Prototype Gate、默认行业 UI 标准、UI / 后端 / 双轨顺序 | Batch 4 |
| `_proposals/_remote-issues/issue-184.md` | `2026-07-13T02:01:07Z` | `2026-07-13 11:15:52 +08:00` | Demo 端口占用、实际端口记录、页面身份校验 | Batch 1 |
| `_proposals/_remote-issues/issue-186.md` | `2026-07-13T02:47:10Z` | `2026-07-13 11:15:53 +08:00` | Web App Structure Profile、目录结构、Walking Skeleton | Batch 5 |
| `_proposals/_remote-issues/issue-187.md` | `2026-07-13T02:47:10Z` | `2026-07-13 11:15:54 +08:00` | Web 全栈骨架门禁、目录结构、单文件膨胀阈值 | Batch 5 |
| `_proposals/_remote-issues/issue-191.md` | `2026-07-13T07:16:13Z` | `2026-07-13 15:26:53 +08:00` | UI Exploration to Delivery Pipeline、体验 brief、晋级 Gate | Batch 4 |
| `_proposals/_remote-issues/issue-192.md` | `2026-07-13T07:21:59Z` | `2026-07-13 15:26:53 +08:00` | UI Brief Intake、交互体验抽取、输入补齐 | Batch 3 |

### 8.2 Issue 映射

| Issue / 提案 | 核心主题 | 去重判断 | 建议归属 |
|---|---|---|---|
| #182 `ui-prototype-gate` | UI 原型确认、默认行业 UI 标准、UI / 后端 / 双轨顺序 | 与 #191 同属 UI 体验门禁，但 #182 聚焦实现前原型与顺序判断，不应被 Web skeleton 吞并 | Batch 4 |
| #184 Demo 端口占用与页面身份校验 | Demo runbook、端口漂移、页面身份校验 | 与 Web 架构关系弱，可独立小修 | Batch 1 |
| #186 Web 交互型系统代码框架与 Walking Skeleton | Web App Structure Profile、目录结构、Walking Skeleton | 与 #187 高度重叠，应合并落地 | Batch 5 |
| #187 `web-fullstack-skeleton-gate` | Web 全栈骨架门禁、目录结构、单文件膨胀阈值 | 与 #186 高度重叠，应合并落地 | Batch 5 |
| #191 `ui-exploration-to-delivery-pipeline` | UI brief → reference analysis → exploration prototype → experience brief → frontend-interaction → 08/09 → implementation | 是 #192 与 #182 之间的总线；与 #182 相邻但不重复 | Batch 4 |
| #192 `ui-brief-intake-guidance-scenario` | UI 输入补齐、交互体验抽取、低门槛问题模板 | 是 #191 / #182 / #186 / #187 的前置输入，不应并入原型或代码骨架门禁 | Batch 3 |
| 本提案 | project registry、三类派生场景、Web runway 总体评估、scenario 编号治理 | project registry / 三类派生场景为独有；Web runway 与 #186/#187 重叠；UI 主线需纳入 #191/#192；编号治理需先行 | Batch 0 / Batch 2 / Batch 5 |

### 8.3 本地提案关系

| 本地提案 | 核心主题 | 与本提案关系 | 建议处理 |
|---|---|---|---|
| `_proposals/TEMPLATE-UPGRADE-project-registry-and-web-app-runway.md` | 派生项目登记、三类派生场景、Web App runway | 本提案作为远端 issue 与本地提案的汇总入口 | 持续维护分批计划；落地后按批次拆 PR |
| `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` | 领域模板继承、领域模板版本治理、agent-system-template | 与 Batch 7 有依赖关系；Web 领域模板迁移应等待领域模板机制稳定 | 不并入 UI/Web 实现 PR；仅在领域模板迁移评估时引用 |
| `_proposals/TEMPLATE-UPGRADE-docs-scaffold-followups.md` | docs scaffold 后续补强 | 与 Batch 3/4/5 的文档模板和 docs scaffold 自检可能交叉 | 落地 UI brief / web profile 时检查是否需要同步更新 docs scaffold 断言 |
| `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md` | token 热点观察记录与回流机制 | 与 UI/Web 主线无直接功能重叠；可用于长任务续接成本观察 | 不阻塞本提案；若 Batch 3/4/5 很长，可记录 hotspot |

### 8.4 合并原则

- #192 不应被 #191 或 #182 吞并：UI Brief Intake 是输入补齐，不是原型产物，也不是实现前 UI Gate。
- #191 不应被 Web Skeleton 吞并：它是 UI 探索到交付的文档 / 体验总线，不规定代码目录结构。
- #182 不应被 Web Skeleton 吞并：UI 原型 Gate 是设计 / 交互门禁，Web Skeleton 是代码架构 / 演示骨架门禁。
- #186 与 #187 不应分别落地为两套 Web skeleton 规则；统一成一个 Web App Structure Profile。
- #184 不应被复杂 Web runway 阻塞；Demo 端口与页面身份校验可作为独立 patch 提前落地。
- project registry 不应和 Web App 规则混入同一实现 PR；它是维护者治理记录，不影响 Web 项目代码结构。

### 8.5 建议优先级

1. **先提交 Batch 0**：镜像 #191/#192 并更新本提案汇总，不改变模板行为。
2. **再落 #184**：小而独立，能立即提升 Demo 检查可靠性。
3. **先做 Scenario Guide 编号治理**：取消新增小数编号，统一顶层整数场景与语义化子流程。
4. **再落 #192**：补 UI Brief Intake，让后续 UI 原型 / Web Skeleton 有输入前提。
5. **再合并 #191/#182**：形成 UI Exploration Pipeline + Prototype Gate，明确体验输入、原型、正式设计和 08/09 回填。
6. **再合并 #186/#187**：形成 Web App Structure Profile + Walking Skeleton Gate。
7. **并行评估 project registry**：可作为治理小修独立落地，不阻塞 Web 规则。
8. **最后评估 profile / 领域模板迁移**：至少经过 2–3 个真实 Web 项目验证后再决定。

## 9. 写入后复评：遗漏、冲突与需修改内容

### 9.1 未发现的遗漏

- 远端 open proposal / `TEMPLATE-UPGRADE:` issue 已纳入：#182、#184、#186、#187、#191、#192。
- 本地待处理提案已纳入关系评估：docs scaffold followups、domain template inheritance、project registry / web app runway、token hotspot records。
- 新增 issue #191 / #192 已先镜像到本地，再进入分析，符合远端 issue 镜像门禁。

### 9.2 仍需后续落地时复查的内容

- 场景编号：不再新增 `A5.6` / `A5.7` 这类小数编号；先由 Batch 2 重梳 `scenario-guides` 编号规则。当前已发现顶层 `A7.5 UI 原型策略` 与 A7 PLM 子场景 `A7.5 由详细设计拆 Sprint 和任务` 语义冲突，需统一治理。
- 产物路径：`docs/inputs/ui-brief.md` 与 `docs/research/YYYY-MM-DD-ui-brief-intake.md` 都有合理性；落地时需在模板中明确“原始输入补充 vs AI 共同探索记录”的判定。
- 新增模板文件：`template-docs/ui-brief-intake-template.md`、`template-docs/web-fullstack-profile.md` 当前不存在；落地批次需纳入 `template-sync.json` 和 `scripts/check-template.*`。
- Prompt 触发链：Batch 3/4/5 会同时触及 `ai/prompts/docs/01-review-inputs.md`、`ai/prompts/docs/22-ui-prototype-exploration.md`、`ai/prompts/dev/02-run-task.md`，需要避免重复拦截和互相跳转死循环。
- 版本节奏：Batch 1 可 `PATCH`；Batch 2/3/4/5 都是场景导航、AI 引导路径或 Profile 级新增 / 调整，倾向 `MINOR`；Batch 0 不 bump。
- 归档与 issue 关闭：每个 Batch PR 合并后，再关闭对应 issue 或标注后续批次；不要在 Batch 0 关闭 #182/#184/#186/#187/#191/#192。

### 9.3 建议现在修改的内容

- 当前只需保留本提案汇总和新增 issue 镜像。
- 不建议在本提案 PR 中直接修改正式模板规则、版本号或 CHANGELOG，避免 proposal-only 汇总与实现改动混在一起。
- 若维护者希望先落地一个功能 PR，建议从 Batch 1（#184）开始，而不是直接做 Batch 5。

## 10. 验收标准

本提案评估阶段：

- 能区分项目内谱系和维护者侧 registry。
- 能列出普通项目 / 领域模板 / 领域派生项目三类场景。
- 能说明复杂 Web App 为什么需要 Sprint 0 / architecture runway。
- 能给出母模板与领域模板的分界原则。
- 能说明 UI Brief Intake、UI Exploration Pipeline、UI Prototype Gate、Web Skeleton Gate 的先后关系与边界。
- 不修改正式规则、同步清单、自检脚本或版本文件。

后续落地阶段：

- Web / UI 类项目在输入评审、原型探索、详细设计、执行 Sprint 前能识别 UI 输入缺口。
- Web 类项目在生成 `docs/08-dev-plan.md` 时能识别是否需要 Sprint 0 / Walking Skeleton。
- 前端实现任务不会长期把复杂功能堆在单文件中。
- 审查时能依据 UI brief、frontend-interaction、目录结构和模块边界判断实现是否越界。
- 对纯后端、CLI、小脚本项目可明确豁免，不增加负担。

## 11. 待确认项

| ID | 待确认项 | AI 建议 | 备选方案 | 影响 |
|---|---|---|---|---|
| C-001 | project registry 放在哪里 | 先放非同步的 `ai-records/project-registry/` 或独立 `template-records/` | 放 `.ai/` 或暂不落盘 | 影响是否版本控制、是否同步给下游 |
| C-002 | Web App 目录结构是否作为默认推荐 | 作为触发式推荐，不强制所有项目 | 只写原则，不给目录 | 不给目录会降低 AI 编程与 review 一致性 |
| C-003 | 是否新增 `web-app` profile | 暂缓，先规则化 + 真实项目验证 | 立即实现 | 立即实现可能让母模板变重 |
| C-004 | #182 与本提案是否合并落地 | 与 #191 合并为 Batch 4，避免体验门禁碎片化 | 完全分开 | 分开会重复修改 UI 原型相关规则 |
| C-005 | 领域派生项目同步路径何时实现 | 等 `agent-system-template` 自检和领域 sync 清单成熟后 | 现在实现 | 现在实现可能把三层同步风险带入主路径 |
| C-006 | #191 / #192 场景编号如何安排 | 用户已确认：不要 `A5.6` / `A5.7` 这类小数编号；先做 Scenario Guide 编号治理，再按语义化子流程命名 | 继续用小数编号 | 小数编号缺少规律且已出现语义冲突，不利于长期扩展 |
| C-007 | UI brief 路径放 `docs/inputs` 还是 `docs/research` | 用户已确认采用 AI 建议：两者都支持，按来源区分 | 固定一个路径 | 固定路径可能混淆原始输入与 AI 共同探索记录 |
| C-008 | Batch 0 是否单独提交 | 用户已确认采用 AI 建议：单独提交 proposal-only 汇总 | 直接并入 Batch 1 | 单独提交便于审计；并入实现 PR 会放大 review 面 |
