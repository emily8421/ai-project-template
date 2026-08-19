# C1 模板提案重新评估报告：远端代码治理提案复核

> 生成日期：2026-08-12
> 定位：模板维护者决策参考（AI 重新评估 + 建议，待人工确认）。
> 状态：只读 triage 结论；本轮未修改规则、提案、issue 镜像、版本或远端 issue 状态。
> 重新评估基线：`HEAD fe0f6c5`、模板 `v1.61.1`、2026-08-12 远端 open issue 元数据。
> 首轮报告：`docs/research/2026-08-12-c1-proposal-triage-template-proposals.md`。本报告保留首轮报告，不覆盖其历史结论。

## 0. 执行摘要

本次重新评估不建议沿用首轮报告的“先落 #335，再把 #332/#333/#334 聚合为一次 MINOR”方案。四份 LUMEN 回流提案虽然来自同一次代码审查，但成熟度、通用性和长期维护成本不同，不构成必须整包落地的体系。

建议处置如下：

| Issue / 提案 | 重新评估结论 | 建议动作 | 当前版本影响 |
|---|---|---|---|
| #332 通用层代码一致性补充 | 方向部分成立，现稿过强 | 退回重写；保留 secret 安全与多实现契约原则，改写质量门适用性 | 暂不递增；重写后优先按 PATCH 论证 |
| #333 Web Profile 代码层基线 | 核心问题真实，条目需裁剪 | 部分采纳并优先落地；只保留稳定的 Web 契约规则 | PATCH 候选；若升级为强制 Gate 才是 MINOR |
| #334 FastAPI / React Stack Adapter | 证据与内容成熟度不足 | 暂缓；不按现稿新建 `stack-adapters/` | 暂不递增；未来新建同步目录时为 MINOR 候选 |
| #335 规则分层地图 | 现有承载位基本足够 | 当前选 A，不引入 L0-L3 + R1-R7 双重分类 | none；未来仅补说明时可为 PATCH |
| #290 domain-template docs folder reorg | 复活条件未满足 | 继续 DEFER | none |
| 本地 check-template maintainability | 已落地部分有效，剩余项证据不足 | P2.1/P2.2 继续观察，不永久关闭 | none |
| 本地 domain-template inheritance | 已部分落地，剩余 Gate 未满足 | 继续保留，等待更多真实域项目实证 | none |

推荐下一批只处理 #333 的精简版本，同时修复现有 `global-rules.md` 对尚不存在的 `web-fullstack-profile.md §9` 的悬空引用。#332、#334、#335 均不阻塞该批次。

## 1. 评估范围与证据

### 1.1 远端 open issue

本轮通过只读 `gh issue list` 重新查询远端。当前 open issue 共 5 个：

| # | 标题 | 标签 | Remote updated | 镜像路径 | 镜像状态 |
|---|---|---|---|---|---|
| #335 | TEMPLATE-UPGRADE: 评估轻量代码治理路由与规则分层地图（非阻塞） | `proposal`, `from:LUMEN_demo_T2.1` | 2026-08-12T09:00:39Z | `_proposals/_remote-issues/issue-335.md` | fresh |
| #334 | TEMPLATE-UPGRADE：Stack Adapter（R5）—— FastAPI / Python + React / TypeScript | `proposal`, `from:LUMEN_demo_T2.1` | 2026-08-12T06:24:05Z | `_proposals/_remote-issues/issue-334.md` | fresh |
| #333 | TEMPLATE-UPGRADE：Web Profile（R3）代码层一致性基线 | `proposal`, `from:LUMEN_demo_T2.1` | 2026-08-12T06:24:03Z | `_proposals/_remote-issues/issue-333.md` | fresh |
| #332 | TEMPLATE-UPGRADE：通用层（R1/R2）代码一致性补充——补 L0 未覆盖项 | `proposal`, `from:LUMEN_demo_T2.1` | 2026-08-12T06:24:01Z | `_proposals/_remote-issues/issue-332.md` | fresh |
| #290 | TEMPLATE-DEFER: domain-template docs folder reorg | `proposal` | 2026-07-29T10:24:40Z | `_proposals/_remote-issues/issue-290.md` | fresh |

五份镜像的 `State` 与 `Updated` 均和远端元数据一致，满足本地镜像正文分析门禁。本轮未直接使用未落盘的远端正文进行判断。

### 1.2 本地提案

- `_proposals/TEMPLATE-UPGRADE-template-check-maintainability.md`
- `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`

### 1.3 当前模板事实

- 当前仓库：`main...origin/main`，重新评估结束前工作区干净。
- 当前 `HEAD`：`fe0f6c5`，该提交已将首轮 C1 报告和 #332-#335 镜像通过 PR #336 入库。
- 当前版本：`v1.61.1`。
- `docs/research/2026-08-10-ai-code-governance-framework.md` 不存在。
- `docs/research/2026-08-10-rule-consolidation-map.md` 不存在。
- `template-docs/stack-adapters/` 不存在。
- `template-docs/capability-packages.md` 已有 Core、Docs、Implementation、Verification、Profiles、Governance 影响域表。
- `ai/global-rules.md §2.1` 已引用 `web-fullstack-profile.md §9` 和 `§9.4`，但当前 `template-docs/profiles/web-fullstack-profile.md` 只有 §1-§8，形成悬空引用。

## 2. 对首轮报告的复核

### 2.1 首轮报告判断正确的部分

1. 正确执行了远端 issue 镜像门禁。
2. 正确识别 #332/#333/#334 来自同一份混合提案的不同层次。
3. 正确发现三份提案依赖的 governance 框架与 consolidation map 不在模板仓。
4. 正确要求移除 LUMEN 项目名、CQ 编号和派生路径等项目化细节。
5. 正确判断 #290 的复活条件尚未满足。
6. 正确判断本地 domain-template inheritance 剩余项仍依赖真实项目试用。

### 2.2 需要修正的部分

1. **把同源误判为必须同批。** 同一次项目审查只能证明发现路径相同，不能证明所有规则成熟度相同或必须一起落地。
2. **过度依赖提案自述的“互补、不重复”。** 原报告没有逐条判断规则是否真的跨项目成立，也没有充分审查具体技术建议的正确性。
3. **governance 结论自相矛盾。** 报告一方面把 R1-R7 权威源缺失列为阻塞，另一方面建议先通过 #335 把 R1-R7 映射引入模板；这会先固化尚未评审的外部术语。
4. **未识别 #332 与 #335 的直接冲突。** #332 要求固定执行 `test + type + lint`，#335 则明确承认应按项目适用性和 build 覆盖情况裁剪。
5. **版本判断偏重。** `CONTRIBUTING.md` 要求兼容说明、默认关闭或可选能力优先从 PATCH 论证；仅在新增下游采用面、必填入口或同步结构时使用 MINOR。
6. **对 #334 的技术内容审查不足。** 其中部分 TypeScript/Python 建议过度具体，不能直接成为模板级基线。
7. **P2.1 关闭理由不足。** `--summary` 解决的是输出成本，不等于解决约 1900 行单脚本的维护性；只能继续观察，不能据此永久关闭物理拆分候选。

## 3. #332 重新评估：通用代码一致性补充

### 3.1 结论

**退回重写，不按现稿采纳。** 三项建议中有两项包含可通用价值，但表达需要从“固定实现”改为“原则 + 适用条件 + 项目化落地”。

### 3.2 分项判断

| 原建议 | 判断 | 理由 | 建议改写方向 |
|---|---|---|---|
| CI 必跑 `test + type + lint` | 不按原文采纳 | 并非所有项目都有类型系统、lint 或独立 test 命令；某些 build 已覆盖类型检查 | 项目必须声明适用的自动质量门；test/type/lint/build 按形态选择，不适用项说明理由 |
| 关键 secret 启动期 fail-closed | 部分采纳 | 生产和安全敏感运行态成立；本地、测试、显式 Mock 场景可能需要受控替代配置 | 禁止生产或安全敏感环境使用弱默认值；校验时点和豁免写入技术方案与验证计划 |
| 多实现必须显式契约 + contract test | 部分采纳 | 原则成立，但 `Protocol/ABC/interface` 只是语言实现手段，不应写死 | 多个可替换实现必须共享机器可检查的契约或兼容性测试；具体机制由技术栈决定 |

### 3.3 与现有规则的关系

- L0-8 已规定关键业务逻辑可测试且 CI 跑测试，但当前对不同项目形态的适用性说明不足。
- `implementation-lifecycle-rules.md §6` 已要求验证方案按项目形态裁剪，并说明适用 / 不适用原因。#332 应与该口径统一，不能新增固定工具组合。
- secret 的文档登记已存在于 `docs/05-tech-spec` 标准，但“生产环境不得使用弱默认值”的执行底线仍可补强。
- L0-12 已有“先契约后实现”，多实现一致性可作为其应用说明，不一定需要另立 R1 层级。

### 3.4 版本建议

- 当前提案：`none`，先重写。
- 若只补适用性、secret 安全和多实现契约说明：优先按 `PATCH` 论证。
- 若新增所有派生项目必须配置的新 CI Gate 或必填入口：再判断 `MINOR`。

## 4. #333 重新评估：Web Profile 代码层基线

### 4.1 结论

**部分采纳，重写后作为最高优先级候选。** 它处理的错误契约、HTTP 调用边界和契约漂移问题具有跨 Web 栈价值，而且能修复当前 L0 对不存在 §9/§9.4 的悬空引用。

### 4.2 建议保留

1. **机器可读错误标识**：客户端不得靠错误文案判断认证失效、降级或业务状态。
2. **统一传输边界**：前端请求原则上经过统一 API client / transport 层，便于统一处理认证、超时、错误和观测。
3. **契约漂移检测**：前后端共享的 API 契约必须有机器可校验的同步或兼容性检查，禁止无守护的长期手工双写。
4. **真实协议边界测试**：全局异常处理、错误 envelope、序列化和状态码映射必须经真实 HTTP / 框架客户端路径测试，不能只直接调用端点函数。
5. **生产错误最小化**：异常响应不得泄露堆栈、内部路径或原始异常文本；该项复用 L0-7，不重复创建第二权威源。

### 4.3 建议删除或放宽

| 原建议 | 处置 | 原因 |
|---|---|---|
| 固定 `code/status_code/data/msg` envelope | 改为示例，不作唯一结构 | 项目也可采用 RFC Problem Details、GraphQL error 或其他稳定协议 |
| “读可直连 repository、写必走 service”二选一 | 移出 Profile | 属项目架构选择，不是所有 Web 项目的共同规则 |
| 端点函数后缀统一 | 不单列 | 价值较低，现有 L0-3“一致性优先”已覆盖 |
| 新资源必须 barrel re-export | 移出 Profile | React/TypeScript 具体组织习惯，不适用于所有 Web 栈 |
| 后端 schema 必须是唯一事实源 | 改为“选定机器可读契约源” | 权威源也可能是独立 OpenAPI、GraphQL schema、protobuf 或共享 IDL |
| CI 只跑 unit，integration 夜跑或手动 | 改为项目化策略 | 集成测试频率取决于风险、速度和依赖，不应由模板固定 |

### 4.4 建议落点

- 在 `template-docs/profiles/web-fullstack-profile.md` 增加精简的代码契约章节。
- 章节只规定 Web 形态层的目标与验证要求，不引用 R3/R5 编号，不依赖尚不存在的 Adapter。
- 同步修正 `ai/global-rules.md` 中对 §9/§9.4 的引用，使章节号与实际文件一致。
- 具体错误结构、工具和框架实现继续由 `docs/05-tech-spec.md` 与 `ai/project-rules.md §5` 决定。

### 4.5 版本建议

- 若新增的是可裁剪指导、没有新强制 Gate 或新同步结构：`PATCH`。
- 若要求所有 Web 派生项目新增必填文档字段、必过 Gate 或迁移工作：`MINOR`。
- 不应仅因为新增一个章节就自动判为 MINOR。

## 5. #334 重新评估：FastAPI / React Stack Adapter

### 5.1 结论

**暂缓，不按现稿新建 `template-docs/stack-adapters/`。** 当前只有一个派生项目提供实证，内容也还没有达到可长期维护的技术栈标准件质量。

### 5.2 可吸收但不需要 Adapter 的原则

- 业务层避免依赖 HTTP 框架类型。
- 错误码到协议状态的映射应集中管理。
- 配置读取应集中，安全敏感默认值应验证。
- 可替换实现需要共享契约与兼容性验证。

这些内容可以分别进入精简后的通用原则、Web Profile 或项目技术方案，无需为了它们立即建立新目录。

### 5.3 需要修正的技术问题

1. Python `Protocol` 属于结构化类型；具体实现通常不需要显式继承 Protocol。
2. `@runtime_checkable` 只能检查有限的成员存在性，不能证明签名、语义或行为契约完全一致。
3. 用 `inspect` 比较方法面只能作为辅助检查，不能替代行为型 contract test。
4. TypeScript 全面禁止 `any` 过于绝对；外部边界、渐进迁移或第三方声明缺失时可能需要受控使用并缩小范围。
5. 强制用 `ReturnType<typeof useXxx>` 作为跨层 props 类型会让组件契约耦合 hook 实现，不应成为通用推荐。
6. 固定 `backend/config.py`、四层目录、Pydantic Settings 和 barrel export 是具体项目选择，不是 FastAPI/React 的唯一正确结构。
7. 提案承认 Adapter 的推荐目录、工具命令、正反例和版本兼容范围仍待补齐，说明当前交付物本身不完整。

### 5.4 复活条件

满足以下条件后重新评估：

1. 至少两个相互独立的真实项目使用同一技术栈并出现相同问题。
2. 能区分稳定原则、推荐实践和项目偏好。
3. 补齐支持的版本范围、最小正反例、验证命令与例外处理。
4. 明确 Adapter 是否进入同步清单、由谁维护、何时淘汰旧版本口径。

### 5.5 版本建议

当前为 `none`。未来若正式新增 `template-docs/stack-adapters/` 并纳入同步、导航和自检，属于新增下游采用面，按 `MINOR` 评估合理。

## 6. #335 重新评估：规则分层地图

### 6.1 结论

**当前选择选项 A：不引入 L0-L3 + R1-R7 双重分类。**

### 6.2 原因

- `template-docs/capability-packages.md` 已有 Core、Docs、Implementation、Verification、Profiles、Governance 影响域表。
- `ai/index.md` 已按任务类型路由必读规则包。
- L0/L1/L2/L3 已在 `global-rules.md` 用于表达通用、形态和项目专属规则。
- 再增加 R1-R7 会让模板同时存在三套分类语言，增加学习、引用和防漂移成本。
- #332/#333/#334 所引用的 governance 框架和 consolidation map 不在模板仓，当前没有足够证据把其中编号提升为模板正式概念。

### 6.3 可轻量吸收的内容

未来若维护者确实发现规则归位困难，可只在现有影响域表旁补三个判断问题，不保留 R1-R7 编号：

1. 换语言、换项目后是否仍成立？
2. 它是执行 Gate、项目形态规则、技术栈建议，还是项目自己的选择？
3. 当前是否已有权威承载位，新增内容会不会形成第二事实源？

### 6.4 版本与关闭建议

- 当前不落地：`none`。
- 若未来只补上述判断问题：`PATCH`。
- 若未来完整引入新的强制路由体系：另立提案并按 `MINOR` 评估。
- #335 可在维护者确认“不引入新分类、少量问题按需吸收”后关闭；关闭属于远端状态变更，必须单独复核并确认。

## 7. #290 与本地提案

### 7.1 #290 domain-template docs folder reorg

继续 DEFER。其复活条件为：

- 第二个领域模板出现；或
- 多级同步落地。

当前 `agent-system-template` 是第一个领域模板，Batch 2 已完成不等于出现第二个领域模板；多级同步自动化仍是剩余项。因此无新证据支持复活目录重组。

### 7.2 template-check-maintainability

- P1、P2.3、P2.4 和 P2.1 保守版已落地。
- 当前 `scripts/check-template.sh` 仍接近 2000 行。
- `--summary` 解决成功日志长度和定位成本，但没有直接解决单文件维护性。

建议 P2.1 物理拆分继续 DEFER，不作“永久关闭”。复活证据应是重复合并冲突、修改时漏断言、局部验证困难或执行性能问题。P2.2 双语言对照也等待真实 Bash/PowerShell 漂移案例，不基于假设新增机制。

### 7.3 domain-template-inheritance

继续保留。Batch 1、Batch 2、部分 Batch 3 和 C-004 已落地；剩余多级同步自动化与 Batch 4 Profile 仍需真实领域项目试用。它与本轮 Web 代码治理提案没有依赖，不应合并处理。

## 8. 去重、冲突与依赖结论

### 8.1 去重

- #332 的多实现契约是 L0-12“先契约后实现”的具体应用，适合补充说明，不需要新建 R1 权威层。
- #333 的生产错误最小化复用 L0-7，不在 Web Profile 重写一套通用安全原则。
- #334 中 import 卫生、失败可见等已经由 L0 覆盖，不应在 Adapter 再次形成规则副本。
- #335 的影响域分类与 `capability-packages.md` 已明显重叠。

### 8.2 冲突

- #332 固定要求 `test + type + lint`，与 #335“按项目适用性裁剪”冲突；采用后者的适用性原则。
- #333 把读写分层先称为项目基线，又提升为 Web 通用规则，归位不稳定；应留给项目架构。
- #334 一方面声称 Adapter 只翻译上层原则，另一方面又加入固定目录、工具和结构偏好，边界不清。
- 首轮报告建议不引入 governance 框架，但又先引入 R1-R7 映射；本次不采用该组合。

### 8.3 依赖

- #333 的精简落地不依赖 #332、#334 或 #335。
- #332 重写不依赖技术栈 Adapter。
- #334 若未来复活，应依赖稳定的上层原则和多项目实证，但不需要依赖 R1-R7 编号。
- #290 只依赖自身明确的领域模板复活 Gate。

## 9. 建议分批计划

### Batch A：精简 Web 代码契约（优先，PATCH 候选）

目标：吸收 #333 中稳定且跨 Web 栈成立的规则，并修复悬空引用。

拟修改文件（仅在维护者后续确认实施时）：

| 文件 | 拟改内容 |
|---|---|
| `template-docs/profiles/web-fullstack-profile.md` | 增加精简的错误契约、统一传输边界、契约漂移检测和真实协议边界测试说明 |
| `ai/global-rules.md` | 修正或确认对 Web Profile 章节的引用，不重复规则正文 |
| `scripts/check-template.sh` | 仅在确有必要时补一条稳定存在性断言，避免为每个条目增加脆弱断言 |
| `VERSION` / `CHANGELOG.md` | 按最终是否新增强制采用面判断 PATCH 或 MINOR；当前建议 PATCH |

建议一个 PR 完成。不要同时引入 Adapter 或 R1-R7 地图。

### Batch B：重写 #332（独立评审）

目标：将固定工具组合改成项目适用性质量门，并精炼 secret 与多实现契约原则。先重写提案，再决定是否实施；不阻塞 Batch A。

### Candidate Pool：#334

保持 open 或增加 defer 说明，等待第二个项目实证和内容校正。暂不创建目录、同步项或自检断言。

### Not Adopted Now：#335

当前不引入新分类。维护者确认后，可关闭 issue 并在关闭说明中记录：现有影响域表足够，三个归位问题未来按需吸收。

## 10. 版本影响

| 范围 | 建议版本 | 依据 |
|---|---|---|
| 本报告及其他只读研究记录 | none | 不改变模板行为或同步判断 |
| #333 精简指导 + 悬空引用修复 | PATCH 候选 | 不新增目录、必填入口或默认强制流程 |
| #332 重写后的说明性补强 | PATCH 候选 | 需以适用性原则为主，不新增统一工具门 |
| #334 正式新增同步 Adapter 目录 | MINOR 候选 | 新增同步结构和下游采用面 |
| #335 三个判断问题 | PATCH 候选 | 仅补现有影响域说明 |
| #335 完整强制路由体系 | MINOR | 新增治理层级和迁移面 |
| #290 当前延后 | none | 无落地变化 |

## 11. 验证计划

若后续实施 Batch A：

1. 人工检查每条规则是否换到 React/Vue、FastAPI/Spring/Express 后仍成立。
2. 检查 `global-rules.md`、`web-fullstack-profile.md` 和 `capability-packages.md` 没有第二权威源或悬空章节引用。
3. 检查新增规则允许项目在 `ai/project-rules.md §5` / `docs/05-tech-spec.md` 选择具体协议和工具。
4. 运行 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1` 做本地结构检查。
5. 按发布级别运行模板权威自检；若为 MINOR，再执行维护者 checklist 规定的端到端回归。
6. `git diff --check`，并人工审查同步清单是否真的需要变化。

## 12. 归档与远端处置建议

所有远端操作均待维护者确认，执行前需重新复核 open 列表和单项状态。

| 对象 | 建议处置 |
|---|---|
| #333 | 精简内容落地并合并后关闭；镜像归档并注明只吸收哪些条目 |
| #332 | 保持 open，先要求重写；重写前不关闭 |
| #334 | 保持 open 并标记 defer / needs-evidence，或在明确拒绝现稿后关闭并另留复活条件 |
| #335 | 维护者确认选 A 后可关闭，说明现有影响域表继续作为承载位 |
| #290 | 保持 open / DEFER，不改变 |
| 本地 check-template 提案 | 保留，更新剩余项 Gate 后再决定是否归档 |
| 本地 domain-template 提案 | 保留，等待多级同步与更多真实域项目 |

## 13. 待人工确认项

| ID | 待确认项 | AI 建议 | 依据 | 备选 | 影响 / 阻塞 |
|---|---|---|---|---|---|
| RE-001 | 是否推翻首轮“三提案聚合 MINOR”建议 | 是，改为按成熟度拆分 | 三提案适用范围、证据和维护成本不同 | 继续整包落地 | 决定后续 PR 范围 |
| RE-002 | #333 是否作为下一优先批次 | 是，精简后独立处理 | 核心问题真实，且当前存在 §9 悬空引用 | 暂不处理，仅修引用 | 决定 Batch A 范围 |
| RE-003 | #332 的质量门口径 | 采用“适用命令 + 不适用说明” | 与现有验证裁剪规则一致 | 固定 `test+type+lint` | 固定口径会压重轻量项目 |
| RE-004 | #334 是否立即建 Adapter 目录 | 否，等待第二个项目实证 | 当前只有单项目证据，内容也需技术校正 | 先建候选目录 | 新目录带来 MINOR 级维护面 |
| RE-005 | #335 采用哪个选项 | 当前选 A | 现有影响域表已覆盖主要导航需求 | B：补无编号判断表；C：强制体系 | B 可后续 PATCH；C 是独立迁移项目 |
| RE-006 | check-template P2.1 是否永久关闭 | 否，继续 DEFER | summary 不等于维护性问题消失 | 永久关闭 | 不阻塞当前提案批次 |

## 14. 最终建议

本轮最有价值的工作不是建立一整套新的治理编号体系，而是补好现有 Web Profile 中已经出现的真实缺口。

建议维护者拍板：

1. #333 部分采纳并独立推进。
2. #332 退回重写，采用项目适用性质量门。
3. #334 暂缓，等待多项目实证和技术校正。
4. #335 当前不引入 R1-R7 分类。
5. #290 继续 DEFER。
6. 两份本地提案继续按各自 Gate 观察，不与本轮 Web 规则合并。

该路线能吸收派生项目中可复用的经验，同时避免把单一项目的目录、工具和实现习惯固化为所有下游项目都要长期承担的模板规则。

## 15. Batch A 最终落地方案（#333 精简版 + 3 点修正）

> 本节是 §9 Batch A 经维护者 **2026-08-12 拍板采纳**后的最终落地方案，取代 §9 的评估期版本。
> 拍板结论：采纳本报告主线（§14）+ 第三方独立核实补强的 3 点落地修正（TQG 引用清理、§9.4 指向调整、L0 复用写指针）。
> 独立核实加强论据：`ai/global-rules.md` 对 `web-fullstack-profile §9/§9.4` 的悬空引用实为 **#322 落地 L0 时主动预留的两处前向引用**——§2.1 L0 引言（`global-rules.md:35`）引 §9，**L0-8 可测试性口径（`global-rules.md:44`）引 §9.4**。因此 #333 落 §9 = 兑现已有承诺、修复真实断链，而非新增能力。这是本批优先级的根因。

### 15.0 处置与版本

- 处置：仅 #333 部分采纳、独立推进；#332 退回重写、#334 暂缓、#335 选 A，均**不在本批**。
- 版本：**PATCH** → 递增至 `v1.61.2`（实施时确认）。依据 `CONTRIBUTING.md §4`：同文件补可选章节 + 兑现已有引用 + 默认行为/同步清单结构/下游必做流程不变 → patch；不因"新增一个章节"升 minor。
- 不新增同步范围文件/目录、不新增必填入口、不新增强制 Gate。

### 15.1 拟修改文件

| 文件 | 改动 | 说明 |
|---|---|---|
| `template-docs/profiles/web-fullstack-profile.md` | §8 之后新增 §9（精简版，结构见 §15.2） | 主体改动 |
| `ai/global-rules.md` | L0 正文**不改**；§2.1 对 §9/§9.4 的引用落 §9 后即自然兑现 | 无需改文本，仅需验证章节号一致 |
| `scripts/check-template.sh` / `.ps1` | **默认不新增断言**；§9 非硬 Gate，不为其每条加脆弱断言 | 若维护者希望锁定 §9 存在，最多补 1 条标题存在性断言 |
| `VERSION` / `CHANGELOG.md` | PATCH 递增 + 登记 Batch A | — |

不改：`implementation-lifecycle-rules.md`（#332 退回）、`template-sync.json`（web-fullstack-profile 已在清单）、任何 Gate（WSG-001~006）、L0 §2.1 正文。

### 15.2 新增 §9 的章节结构（精简后）

引言：§9 只规定 Web 形态层目标与验证要求；跨形态通用基本功见 `global-rules.md §2.1` L0；具体栈写法留给未来 Adapter；**不引 R3/R5 编号、不依赖尚不存在的 Adapter**。

| 子节 | 保留条目 | 裁剪 / 改写（依据复评 §4.3） | L0 复用指针 |
|---|---|---|---|
| **§9.1 错误与响应契约** | 机器可读错误标识（禁靠文案判状态）；兜底 5xx envelope；结构化客户端错误（含 `code`） | 固定 `code/status_code/data/msg` envelope → 改为**示例**，不作唯一结构 | 兜底 envelope 不回传堆栈 → **见 L0-7**，不重抄 |
| **§9.2 传输边界** | 统一经 API client / transport 层（原"HTTP 单出口"） | 移出：读可直连 repo / 写必走 service 二选一（项目架构选择）；不单列端点后缀统一（L0-3 已覆盖）；移出 barrel re-export（React/TS 习惯） | — |
| **§9.3 类型与契约同步** | 前后端共享 API 契约须有机器可校验的同步 / 兼容性检查 | "后端 schema 唯一事实源" → 改为**选定机器可读契约源**（OpenAPI / GraphQL / protobuf / IDL 均可） | — |
| **§9.4 工程化护栏** | 契约序列化层（全局 exception_handler / envelope）须经 HTTP 客户端路径（如 TestClient）回归测试 | "CI 只跑 unit / integration 夜跑" → 改为**项目化策略** | CI 跑测试口径 → **见 L0-8**，不重抄 |

### 15.3 去项目化清理清单（落地时必须清除）

- 移除 LUMEN 项目名、`CQ-P1-002` / `CQ-P1-005` / `v3.8.x` 等派生版本与路径引用。
- **【修正点 1】移除 TQG 编号引用**：`TQG-004` / `TQG-009` / `TQG-011` / `TQG-012` 指向 LUMEN `docs/research/2026-08-10-code-quality-maintainability-assessment.md`，与 governance 框架一样**不在模板仓**；两份评估报告只盯住了 governance / consolidation-map，漏了 TQG。落地时一并清除这些编号（保留其指向的规则内容，去掉编号与来源引用）。
- 移除 `docs/research/2026-08-10-ai-code-governance-framework.md` / `rule-consolidation-map.md` 引用（评估报告已识别）。
- 移除 R1-R7 / L0-L3 双重分类措辞（采纳 #335 选 A，不引入新分类语言）。

### 15.4 L0 复用写法 + §9.4 指向调整

- **【修正点 3】L0 复用写指针、不重抄**：§9.1 / §9.4 凡复用 L0 的条目，写成"（复用 L0-X，见 `global-rules.md §2.1`）"，**不重抄原则正文**，避免在 Web Profile 形成第二权威源。
- **【修正点 2】§9.4 指向调整**：#333 原文 §9.4 写"CI 必跑 test+type+lint 的元规则在通用补充提案 R2 Gate"。因 #332 已退回重写（不固定三件套），本批 §9.4 该句改为指向 **`ai/implementation-lifecycle-rules.md §6`** 的裁剪口径（"验证方案按项目形态裁剪 + 说明适用/不适用"），不再指向被退回的 #332。

### 15.5 验证

1. 人工逐条核对：每条 §9 规则换 React/Vue、FastAPI/Spring/Express 后仍成立（形态层成立、栈无关）。
2. 断链兑现：`global-rules.md §2.1` 的 §9 / §9.4 引用与新 §9 章节号一致；L0-8 口径不再悬空。
3. 无第二权威源 / 无悬空引用 / 无 TQG / governance / consolidation-map / CQ / LUMEN 残留。
4. `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1` 本地结构自检通过。
5. `git diff --check`；同步清单无需变化（已确认 web-fullstack-profile 在 `template-sync.json` + `sync-template.sh` 内）。

### 15.6 归档与远端处置（均待单独授权）

- #333：Batch A 合并并下行同步后，镜像移入 `_archive/proposals/`，关闭远端 issue；**关闭评论须注明**：只吸收 §15.2 的精简条目，#332 退回、#334 暂缓、#335 选 A 的处置。
- #332 / #334：保持 open（#332 待重写、#334 标 needs-evidence / defer）。
- #335：维护者确认选 A 后可关闭，关闭说明记录"现有 6 域影响域表足够；3 个归位判断问题未来按需吸收"。
- #290：维持 DEFER，不改变。

### 15.7 不在本批 / 后续

- **#332** 退回重写（独立评审，不阻塞本批）：固定三件套 → 声明适用质量门 + 说明不适用项，与 `implementation-lifecycle-rules §6` 裁剪口径统一；secret fail-closed + 多实现契约作为 L0-12 的应用说明，不另立 R1 层。
- **#334** 暂缓：等 ≥2 个相互独立的真实项目实证 + 校正复评 §5.3 的 7 项技术问题（Protocol 结构化类型无需显式继承、`runtime_checkable` 仅查成员存在性、`inspect` 不可替代行为契约、禁 `any` 过绝对、`ReturnType<typeof>` 耦合 hook 实现等）；未来正式新建 `stack-adapters/` 时按 MINOR 评估。
- **#335** 选 A：本批不引入 R1-R7；若未来补 3 个归位判断问题（复评 §6.3），按 PATCH。
- **#290** 继续 DEFER；本地两份提案继续按各自 Gate 观察。
