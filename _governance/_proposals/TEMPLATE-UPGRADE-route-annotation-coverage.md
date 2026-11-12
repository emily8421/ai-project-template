# TEMPLATE-UPGRADE: 任务路由表场景级标注覆盖扩展（路由包裁读）

> 来源：模板维护者（token-hotspot SUMMARY §8~§15「路由包重读」观察家族，累计 12+ 次实证）
> 状态：候选（待 C1 triage 与维护者拍板）
> 目标版本：待确认
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

## 2. 拟改

`ai/index.md` 任务路由表三处标注（标注格式沿用 #441「（<场景>可只读 §x / §y）」语义，脚注不变）：

1. **「PR / CI / Git 收尾」行**：补 merge-only 场景标注——如「（merge-only 收尾场景可按 profile §2 最小必读集分诊，不整读本行全部）」。
2. **「模板维护 / 规则改造 / 同步机制」行**：补 C1 triage 场景标注——如「（C1 triage 场景可只读 `ai/prompts/maintainers/11-template-proposal-summary.md` + `_governance/_proposals/README.md`「远端 issue 本地镜像」「提案正文章节」节 + `CONTRIBUTING.md` §1-§5）」。
3. **registry chore / handoff 刷新场景**：在对应路由行（或其标注）补——如「（registry 登记 / handoff 刷新等纯记录写入场景可只读 `ai/session-rules.md` §1 / §3 / §4、`ai/project-rules.md` §6）」。

另随 triage 评估（本提案附带评估项，可独立裁决）：prompt 11「使用前准备」中 `CHANGELOG.md` 全文必读改为「按需（`VERSION` + 近期条目）」（hotspot §11 同族建议）。

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
