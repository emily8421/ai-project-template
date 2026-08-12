# C1 模板提案评估报告：本地提案 + 远端回流 issue

> 生成日期：2026-08-12
> 定位：模板维护者决策参考（AI 评估 + 建议，待人工拍板）；本报告为只读 triage 评估，未执行任何落地改动。
> 依据来源：Git 事实（HEAD 626dbd6 / v1.61.1）、本地 `_proposals/`、远端 open issue 镜像（`_proposals/_remote-issues/`）、`ai/global-rules.md §9`、`ai/commands/README.md`、`ai/prompts/maintainers/11-template-proposal-summary.md`。

## 0. 评估范围与方法

- **评估对象**：本地 `_proposals/` 2 份提案 + 模板仓远端 open issue 5 份（LUMEN 回流 4 份 + DEFER 1 份）。
- **方法**：按 C1 流程读取本地提案与既有镜像 → 刷新 / 新建远端 issue 镜像 → 去重 / 冲突 / 依赖分析 → 分批建议。远端正文只经镜像落盘后进入分析（镜像硬门禁）。
- **本报告不包含**：执行动作（无建分支、无改文件、无 PR、无关闭 issue）；只读 triage。

## 1. 提案 / issue 清单

### 1.1 本地提案（2 份）

| 提案 | 主题 | 落地状态（自述） | 剩余项（核实） |
|---|---|---|---|
| `_proposals/TEMPLATE-UPGRADE-template-check-maintainability.md` | check-template 诊断与脚本维护性 | P1 / P2.3 / P2.4 / P2.1 保守版均已落地（v1.56.2→v1.56.13） | P2.1 物理拆分、P2.2 双语言对称对照未做（`check-template.sh` 仍 2002 行单文件，无对称机制） |
| `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` | 领域模板继承机制与 Agent Profile | Batch 1 / 2 / 3（部分）/ C-004 已落地 | 多级同步自动化、Batch 4（profile / 自动化评估）未做（Gate：≥1 真实域项目试用） |

### 1.2 远端 open issue（5 份）

| # | 主题 | 来源 | 状态 |
|---|---|---|---|
| #332 | 通用层（R1/R2）代码一致性补充——补 L0 未覆盖项 | LUMEN 回流 | OPEN |
| #333 | Web Profile（R3）代码层一致性基线 | LUMEN 回流 | OPEN |
| #334 | Stack Adapter（R5）FastAPI / React | LUMEN 回流 | OPEN |
| #335 | 评估轻量代码治理路由与规则分层地图（非阻塞） | LUMEN 回流 | OPEN |
| #290 | domain-template docs folder reorg | 模板维护者 | OPEN（DEFER） |

> 已处理 issue #314 / #320 / #322 已关闭，无需刷新；无 `feedback` 标签 open issue。

## 2. 镜像清单与新鲜度

| 镜像路径 | remote Updated | Mirrored at | 新鲜度 |
|---|---|---|---|
| `_proposals/_remote-issues/issue-332.md` | 2026-08-12T06:24 | 2026-08-12 | fresh |
| `_proposals/_remote-issues/issue-333.md` | 2026-08-12T06:24 | 2026-08-12 | fresh |
| `_proposals/_remote-issues/issue-334.md` | 2026-08-12T06:24 | 2026-08-12 | fresh |
| `_proposals/_remote-issues/issue-335.md` | 2026-08-12T09:00 | 2026-08-12 | fresh |
| `_proposals/_remote-issues/issue-290.md` | 2026-07-29 | 2026-08-01 | fresh（镜像未过期） |

## 3. 去重 / 冲突 / 依赖分析

- **#332/#333/#334 同源三层，互不重复**：为原混合提案 `web-fullstack-code-consistency-baseline` 按 governance R1/R3/R5 拆分（原则 → 形态 → 栈），互相引用、需合看；无文件级冲突（分别落 `implementation-lifecycle-rules` / `web-fullstack-profile` / 新建 `stack-adapters/`）。
- **#335 与三份实现提案互补不重复**：#335 管「规则归位语言 / 去重 / 组合加载视角」，三份管「具体条目落地」；#335 自述不改变其范围 / 优先级 / 版本，去重声明充分（复用 `template-docs/capability-packages.md`，不替代 `ai/index.md`，test/type/lint 归 R2 不与 L0 重复）。
- **与 L0 的覆盖关系**：三份实现提案均自述「不重复 `global-rules §2.1` L0」；#332 声称补 L0 未覆盖的 3 条（CI type+lint 与 L0-8 边界、关键 secret 校验、多实现显式契约）。**口径需模板维护者复核**（尤其中「CI 必跑 test+type+lint」与 L0-8「可测试性」的边界）。
- **本地两份提案与本批正交**：template-check-maintainability（脚本维护）、domain-template-inheritance（领域模板机制）与 LUMEN 回流批不冲突、无依赖。

## 4. 关键发现：governance 框架文档缺失（阻塞项）

- 三份实现提案（#332/#333/#334）全文锚定 LUMEN 侧研究文档 `docs/research/2026-08-10-ai-code-governance-framework.md`（governance §4.5 / §8.3 / §9.1 / §14）与 `rule-consolidation-map.md`，作为 R1-R7 分层依据，并称「最终落点由维护者按 governance §14 #2 确认」。
- **核实结论：这两份文档在模板仓不存在**（Glob 无匹配；`template-docs/` 无 governance / R1-R7 相关内容）。
- 影响：三份实现提案的「分层语言」在模板仓没有权威源；直接按提案原样落地会引入对不存在文档的引用。

## 5. 分批落地计划建议

### 5.1 #332 + #333 + #334 → 聚合一次 MINOR

- 同源三层一起落地才构成完整「R1-R5 代码一致性治理」，拆开半套落地留缺口。
- 落地顺序建议：**先 #335 轻量地图确立归位词汇，再三份实现按词汇归位**，避免落点漂移。
- 前置 Gate（二选一，需用户拍板）：
  - **方案 A（推荐）**：不引入 governance 框架文档，三份实现按模板现有分层重写落点（#332→`implementation-lifecycle-rules` 增补；#333→`web-fullstack-profile` +§9；#334→新建 `stack-adapters/`）。
  - **方案 B**：先把 governance R1-R7 框架作为独立提案引入模板，再按框架落三份。工作量大、框架本身未评审，不建议现在做。

### 5.2 #335 → 独立 PATCH 评估

- 非阻塞方法论提案；建议采纳其**选项 B**（在现有方法论文档补一页精简映射表，复用 `capability-packages.md`），提供 L0-L3 / R1-R7 归位语言，回应 §4 的关键发现。
- 若后续试点证明映射表不足，再评估选项 C（独立 MINOR）。

### 5.3 本地两份提案（独立处理）

- `template-check-maintainability`：建议 **P2.1 物理拆分永久关闭**（保守版 `--summary` 分区已解决定位痛点，结构性拆分风险 > 收益）；P2.2 双语言对称对照可选（patch 级）。
- `domain-template-inheritance`：剩余项（多级同步自动化 + Batch 4）依赖真实域项目试用，**维持延后 Gate**。

## 6. 拟修改文件清单（若执行，方案 A 口径）

| 提案 | 拟改文件 | 改动 |
|---|---|---|
| #332 | `ai/implementation-lifecycle-rules.md` | 增补 R1/R2 条目 3 条（CI test+type+lint / secret 启动校验 / 多实现显式契约） |
| #333 | `template-docs/web-fullstack-profile.md` | §8 后新增 §9 及 §9.1~§9.4（Web 代码层一致性基线） |
| #334 | 新建 `template-docs/stack-adapters/` | README（选择矩阵）+ `fastapi-python.md` + `react-typescript.md`；登记同步清单 |
| #335 | 方法论文档（如 `template-docs/capability-packages.md`） | 补轻量 L0-L3 / R1-R7 映射表（选项 B） |

> 三份实现提案均需**去项目化**（去 LUMEN 实证细节 / CQ 编号 / 派生路径引用）。

## 7. 版本影响

| 项 | 版本判断 | 依据 |
|---|---|---|
| #332+#333+#334 | 下一 **MINOR** | 新增能力层级（CI 质量门 + secret 护栏 + 多实现契约 + Web 代码层契约 + stack-adapters 载体），类比 L0 落地 v1.61.0 |
| #335（选项 B） | **PATCH** | 只补规则承载关系的解释与归位准则，不新增默认能力 / 强制流程 |
| 本地 template-check-maintainability（P2.2） | PATCH | 可选轻量对照 |
| 本地 domain-template-inheritance（剩余） | 暂不递增 | 依赖真实域项目试用 |

## 8. 验证方式

- 三份实现落地：跑 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`（本地 1995 项）；新增 `stack-adapters/` 需同步 `template-sync.json` 与自检断言。
- #335：人工归位核对（选 ≥1 个通用原则 / CI Gate / Profile / 栈约定 / 任务约束，确认「为何在此处、何时加载、由谁验证」）——按提案 §7。
- 跨文档引用一致性：`web-fullstack-profile §9` 与 §5/§5.1、L0、stack-adapters 交叉引用核对。

## 9. 归档计划

- #332/#333/#334 落地后：镜像随提案移入 `_archive/proposals/`，关闭对应远端 issue。
- #335 若采纳选项 B：落地后归档 + 关闭 issue；若暂不采纳，继续保留镜像。
- #290 维持 DEFER（复活条件：Batch 2 第二个领域模板出现 / Batch 3 多级同步落地）。
- 本地两份提案：template-check-maintainability 若用户拍板关闭 P2.1，可标状态后整体归档；domain-template-inheritance 继续保留（有未决 Gate）。

## 10. 待人工确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| E-001 | governance 框架不在模板仓，三份实现提案如何落地 | **方案 A**：不引入框架，按模板现有分层重写落点 | 框架未评审、引入即大改；三份内容本身可独立落地 | 方案 B：先引入框架再落地 | 方案 A 改动聚焦；方案 B 工作量大且框架未评审；阻塞三份落地方式选择 |
| E-002 | 三份实现是否聚合一次 MINOR 一并落地 | **聚合**（1–3 个 PR） | 同源三层，一起才完整 | 逐份独立落地 | 聚合更完整但 PR 面大；拆分可小步但留半套缺口 |
| E-003 | #332「CI 必跑 type+lint」与 L0-8 边界是否需复核 | **需复核**，确认不重叠后落地 | 避免 L0 / 新增条目双写漂移 | 接受提案自述边界 | 只影响 #332 措辞，不阻塞整体 |
| E-004 | #335 是否采纳（选项 B） | **采纳 B**（PATCH 评估） | 提供归位语言，回应 governance 缺失；非阻塞 | 选项 A（不采纳）/ 选项 C（强制框架） | B 成本低；C 会形成 MINOR 迁移工作 |
| E-005 | 本地 template-check-maintainability P2.1 / P2.2 处置 | P2.1 关闭、P2.2 可选 | 保守版已解决定位痛点 | 维持现状继续观察 | 不阻塞任何落地 |

## 11. 结论

远端新增 4 份 LUMEN 回流提案（#332/#333/#334 实现层 + #335 方法论评估）与本地 2 份提案均正交、互不冲突；最大决策点是 **governance 框架缺失（E-001）**，推荐以 #335 选项 B 轻量地图回应、三份实现按方案 A 聚合一次 MINOR 落地。全部改动待用户拍板后按模板仓库分支 → PR 流程执行。
