# C1 模板提案汇总与评估报告：两批 MINOR 落地计划

> 生成日期：2026-08-18
> 定位：模板维护者决策参考（AI 评估 + 建议）；本报告为只读 triage 结论，本轮未执行任何落地改动。
> 评估基线：`HEAD ff68cd2`（= `main`，v1.62.1）、2026-08-18 远端 open issue 元数据、本地 `_proposals/` 4 份提案 + 15 个镜像。
> 前序报告：`docs/research/2026-08-12-c1-proposal-triage-template-proposals.md`（首轮）、`docs/research/2026-08-12-c1-proposal-triage-reassessment.md`（复评，含 #333 Batch A 已落地记录）。本报告不覆盖历史结论。
> 拍板记录：**C-011 已于 2026-08-18 由维护者确认采用方案 1**（v1.63.0 = Batch A 两 PR；v1.64.0 = Batch B+C 聚合）。其余待确认项见 §9。

## 0. 执行摘要

本轮为 2026-08-17 会话分析的全量复核（无新增输入）：远端 open issue 9 个与本地镜像逐一比对全部一致、镜像全部新鲜；4 份本地提案状态未变。7 个 issue + 1 份本地提案构成两个 MINOR 批次，#334/#290 与 3 份本地提案剩余项维持既有 Gate 延后。

| 对象 | 处置 | 批次 / 版本 |
|---|---|---|
| #356 02/04 引用式概述骨架 + 元信息精简 | 采纳 | Batch A / PR A1 → v1.63.0 |
| #355 反向同步落点约束 + 阶段归属审计 | 采纳 | Batch A / PR A1 → v1.63.0 |
| #354 OO 建模 overlay（可选） | 按原力度部分采纳 | Batch A / PR A2 → v1.63.0 |
| #358 图表生成式镜像目录 + CI 校验 | 采纳 | Batch A / PR A2 → v1.63.0 |
| #351 形态裁剪执行落地（--shape + 步骤 + 审计项 + 地图） | 采纳 | Batch B → v1.64.0 |
| #357 2.2 目录分类框架 + 来源标注 | 采纳（与 #351 2.4 地图合并落） | Batch B → v1.64.0 |
| #357 2.1 根目录物理归拢 | 暂缓，另立评估（MAJOR） | 不在批 |
| #350 pitfall 触发口径扩展 | 采纳 | Batch B → v1.64.0（patch 聚合） |
| 本地 project-scenario-handbook | 采纳 | Batch B → v1.64.0（patch 聚合） |
| #334 Stack Adapter | 维持暂缓（等 ≥2 独立项目实证） | 延后池 |
| #290 domain docs reorg | 维持 DEFER | 延后池 |
| 本地 inheritance / check-maintainability / governance 剩余 | 维持各自 Gate | 延后池 |

## 1. 评估范围与证据

### 1.1 镜像门禁检查

远端 open issue 9 个（`gh issue list --state open` 实查）：#290 / #334 / #350 / #351 / #354 / #355 / #356 / #357 / #358，无 `feedback` 标签条目，与本地镜像集合完全一致。

| 镜像路径 | State | remote Updated | Mirrored at | 新鲜度 |
|---|---|---|---|---|
| `_proposals/_remote-issues/issue-290.md` | OPEN | 2026-07-29 | 2026-08-01 | fresh |
| `_proposals/_remote-issues/issue-334.md` | OPEN | 2026-08-12 | 2026-08-12 | fresh |
| `_proposals/_remote-issues/issue-350.md` | OPEN | 2026-08-13 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-351.md` | OPEN | 2026-08-16 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-354.md` | OPEN | 2026-08-17 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-355.md` | OPEN | 2026-08-17 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-356.md` | OPEN | 2026-08-17 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-357.md` | OPEN | 2026-08-17 | 2026-08-17 | fresh |
| `_proposals/_remote-issues/issue-358.md` | OPEN | 2026-08-17 | 2026-08-17 | fresh |

CLOSED 6 个（#314 / #320 / #322 / #332 / #333 / #335）已由 PR #360 刷新至 CLOSED 状态，本轮不参与分批，仅涉归档（§8）。本轮分析全部输入来自上表本地镜像路径与 `_proposals/TEMPLATE-UPGRADE-*.md`，满足镜像硬门禁。

### 1.2 本地提案

| 提案 | 状态 |
|---|---|
| `_proposals/TEMPLATE-UPGRADE-template-check-maintainability.md` | P1 / P2.3 / P2.4 / P2.1 保守版已落地（至 v1.56.13）；P2.1 物理拆分、P2.2 继续观察 |
| `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` | Batch 1 / 2 / 3（部分）/ C-004 已落地；多级同步自动化、Batch 4 待真实域项目 Gate |
| `_proposals/TEMPLATE-UPGRADE-governance-handbook-agent-tool-registry.md` | Batch 1 已落地（v1.61.6）；Batch 2-5 未授权 |
| `_proposals/TEMPLATE-UPGRADE-project-scenario-handbook.md` | 候选，未落地（patch 级，2 文件小改）→ 本批采纳 |

### 1.3 Git 事实

`main` @ `ff68cd2`（v1.62.1），工作区干净，与 `origin/main` 一致。

## 2. 去重 / 冲突 / 依赖分析

### 2.1 去重（合并同类项）

- **#351 §2.4 根目录三层地图 ≈ #357 §2.2 目录分类框架**：两者都在定义「模板方法论（同步覆盖）/ 模板治理（本地记录）/ 项目产出（项目自有）」三区归属，仅落点不同（beginner-guide 呈现 vs global-rules §5 规则口径 + README 模板）。**合并为一份「根目录三层地图」**：`ai/global-rules.md` §5 立规则口径，`template-docs/beginner-guide.md` 与根 README 模板放呈现并互指，不在两处双写规则正文；机器事实源仍为 `template-sync.json`。
- #355 的 03/04 禁条可审计化与 #356 的元信息精简同触 doc-standards 03/04，正交但同窗口落地。
- 本地 project-scenario-handbook 与 #351 §2.4 同触「项目自有目录指引」主题，但对象不同（场景手册选址 vs 根目录三层地图），互补不重复。

### 2.2 冲突（同文件协调）

- **#354 与 #358 同改 `ai/document-lifecycle-rules.md` §13**：#354 补 plantuml 用例图指引，#358 补镜像机制附注 → 必须同批（PR A2）内协调段落，避免互相覆盖。
- **#356 与 #354 同改 doc-standards 02/04**：#356 补概述章骨架、#354 在同文件挂 OO overlay 条目 → 先 PR A1 立骨架、后 PR A2 挂 overlay，顺序固定（A1 先合）。
- #356 元信息口径（00-05）与 #355 的 03/04 审计项同在 PR A1 窗口内落。

### 2.3 依赖（先后序）

- #351 内部：§2.2 裁剪执行步骤（保底路径）先于 §2.1 `--shape` 参数（`--shape docs` ≡ 事后执行裁剪，语义依赖 §2.2 定义）；同批落地时按此顺序写。
- #357 内部：2.2 分类框架先于 2.1 物理归拢；2.1 为 MAJOR，另立评估，不在本两批。
- #358 镜像索引的阶段分组在 #354 图型清单确定后更稳，但提案自述正交、可独立采纳；本批仍按 A1 → A2 顺序落，自然满足。
- Batch A 不依赖 Batch B，可先行。

## 3. 分批落地计划（C-011 已拍板方案 1）

### 3.1 v1.63.0（MINOR）Batch A：Doc Standards 文档体系治理

| PR | 内容 | 理由 |
|---|---|---|
| **PR A1** | #356（02/04 引用式概述骨架 + 00-05 元信息精简 + 三核心节点定位）+ #355（E6 反向同步落点约束 + 19-docs-evaluation 阶段归属审计维度 + 03/04 禁条可审计化） | 同属「文档该有什么章节、内容放哪层」；先立骨架与落点规则 |
| **PR A2** | #354（OO 建模 overlay：用例图 / 领域模型 / 概设类图 / 交互图 / 状态图族 / ERD 图 ID + §13 plantuml 指引，全部「建议 + 可选」）+ #358（docs/diagrams + docs/tables 生成式镜像 + INDEX + `extract-diagrams` 脚本样例 + §13 附注 + docs/README 分区登记） | 图纸要求与图纸分发同属「图表层」；依赖 A1 的 02/04 骨架先位 |

A1 先合、A2 后合（02/04 与 §13 两处重叠按此序落）。#354 维持提案自述的「建议 + 可选、最小增量」力度，不升级为 Full 剖面强制项（C-012 口径，见 §9）。

### 3.2 v1.64.0（MINOR）Batch B+C：形态裁剪与场景指引

- #351：§2.2 裁剪显式执行步骤（P1）+ §2.3 post-sync-cleanup 审计项（P1）+ §2.1 `--shape` 参数（P2）+ §2.4 根目录地图（P1，与 #357 2.2 合并落）。
- #357 **仅 2.2**：根目录分类框架 + 来源标注；2.1 物理归拢另立。
- #350：pitfall 触发口径扩展（+2 bullet / 1 句定位），patch 级。
- 本地 project-scenario-handbook：scenario-guides §8 改写 + 14-new-project 步骤 9 追加，patch 级。
- 后两项 patch 聚合进本 MINOR 版本发布（不单独递增）。

### 3.3 暂缓 / 延后池

| 项 | 理由 / Gate |
|---|---|
| #334 Stack Adapter | 等 ≥2 个相互独立真实项目同栈实证 + 校正复评报告 §5.3 的 7 项技术问题（Protocol 结构化类型、`runtime_checkable` 局限、禁 `any` 过绝对等） |
| #290 domain docs reorg | DEFER 复活条件未满足（第二个领域模板 / 多级同步落地，均未发生） |
| #357 §2.1 物理归拢 | MAJOR；影响 `template-sync.json`、同步脚本与全量派生引用，单独评估 |
| 本地 inheritance 剩余 | 多级同步自动化 + Batch 4 profile，Gate = 真实域项目试用 |
| 本地 check-maintainability P2.1/P2.2 | 继续观察漂移 / 冲突实证，不永久关闭（复评 RE-006 口径） |
| 本地 governance Batch 2-5 | 未授权；Batch 2 手册重构起逐批评估 |

## 4. 拟修改文件清单（执行时核对）

| Batch | 文件 | 改动 |
|---|---|---|
| A1 | `ai/doc-standards/02-srs.md` | 增引用式概述章（引言 / 任务概述 / 数据描述 / 性能需求 / 运行需求 / 其它需求，每节 2-5 行 + 指针） |
| A1 | `ai/doc-standards/04-architecture.md` | 增概要级概述章（需求概述 / 接口设计 / 数据结构 / 安全保密 / 维护设计） |
| A1 | `ai/doc-standards/00-05`（元信息口径） | 「当前状态」精简为「一句话状态 + 历史指针」 |
| A1 | `ai/document-lifecycle-rules.md` §2 E6 | 反向同步落点约束 |
| A1 | `ai/prompts/review/19-docs-evaluation.md` | 增「阶段归属审计」维度 |
| A1 | `ai/doc-standards/03-prd.md` / `04-architecture.md` | 「不写实现细节」禁条补可审计检查项 |
| A1 | `docs/README.md` scaffold（或 docs-scaffold README） | 三核心节点定位（需求规格 = 02 / 概要设计 = 04 / 详细设计 = 06+07+design） |
| A2 | `ai/doc-standards/00-scenario.md` ~ `02-srs.md` | OO 建模 overlay（用例图 DIAG-UC / 领域模型 DIAG-DOM，可选） |
| A2 | `ai/doc-standards/04-architecture.md` | 概要级交互图 + 可选概设类图（DIAG-CLS-PRELIM） |
| A2 | `ai/doc-standards/design-doc.md` | 详细类图（含豁免登记口径）+ 状态图族（DIAG-STATE） |
| A2 | `ai/doc-standards/06-db-design.md` | ERD 图 ID 合规（DIAG-DB-ER）+ 概念 / 物理 ERD 两层区分 |
| A2 | `ai/document-lifecycle-rules.md` §13 | plantuml 用例图指引 + 图表镜像机制附注 |
| A2 | `docs/README.md` scaffold | diagrams / tables 分区登记 + 五阶段产物映射表 |
| A2 | `template-docs/`（附 `scripts/extract-diagrams.mjs` 样例） | 镜像抽取脚本样例；**需登记同步清单与自检断言核对** |
| B | `scripts/new-project.sh` | `--shape <docs|cli|web>` 可选参数（缺省不裁剪） |
| B | `ai/doc-standards/project-rules.md` | §3 裁剪决策显式执行步骤 |
| B | `ai/commands/post-sync-cleanup.md` + `ai/prompts/maintainers/15-post-sync-cleanup.md` | 审计项：「§3 声明不启用 / 省略，但目录或骨架文档仍存在」 |
| B | `ai/global-rules.md` §5 | 根目录三层地图（与 #357 2.2 合并立规则口径） |
| B | `template-docs/beginner-guide.md` | 根目录三层地图表呈现 |
| B | 根 README 模板 | 项目结构三大区分类说明 |
| B | `ai/session-rules.md` §4.3 | pitfall 存量维护触发场景 + 机制定位句 |
| B | `template-docs/scenario-guides.md` §8 | 项目特有场景手册指引（选址 / 格式 / 编号隔离） |
| B | `ai/prompts/setup/14-new-project.md` 步骤 9 | 追加场景手册待办一条 |

> 全部落地 diff 需**去项目化**：清除 LUMEN / web-ui-knowledge-base 项目名、派生路径、CQ / TQG 类外部编号引用（保留「已有派生项目实证」一级表述）；#354 清单见复评报告 §15.3 口径。

## 5. 版本影响

| 项 | 版本判断 | 依据 |
|---|---|---|
| Batch A（PR A1 + A2） | **MINOR → v1.63.0** | doc-standards 新增骨架章节要求 + 新可选能力层（OO overlay、镜像机制、样例脚本入同步）= 新下游采用面 |
| Batch B+C（#351 + #357 2.2 + #350 + handbook） | **MINOR → v1.64.0** | #351 改变推荐初始化 / 审计工作流 + `--shape` 新采用面；#350 / handbook 为 patch 级聚合发布 |
| #357 §2.1 物理归拢 | MAJOR（另立） | 根目录迁移 + 同步机制变更 |
| 延后池全部 | none | 无落地变化 |

## 6. 验证方式

1. `bash scripts/check-template.sh` 与 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`（CI 权威自检）；A2 新增脚本样例与 docs/README 分区涉及同步清单 / 断言核对。
2. `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1` 覆盖全部改动文件。
3. Batch B：`--shape` 各取值 `--no-remote --local` 烟测（含 `--shape web` 与现状 diff 为空）；post-sync-cleanup 用「声明省略但 06 仍存在」故意样本验证命中。
4. 人工评审三处重叠：§13（#354/#358）、02/04（#356/#354）、根目录地图（#351/#357）——确认无双写、无第二权威源。
5. 去项目化复查：全 diff 无 LUMEN / CQ / TQG / 派生路径残留。
6. 下行同步 4 个派生仓验证（agent-system-template / zhiyan-digital-cs-platform / digital-cs-demo / LUMEN-DEMO，当前均 v1.61.4，落后 v1.62.x 两版）。

## 7. 远端 issue 处置计划（均待落地后单独复核执行）

- 落地合并后关闭：#350 / #351 / #354 / #355 / #356 / #357（#357 关闭评论注明 §2.1 另立评估、仅 §2.2 吸收）。
- #334 / #290 维持 OPEN（暂缓 / DEFER，无动作）。
- 关闭前按门禁做「open 列表 + 单项状态」复核。

## 8. 归档计划

- 落地后 7 个镜像（#350/#351/#354-#358）随吸收移入 `_archive/proposals/_remote-issues/`，归档说明列各自吸收范围。
- CLOSED 6 镜像（#314 / #320 / #322 / #332 / #333 / #335）归档至同目录，吸收范围：#314 → session-rules §6.1；#320 → implementation-lifecycle-rules §6（v1.61.0）；#322 → global-rules §2.1 L0（v1.61.0）；#332 → 通用层应用说明（v1.61.4）；#333 → web-fullstack-profile §9（v1.61.2）；#335 → 选 A + gap（v1.61.3）。
- 本地 project-scenario-handbook 落地后归档；其余 3 份本地提案保留（各有未决 Gate / Batch）。

## 9. 待人工确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| ~~C-011~~ | 分批方案 | **已拍板（2026-08-18）：方案 1**——v1.63.0 = Batch A（PR A1+A2）；v1.64.0 = Batch B+C+handbook | 一批一范围；§13、02/04 重叠需同窗口协调 | 聚合为一个 MINOR 一次落地 | 已决；后续按此执行 |
| C-012 | #354 / #358 采纳力度 | 按提案自述「建议 + 可选、最小增量」采纳，不强制 | 与 §13「图表服务于表达、不凑齐所有图」一致 | 升级为 Full 剖面强制项 | 强制会过度治理；不阻塞 A2 立项，落地措辞前确认 |
| C-013 | #357 §2.1 物理归拢（MAJOR） | 另立评估 / 暂缓，本批只落 §2.2 | 根目录结构变更影响同步机制与派生引用，成本高 | 与 §2.2 同批执行 | 同批需全量派生迁移验证；不阻塞 Batch B |
| C-014 | #334 / #290 处置 | 维持暂缓 / DEFER | 实证数量不足；#290 待复活条件 | 直接推进 #334 | 提前固化不成熟载体；无时间压力 |
| C-015 | CLOSED 6 镜像归档 | 吸收范围确认后归档 | 已关闭且不再参与后续 Batch；远端为权威 | 继续保留 | 多留一轮不丢事实，但收件箱膨胀 |
| C-016 | governance Batch 1 遗留：`scripts/README.md` 入同步清单 | 独立后续事项评估，不阻塞 C1 | 改变同步边界需单独评估 | 本轮一并处理 | 影响派生项目工具说明下行 |

## 10. 结论

7 个 open issue + 1 份本地提案按「文档体系治理 → 形态裁剪与场景指引」两批 MINOR（v1.63.0 / v1.64.0）落地，C-011 已拍板；#334 / #290 / 3 份本地提案剩余项维持既有 Gate。三处文件重叠（§13、02/04、根目录地图）已给出落点合并与先后序（A1 → A2，#351 地图与 #357 2.2 合并）。下一步：切维护分支 → PR A1 → PR A2 → v1.63.0 → Batch B+C → v1.64.0 → 关闭 issue + 归档（远端操作逐项单独确认）。
