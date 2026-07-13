# TEMPLATE-UPGRADE: 派生项目登记与 Web App 架构 Runway

> 来源：模板维护者评估（基于 `ai-project-template`、`agent-system-template`、zhiyan / LUMEN / 后续 OA-PLM 类系统使用经验）
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：patch / minor（AI 建议，待维护者确认）
> Release strategy：分批落地；先补规则与记录规范，代码脚手架 / profile 后续评估

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

## 7. 去重后的分批落地计划

### Batch 1：提案收件箱与谱系记录补强（低风险）

- 明确可选 project registry 记录规范。
- 明确三类派生场景：普通项目、领域模板、领域派生项目。
- 不新增强制同步文件，不改默认项目创建行为。
- 对应本提案独有内容；不与 #182 / #184 / #186 / #187 重叠。

### Batch 2：Demo 展示验证补强（来自 #184，低风险 patch）

- 补强 Demo runbook：端口占用预检、实际端口记录、页面身份校验。
- 补强 `show-demo` / demo 检查口径：不仅确认服务启动，还确认打开的是目标 Demo 页面。
- 与 Web App runway 关系：#184 解决“演示检查是否可靠”，不解决代码架构；可独立小 PR 落地。

### Batch 3：UI Prototype Gate 补强（来自 #182）

- 补充“默认行业 UI 标准原则”：AI 不应把字号、密度、导航模式等专业判断从零抛给用户。
- 补充“UI 优先 / 后端优先 / 双轨并行”判断。
- 回填位置以 `ai/doc-standards/ui-prototype-strategy.md`、`ai/doc-standards/frontend-interaction.md`、`ai/implementation-lifecycle-rules.md` 为主。
- 与 Web App runway 关系：#182 解决“界面方向与信息密度先确认”，不直接规定代码目录结构。

### Batch 4：Web App Structure Profile / Walking Skeleton Gate（合并 #186 + #187）

- 在文档标准 / implementation lifecycle 中加入复杂 Web 项目的 Sprint 0 / UI Shell / 目录结构决策。
- 合并 #186 的“Web 交互型系统代码框架与 Walking Skeleton 门禁”和 #187 的“web-fullstack skeleton gate”，统一命名为 **Web App Structure Profile + Walking Skeleton Gate**。
- 候选内容包括：推荐前后端目录结构、vertical slice、文件膨胀阈值、前端交互设计到代码结构追溯、审查 / 验证检查项。
- 与 #182 对齐：UI 原型解决“界面方向”，Web runway 解决“代码结构与演示骨架”。
- 与 #184 对齐：Walking Skeleton 通过后，Demo runbook 负责验证启动端口和页面身份。

### Batch 5：候选 profile / scaffold 实验

- 在一个真实项目或实验仓验证 Web App scaffold。
- 决定是否需要 `new-project --profile web-app` 或 `template-docs/web-app/`。
- 不在 Batch 4 之前直接实现真实脚手架，避免母模板过重。

### Batch 6：领域模板迁移评估

- 如果多项目复用同一结构，再考虑拆出 `web-app-template`、`knowledge-workbench-template` 或 `plm-system-template`。

## 8. 远端 issue 去重评估

### 8.1 Issue 映射

| Issue / 提案 | 核心主题 | 去重判断 | 建议归属 |
|---|---|---|---|
| #182 `ui-prototype-gate` | UI 原型确认、默认行业 UI 标准、UI / 后端 / 双轨顺序 | 已有 UI 原型机制部分覆盖，但默认行业标准与顺序判断仍有增量 | Batch 3 |
| #184 Demo 端口占用与页面身份校验 | Demo runbook、端口漂移、页面身份校验 | 与 Web 架构关系弱，可独立小修 | Batch 2 |
| #186 Web 交互型系统代码框架与 Walking Skeleton | Web App Structure Profile、目录结构、Walking Skeleton | 与 #187 高度重叠，应合并落地 | Batch 4 |
| #187 `web-fullstack-skeleton-gate` | Web 全栈骨架门禁、目录结构、单文件膨胀阈值 | 与 #186 高度重叠，应合并落地 | Batch 4 |
| 本提案 | project registry、三类派生场景、Web runway 总体评估 | project registry / 三类派生场景为独有；Web runway 与 #186/#187 重叠 | Batch 1 / Batch 4 |

### 8.2 合并原则

- #186 与 #187 不应分别落地为两套 Web skeleton 规则；统一成一个 Web App Structure Profile。
- #182 不应被 Web skeleton 吞并；UI 原型 Gate 是设计 / 交互门禁，Web skeleton 是代码架构 / 演示骨架门禁。
- #184 不应被复杂 Web runway 阻塞；Demo 端口与页面身份校验可作为独立 patch 提前落地。
- project registry 不应和 Web App 规则混入同一实现 PR；它是维护者治理记录，不影响 Web 项目代码结构。

### 8.3 建议优先级

1. **先落 #184**：小而独立，能立即提升 Demo 检查可靠性。
2. **再落 #182 的增量**：补默认行业 UI 标准和 UI / 后端 / 双轨顺序判断，避免后续 Web skeleton 只重代码不重体验。
3. **再合并 #186/#187**：形成 Web App Structure Profile + Walking Skeleton Gate，明确目录结构、文件膨胀阈值和 vertical slice。
4. **并行评估 project registry**：可作为治理小修独立落地，不阻塞 Web 规则。
5. **最后评估 profile / 领域模板迁移**：至少经过 2–3 个真实 Web 项目验证后再决定。

## 9. 验收标准

本提案评估阶段：

- 能区分项目内谱系和维护者侧 registry。
- 能列出普通项目 / 领域模板 / 领域派生项目三类场景。
- 能说明复杂 Web App 为什么需要 Sprint 0 / architecture runway。
- 能给出母模板与领域模板的分界原则。
- 不修改正式规则、同步清单、自检脚本或版本文件。

后续落地阶段：

- Web 类项目在生成 `docs/08-dev-plan.md` 时能识别是否需要 Sprint 0。
- 前端实现任务不会长期把复杂功能堆在单文件中。
- 审查时能依据目录结构和模块边界判断实现是否越界。
- 对纯后端、CLI、小脚本项目可明确豁免，不增加负担。

## 10. 待确认项

| ID | 待确认项 | AI 建议 | 备选方案 | 影响 |
|---|---|---|---|---|
| C-001 | project registry 放在哪里 | 先放非同步的 `ai-records/project-registry/` 或独立 `template-records/` | 放 `.ai/` 或暂不落盘 | 影响是否版本控制、是否同步给下游 |
| C-002 | Web App 目录结构是否作为默认推荐 | 作为触发式推荐，不强制所有项目 | 只写原则，不给目录 | 不给目录会降低 AI 编程与 review 一致性 |
| C-003 | 是否新增 `web-app` profile | 暂缓，先规则化 + 真实项目验证 | 立即实现 | 立即实现可能让母模板变重 |
| C-004 | #182 与本提案是否合并落地 | 分开评估，落地时合并相邻规则修改 | 完全合并为一个大 PR | 大 PR 容易影响面过大 |
| C-005 | 领域派生项目同步路径何时实现 | 等 `agent-system-template` 自检和领域 sync 清单成熟后 | 现在实现 | 现在实现可能把三层同步风险带入主路径 |
