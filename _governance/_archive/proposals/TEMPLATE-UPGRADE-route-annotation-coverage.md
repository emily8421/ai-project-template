# TEMPLATE-UPGRADE: 任务路由表场景级标注覆盖扩展（路由包裁读）

> 来源：模板维护者（token-hotspot SUMMARY §8~§15「路由包重读」观察家族，累计 12+ 次实证）
> 状态：已拍板实施（2026-11-14 C1 triage：证据链与 #441 机制核实属实；校正 1——原场景① PR/CI merge-only 已由 v1.75.8 #491 覆盖且 §15 后无复发，拟改删除；补强 1——prompt 11 读取口径同批对齐防双写漂移；细化 1——场景③落点定稿挂「PR / CI / Git 收尾」行；目标 v1.78.3）
> 目标版本：v1.78.3
> Release impact：patch（AI 建议，待维护者确认——复用 #441 既有章节级标注机制，无新能力层级 / 同步结构变化）
> Release strategy：单独发布

## 1. 动机（去项目化）

「快速续接 → 升级执行 → 整读完整规则回退包」的同型读取已在三类场景累计 12+ 次实证（token-hotspot SUMMARY §8 起持续登记，§14 升级为「待 C1 评估立案」，§15 判定证据链完整、优先级提高）：

1. **PR / CI / Git 收尾**（merge-only 收尾，无本地代码改动）：仍按路由行整读 `implementation-lifecycle-rules.md`（Sprint / 六问 / DB guard）与 `project-rules.md`，实际只需 `template-docs/profiles/remote-ci-sop-profile.md` §2 最小必读分诊 + git-guide 相关节。
2. **C1 triage**（提案收件箱处理）：实读集中于 prompt 11 + 收件箱 README「远端 issue 本地镜像」「提案正文章节」节 + CONTRIBUTING §1-§5；路由行所列其余文件与任务无直接关联。
3. **registry chore PR / handoff 刷新**（纯治理记录写入）：实读仅需 `ai/session-rules.md` §1 / §3 / §4 与 `ai/project-rules.md` §6。

每次整读数千行规则、实际用数十行——重复上下文成本高，且长上下文增加执行跑飞风险。#441 已建立章节级标注机制并验证有效（v1.76.1 后已标注场景生效良好，hotspot §15 正向实证），本提案把该机制铺到上述三个未覆盖场景。

## 1.1 与既有规则的关系（去重）

- **#441 路由粒度分层**（v1.73.0 落地，`ai/index.md` 路由表 + 脚注「章节级标注语义」）：建立「（<场景>可只读 §x / §y）」标注机制。**互补不重复**——本提案是该机制在三个未覆盖场景的覆盖面扩展，不新增机制、不改标注语义。
- **`template-docs/profiles/remote-ci-sop-profile.md` §2 最小必读分诊**（在库，PR/CI 收尾权威入口）：已做场景分诊。**互补**——场景 ① 是把该分诊以标注形式前置到路由表行，执行者在路由表即可获得裁读指引，不必先进 profile 再发现分诊。
- **token-hotspot SUMMARY §14 三场景标注落点清单**（观察材料，本地 gitignored 汇总已入库 §14）：**指向**——本提案即该候选的立案兑现，落点以其清单为基准。

**本提案不重复它们**：#441 只铺了部分行的标注；本提案补「PR / CI 收尾 merge-only」「C1 triage」「registry chore / handoff 刷新」三类场景的标注空白。

## 2. 拟改（2026-11-14 triage 修订后实施口径）

> triage 修订记录：原拟改第 1 处（「PR / CI / Git 收尾」行补 merge-only 标注）经核实已被 v1.75.8 #491 覆盖（现行行已为「权威入口，按其 §2 最小必读集分诊；发版类另读」，且 §15 最新实证无 merge-only 复发），实施时删除；场景③落点定稿为挂「PR / CI / Git 收尾」行；补强——prompt 11 读取口径与路由表标注同批对齐，避免双写漂移。

`ai/index.md` 任务路由表两处标注（沿用 #441 章节级标注与 v1.76.1 行内分口径语义，脚注不变）：

1. **「PR / CI / Git 收尾」行**：触发列补「registry 登记 / handoff 刷新等纯治理记录写入」；规则列补「registry 登记 / handoff 刷新等纯治理记录写入（无本地代码改动、非发版）可只读 `ai/session-rules.md` §1 / §3 / §4 与 `ai/project-rules.md` §6」。
2. **「模板维护 / 规则改造 / 同步机制」行**：补行内分口径「**C1 triage（提案收件箱评估，不含实施）**：`ai/prompts/maintainers/11-template-proposal-summary.md`、`_governance/_proposals/README.md`「提案正文章节」与「远端 issue 本地镜像」节、`CONTRIBUTING.md` §1-§5（拍板后进入实施即回规则改造口径，读完整回退包）」。

随同批落地（triage 补强兑现，原附带评估项扩围）：prompt 11「使用前准备」与「读取前先确认」清单对齐路由表 C1 标注——`CHANGELOG.md` 全文必读改「按需（`VERSION` + 相关近期条目）」，「ai/index.md 列出的全部规则文件」改为指向 C1 triage 场景最小必读集（hotspot §11 同族建议 + triage 补强）。

## 3. 版本影响

PATCH（AI 建议）：标注为导航文字，不改变规则正文、断言、同步清单结构与推荐工作流本身；标注语义机制已由 #441 建立并发布。若维护者判定「路由表推荐读取面收窄」构成推荐工作流可见变化，可升 MINOR，待确认。

## 4. 影响面

- `ai/index.md`（在 `template-sync.json` `files_all` 同步清单内）——下游派生项目同步后共享标注收益。
- 不新增 `check-template.sh` 断言（标注内容为导航文字，与 #441 同口径：不引入文案级断言，避免过度治理）。
- 不影响派生项目本地行为；派生仓同场景会话同样受益。

## 5. 验证方式

- `bash scripts/check-template.sh --summary` 全量自检 + `git diff --check` + `check-markdown-clean.ps1 _governance/_proposals _governance/ai-records`（MAINTAINERS §3 步骤 10 固定参数）。
- 人工核对：三场景标注所列最小必读集与该场景实际需要的规则一致（#441 同款人工审查项）；标注格式与 #441 脚注语义一致。
- PATCH 级豁免 L3 e2e（纯导航标注，无脚本 / 同步清单 / 断言变更）。
