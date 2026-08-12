# TEMPLATE-UPGRADE：去重声明必填 + 自动检查归位准则

> 来源：模板维护者（基于 #335 选 A 关闭时的 gap 评估 + 复评 §6 + handoff C-007）
> 状态：处理中
> 目标版本：v1.61.3
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布

## 1. 动机（去项目化）

#335（规则分层地图）选 A 关闭时，关闭评论明确认可提案诊断的两个真实 gap 现行承载位未覆盖（详见 `docs/research/2026-08-12-c1-proposal-triage-reassessment.md` §6 + handoff C-007），承诺另案小 PATCH。复评 §6.3 只吸收了最轻一条（3 个归位判断问题）。本提案把这两个 gap 落地：

- **gap A（去重声明无强制机制）**：提案正文里"与既有规则的关系（去重）"声明目前只是 LUMEN 回流批次的自觉范式（#312 / #314 / #320 / #322 / #332 / #333 / #334 的 §1.1），模板流程文档（`_proposals/README.md`、`CONTRIBUTING §3`、`submit-proposal §2`、`global-rules §9`）无任何条款要求它——#335 和两份本地提案（`template-check-maintainability`、`domain-template-inheritance`）没写就证明非强制。新规则易与既有规则重复，同步与修改时漂移。
- **gap B（自动检查无归位准则）**：`implementation-lifecycle-rules §6` 主节开门句已有"验证方案应按项目形态裁剪，但必须说明适用 / 不适用原因"的口径，`web-fullstack-profile §9.4` 已把 §6 当"裁剪口径源"引用，但 §6 本身未展开到 test / type / lint / build 这层。#332（固定三件套）与 #335（按适用性裁剪）的冲突根因就在此——模板缺一条"自动检查归位"的统一准则。

## 1.1 与既有规则的关系（去重）

- **`implementation-lifecycle-rules §6` 测试与验证分层**（`ai/implementation-lifecycle-rules.md`，现行）：管"测试等级矩阵 + §6.1 破坏性 DB guard"。**互补不重复**——§6 主节开门句给"按形态裁剪"总口径，本提案 gap B 在其下新增 §6.2 展开 test / type / lint / build 子口径，不重写主节、不与 §6.1 重叠（§6.1 是特定破坏场景硬 guard，§6.2 是自动检查归位元规则）。
- **`global-rules §2.1` L0 通用代码原则**（`ai/global-rules.md`，现行）：管"写代码的下层基本功 + 可执行口径"。**层级不同**（L0 给原则、§6 给 Gate 口径），gap B §6.2 用指针"CI 必须跑测试见 L0-8"回指、不重抄；gap A 在 §9 追加"/ 与既有规则关系（去重）"也只补字段，不重复 L0 原则。
- **`_proposals/README.md` 提案头部字段**（现行）：管"来源 / 状态 / 目标版本 / Release impact / Release strategy 五字段"。**对象不同**（头部元数据 vs 提案正文章节），gap A 在其下新增"提案正文章节"小节规定必填正文结构（含 §1.1 去重），不改动现有五字段。
- **`CONTRIBUTING §3 / §3.1` 改模板流程**（`CONTRIBUTING.md`，现行）：管"切分支 → 提案 → 改 → PR → 归档"流程。**机制不同**（流程步骤 vs 字段要求），gap A 在 §3.1 追加"提案正文必须含去重章节"一句，不重写流程。
- **`submit-proposal §2` / `17-submit-proposal` Prompt 校验**（`ai/commands/`、`ai/prompts/maintainers/`，现行）：管"去项目化 / 来源标识 / 字段完整"三项校验。**互补**——gap A 在校验清单追加"去重声明"第四项，command 与 Prompt 配对同步、不漂移。
- **#335（选 A，已关闭）**：**合并入**本提案——其 §3"test / type / lint 按 build 覆盖与适用性裁剪"的实质立场落入 gap B §6.2；L0-L3 / R1-R7 编号体系不引入。
- **#332（退回重写中）**：**指向**——本提案给 #332 重写稿提供落点指针："声明适用质量门 + 说明不适用项"对应 §6.2，#332 重写时应引用 §6.2 而非再提固定三件套。

**本提案不重复它们**：gap A 是"把已存在的自觉去重范式提升为流程必填"，gap B 是"把已存在的 §6 裁剪口径展开到自动检查维度并兑现 §9.4 外部引用"。差异化：给提案流程补一个必填字段 + 给实现层补一条归位元规则。

## 2. 拟改

### gap A：去重声明必填（5 文件，纯追加）

1. `_proposals/README.md`：头部字段小节后新增「提案正文章节」小节，把 `## 1.1 与既有规则的关系（去重）` 列为必填正文章节，附关系标签（对象不同 / 层级不同 / 机制不同 / 互补不重复 / 合并入 / 指向）和结构示例。
2. `CONTRIBUTING.md §3.1`：追加——提案正文必须含"与既有规则的关系（去重）"章节；范式见 `_proposals/README.md`。
3. `ai/commands/submit-proposal.md §2 校验`：校验清单追加第四项——去重声明章节存在并列出关系类型。
4. `ai/prompts/maintainers/17-submit-proposal.md`：SOP Prompt 校验步骤同步追加该项，避免 command / Prompt 漂移。
5. `ai/global-rules.md §9`：第 233 行"动机 / 拟改 / 版本 / 影响"后追加"/ 与既有规则关系（去重）"。

### gap B：自动检查归位准则（1 文件，纯追加）

`ai/implementation-lifecycle-rules.md` §6.1 之后新增 **§6.2「自动检查归位与质量门口径」**，照 §6.1 blockquote 结构：开门句重申 §6 主节裁剪口径；3 条归位准则（不与 L0 §2.1 重复 / 适用性裁剪显式说明 / 声明位置 `project-rules §5` 或 `05-tech-spec`）；blockquote「口径」列触发 / 豁免 / 验证。

## 3. 版本影响

PATCH → `v1.61.2` → `v1.61.3`。判据（`CONTRIBUTING §4`）：治理说明补强 / 流程字段澄清 + 规则补章节；不新增同步目录 / 必读入口 / 强制 Gate / CI 断言 / 默认行为。

**版本边界说明**：§4 表格 patch 行含"治理说明补强"、minor 行含"文档骨架新增必填章节"。本 PATCH 是"提案流程字段追加（现有五字段本就必填，追加一个并给范式）+ 规则文件内新增小节"，**不是 docs/00-09 文档骨架新增必填章节**，也不是初始化流程新增必填项 → PATCH 成立，非 MINOR。

## 4. 影响面

- **改动文件**（全在 `template-sync.json files_all`，会下行同步）：`_proposals/README.md`、`CONTRIBUTING.md`、`ai/commands/submit-proposal.md`、`ai/prompts/maintainers/17-submit-proposal.md`、`ai/global-rules.md`、`ai/implementation-lifecycle-rules.md`（共 6 个）。
- **不触碰**：L0 §2.1 条目本身、§6 主节开门句与测试等级矩阵、§6.1 DB guard、`check-template` 断言、`template-sync.json` 结构、VERSION 机制。
- **check-template 影响**：零失败风险（纯追加，不动任何被断言字符串）；不新增断言（"去重必填"是文档要求非结构性硬约束，按断言哲学不给提案章节标题加 grep 断言）。
- **预期效果**：新提案（含派生回流）自觉写去重声明成为流程必填；自动检查归位有统一准则，#332 / #335 冲突口径被定（采适用性裁剪）。

## 5. 验证方式

- `scripts/check-template.ps1` 全绿（核心门槛）。
- 本提案 §1.1 自身作为去重声明样本可读、关系标签齐全（dogfood）。
- 抽查去重要求在 README / CONTRIBUTING / submit-proposal / 17-Prompt / global-rules §9 五处措辞一致。
- gap B §6.2 与 §6 主节开门句、§6.1 风格一致；`web-fullstack-profile §9.4` → §6 指针未断。
- VERSION = v1.61.3、CHANGELOG 三段式降序未被破坏。
