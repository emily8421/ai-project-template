# 已处理模板优化提案归档

本目录保存已经处理完成、但仍需保留审计记录的模板优化提案。

归档原则：

- `_proposals/` 是待处理 / 汇总中的提案收件箱。
- `_archive/proposals/` 是已处理提案的历史记录。
- 提案归档后，模板变更事实仍以根目录 `VERSION`、README 版本记录和 Git 历史为准。
- 归档内容不得作为当前待办事项重复执行；若要再次调整，应创建新的 `TEMPLATE-UPGRADE-*.md` 提案。

## 归档批次

| 批次 / 提案 | 归档说明 |
|---|---|
| Batch 0：`TEMPLATE-UPGRADE-batch-0-a13-sync-closure.md` | 已在 `v1.30.6` 吸收 A13 同步模板完整闭环说法、命令索引提示和自检断言；对应 issue 镜像 `issue-118.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 1：`TEMPLATE-UPGRADE-batch-1-proposal-inbox-governance-status-dictionary.md` | 已在 `v1.31.0` 吸收提案收件箱镜像机制、分批治理、横切状态词典、待确认事项总览和文档体系生成总控最低规则；对应 issue 镜像 `issue-111.md`、`issue-117.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 2：`TEMPLATE-UPGRADE-batch-2-requirements-chain-00-03.md` | 已在 `v1.33.0` 吸收 `00-03` 需求链规范、健康度矩阵、Phase 状态传播和兼容补齐规则；对应 issue 镜像 `issue-105.md`、`issue-112.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 3：`TEMPLATE-UPGRADE-batch-3-architecture-tech-risk-readiness.md` | 已在 `v1.34.0` 吸收 `04-05` 架构 / 技术方案规范、风险验证闭环、依赖配置矩阵和 readiness gate；对应 issue 镜像 `issue-106.md`、`issue-113.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 7：`TEMPLATE-UPGRADE-batch-7-docs-generation-guidance-open-items.md` | 已在 `v1.32.0` 吸收文档体系生成引导、open items 命令 / Prompt / 示例、专题方案讨论边界和定稿门禁；该批次来自维护者复核，无直接关联远端 issue。 |
| 维护修复：`TEMPLATE-UPGRADE-github-issue-query-robustness.md` | 已在 `v1.38.1` 吸收 GitHub issue / PR 查询稳定过滤、列表 + 单项状态复核和自检断言；来源为 2026-07-07 维护扫描误判复盘。 |
| 维护修复：`TEMPLATE-UPGRADE-issue-mirror-hard-gate.md` | 已在 `v1.38.2` 吸收 C1 远端 issue 本地镜像硬门禁、镜像路径清单输出和自检断言；来源为 2026-07-07 处理 `#131` 前置分析时未先落本地镜像的流程复盘。 |
| UI 原型策略：`TEMPLATE-UPGRADE-ui-prototype-strategy.md` | 已在 `v1.39.0` 吸收 UI 型项目原型策略、可视化证据、Prompt / checklist / audit / evaluation 门禁和自检断言；对应 issue 镜像 `issue-131.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| 需求探索原型：`TEMPLATE-UPGRADE-ui-prototype-exploration.md` | 已在 `v1.40.0` 吸收 A5.5 需求探索原型场景、探索记录模板、命令 / Prompt 路由、同步清单和自检断言；来源为 2026-07-07 维护会话中对“先看原型再定需求 / 架构”的流程澄清。 |
| 快速续接模式：`TEMPLATE-UPGRADE-fast-session-resume.md` | 已在 `v1.41.0` 吸收快速续接模式、`resume` 命令、handoff stale 裁决、续接元数据样例、同步清单和自检断言；来源为 2026-07-07 维护会话中过度恢复复盘。 |
| 快速续接优先路由：`TEMPLATE-UPGRADE-fast-resume-routing.md` | 已在 `v1.41.1` 吸收快速续接例外、入口裁剪、`resume` 命令路由升级和自检断言；来源为 2026-07-08 维护会话中对“读取续接点”响应过慢的复盘。 |
| 模板易用性文档补强：`TEMPLATE-UPGRADE-template-usability-docs.md` | 已在 `v1.42.0` 吸收前端交互 / UI 原型策略独立标准、实现前原型场景、`docs-scaffold` 结构模板库、术语表、同步清单和自检断言；未执行的文档模板优化候选已拆到 `_proposals/TEMPLATE-UPGRADE-docs-scaffold-followups.md` 继续评估，版本治理候选已在 `v1.42.1` 处理。 |
| 模板版本治理：`TEMPLATE-UPGRADE-version-governance.md` | 已在 `v1.42.1` 吸收 release impact / release strategy、提案收件箱不触发版本递增、同主题聚合发布、即时发布 vs 维护窗口判断和自检断言；来源为 2026-07-08 维护会话中对 `MINOR` 增长过快的复盘。 |
| 版本影响门槛收敛：`TEMPLATE-UPGRADE-version-impact-threshold.md` | 已在 `v1.44.1` 收敛 release impact 判断：兼容、可选、默认行为不变的脚本参数 / 默认关闭能力 / 自检与治理增强默认按 patch；minor 仅用于新增能力层级或新的下游采用面。 |
| 普通派生项目版本治理：`TEMPLATE-UPGRADE-derived-project-version-governance.md` | 已在 `v1.46.0` 吸收普通派生项目双版本治理最小机制：`VERSION` 记录项目自身版本，`TEMPLATE-BASE.md` 记录继承模板版本，`sync-template.* --preserve-project-version` 保留项目版本；`zhiyan` 普通派生同步试点已确认通过。 |
| 派生项目版本机制默认启用与存量迁移：`TEMPLATE-UPGRADE-derived-version-mechanism.md` | 已在 `v1.53.0`（阶段 A，新建项目默认启用版本机制：VERSION v0.1.0 + CHANGELOG + project-check.yml 校验 + project-rules §2.8）+ `v1.54.0`（阶段 B，存量派生项目版本机制启用状态非阻断检测 + 迁移引导 + 防回归断言）吸收；阶段 C（MAINTAINERS / CONTRIBUTING 文档治理）评估后不做；对应 issue #221 已关闭，镜像 `issue-221.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| 派生项目 changelog 归属修复：`TEMPLATE-UPGRADE-derived-changelog-ownership.md` | 已在 `v1.57.4` 吸收 issue #273 Batch 1：`sync-template.*` 的派生 / 领域保留过滤加入 `CHANGELOG-PLAIN.md`，`new-project.sh` 初始化项目自有 `CHANGELOG-PLAIN.md`，同步脚本增加非阻断迁移提示；Batch 2 `upstream/` 继承参考仍保留在 `_proposals/TEMPLATE-UPGRADE-upstream-inheritance-reference.md` 后续处理。 |
| 母模板 changelog 继承参考：`TEMPLATE-UPGRADE-upstream-inheritance-reference.md` | 已在 `v1.58.0` 吸收 issue #273 Batch 2：`sync-template.*` 在普通派生 / 领域模板保留路径下生成 `upstream/CHANGELOG.md` 与 `upstream/CHANGELOG-PLAIN.md` 只读继承参考；`check-derived-sync.*` 放行并校验该固定映射；#273 可在 PR 合并后关闭。 |
| Windows Git Bash 入口调用指引：`TEMPLATE-UPGRADE-windows-git-bash-invocation-guidance.md` | 已在 `v1.58.1` 吸收三脚本（`check-template` / `sync-template` / `new-project`）MSYS PATH 自举守卫（`MSYS_PATH_GUARD`）+ env-setup §8.1 三种 canonical 调用 + check-template 5 防漂移断言；来源为 codex / claude 在 Windows 调 Git Bash 反复踩坑的实测复盘（hotspot §9）；PR #278。 |
| Codex Checkpoint Mode 与远端操作防卡死 SOP：`TEMPLATE-UPGRADE-codex-checkpoint-mode-and-remote-sop.md` | Batch A 已落地（Checkpoint Mode 落地于 `ai/rules-core.md` §2 / `ai/session-rules.md` §3.3；远端防卡死 SOP 落地于 `git-guide.md` / `SOP.md`）；#195 已关闭；Batch B/C 已拆到 `capability-packages-and-profile-contracts` 提案。 |
| issue 镜像归档：`issue-207.md` / `issue-217.md` | 两 issue 已 CLOSED，由 v1.52.5 吸收（issue-207 Windows UTF-8 读取 → PR #216；issue-217 sync-template pathspec → PR #219）；镜像归档到 `_archive/proposals/_remote-issues/`，无对应独立提案。 |
| check-derived-sync squash 后缀：`TEMPLATE-UPGRADE-check-derived-sync-squash-suffix.md` | 已在 `v1.54.3` 吸收 `check-derived-sync.sh` / `.ps1` + `new-project.sh` 的 sync-commit 正则放宽，容忍 squash 合并 `(#N)` 后缀（PR #230）；来源为 digital-cs-demo v1.54.2 同步中 sync PR squash 合并到 main 后的假阳性复盘。 |
| 运行时健康检测：`TEMPLATE-UPGRADE-v1.56.0-runtime-health-detection.md` | 已在 `v1.56.0`（#240 / d5f7bc1）吸收 Node 运行时健康深度诊断（`scripts/check-runtime.ps1`：解析路径 / manager / 声明一致性 / 漂移）+ 门禁层 + check-template 4 断言 + env-setup §6；提案 PR #241 归档（1cb284a），本次补登记。 |
| 能力包传递加固（审计记录）：`TEMPLATE-UPGRADE-capability-packages-and-profile-contracts-batch1.5-patch.md` | 已在 `v1.52.4`（#210 / 1190932）吸收 Batch 1.5 防跑飞传递加固 + 最小必读；本文件为 old→new 审计记录，B0 归档。主提案 `capability-packages-and-profile-contracts` 保留（Batch 4 真待办）。 |
| 同步代理指引：`TEMPLATE-UPGRADE-sync-proxy-guidance.md` | 已在 `v1.54.2` 吸收受限网络 sync-template 代理配置（`git-guide.md` §5.7）+ fetch 失败提示 + check-template 断言；B0 归档。 |
| 派生项目登记与 Web Runway：`TEMPLATE-UPGRADE-project-registry-and-web-app-runway.md` | Batch 0–6 全落地（`v1.47.3`~`v1.52.0`；C-001 project registry `v1.54.1` / #227）；对应 issue #182 / #184 / #186 / #187 / #191 / #192 已关闭；剩余 Batch 7（领域模板迁移）无限期搁置、提案 B 第三类场景由 `domain-template-inheritance` 承接；B0 整体归档。 |
| issue 镜像归档：`issue-238.md` | #238 已 CLOSED（2026-07-21），由 `v1.55.0`（`.node-version` + `package.json#volta`，有意排除 `.nvmrc`）/ `v1.55.1`（#239）/ `v1.56.0`（#240）吸收；镜像归档到 `_archive/proposals/_remote-issues/`，无对应独立提案。 |
| Token hotspot rollup：`issue-234.md` / `issue-235.md` | #234（LUMEN_demo_T2.1）/ #235（zhiyan-digital-cs-platform）独立提案 token hotspot 累计 summary 触发；由 `v1.56.1`（C1 B1）落地 `ai/session-rules.md` §4.2（累计 summary 触发 + 内嵌 summary 结构 + 汇总状态字段）+ check-template 断言；吸收 `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md` 的 summary 闭环部分；镜像归档到 `_archive/proposals/_remote-issues/`。 |
| 正式工程文档语言与表述规范：`TEMPLATE-UPGRADE-document-language-style.md` | 已在 `v1.60.5` 吸收 `ai/global-rules.md` §10 七条 + 抗误伤边界（行业术语比喻 / 愿景方向性 / 通俗例外），并接入 document-lifecycle §10 / §11、00-generate、04-edit-single-doc、10-docs-checklist、24-health-review 五处生成 / 修改自检节点（问句式，不新增关键词 CI）；不改 `rules-core`。 |
| 2026-07-24 提案收件箱收口：`TEMPLATE-UPGRADE-token-hotspot-records.md` / `TEMPLATE-UPGRADE-capability-packages-and-profile-contracts.md` / `TEMPLATE-UPGRADE-docs-scaffold-followups.md` | 三份提案主体已由正式规则 / 文档 / 历史版本承接：token hotspot 的触发与 rollup 已进入 `ai/session-rules.md` 并有 `SUMMARY.md`；Capability / Profile 已由 `template-docs/capability-packages.md` 与 `remote-ci-sop-profile.md` 承接；docs scaffold P1 已在 `v1.43.0` 落地，P2 低频候选关闭，Task 模板后续另起窄提案。归档随 `v1.56.13` 收口。 |
| 同步预检失败隔离：`TEMPLATE-UPGRADE-agent-command-preflight.md` | 已在 `v1.60.4` 吸收 P0（`ai/rules-core.md` §4 精确查询 + 失败域隔离约束 + `sync-methodology` / `12-sync-template` 两阶段预检契约：A 身份安全事实 / B 同步能力，逐项 `pass/fail/not-checked`、辅助失败不抹关键事实）；P1 对称预检脚本 `preflight-derived-sync.*` 留候选池；来源为 2026-08-10 Codex CLI 同步预检 PowerShell `Get-ChildItem -Name` 参数构造错误中止复盘（事故无越界）；PR #317。 |
| 本地预检对齐 CI markdown clean：`TEMPLATE-UPGRADE-local-preflight-coverage.md` | 已在 `v1.61.5` 吸收：`scripts/check-template.ps1` 末尾追加 `check-markdown-clean.ps1 _proposals ai-records` 调用（本地预检覆盖 CI 两个 step）+ `check-template.sh` 防回归断言 + `remote-ci-sop-profile` §B 说明；来源为模板维护者 pitfall 双实证（08-11 / 08-13）。 |
| Web UI/UX 设计知识能力与原型参考输入体系：`TEMPLATE-UPGRADE-web-ui-design-knowledge-base.md` | 已在 `v1.62.0`（PR #348 / `58586bd`）吸收 Batch 0 + Batch 1：Batch 0 双项目试点（zhiyan 回溯 RA + flowkit 独立评估，schema 跨场景验证成立）；Batch 1 建 `template-docs/ui-knowledge/` 核心层（4 文件；13 条模式：12 reviewed + 1 candidate）+ `frontend-ui-reference-analysis-template.md` + `ui-prototype-exploration` 接入 + 同步清单 / 自检断言。Batch 2（质量治理：core 晋升 / 证据升降级 / 链接失效检查）留待后续；Batch 3（外部 Web 语料层）需独立提案再启。 |
| Web UI 知识质量基线（Batch 2A）：`TEMPLATE-UPGRADE-web-ui-knowledge-quality-governance.md` | 已在 `v1.62.1` 吸收：6 条 `SRC-*` 来源只读链接 / 发布方 / 许可口径复核落盘（5 条可访问，Microsoft HAX 暂时不可用）+ Source 新增「链接核验状态」独立字段（生命周期与链接可用性分离）+ `PAT-INT-006` 因唯一来源不可用降为 candidate + `check-template.sh` 新增 `check_ui_knowledge_structure` 结构校验（编号唯一 / 引用登记 / 链接核验状态 / 稳定字段）。Batch 2 其余（core 晋升 / 证据升降级 / 模式合并）待派生项目使用反馈。 |
| C1 文档体系治理 Batch A：issue 镜像 `issue-356.md` / `issue-355.md` | #356 由 PR #362（`v1.63.0` Batch A / A1）吸收：02/04 引用式概述章骨架（doc-standards + scaffold §0.1）+ 00-05 元信息精简口径 + docs-scaffold README 三核心节点定位（通用措辞，不点名外部行业模板——维护者 2026-08-18 拍板）；#355 由同 PR 吸收：document-lifecycle §2 E6 反向同步落点约束 + 19-docs-evaluation「阶段归属审计」维度 + 03/04 禁条可审计化。 |
| C1 文档体系治理 Batch A：issue 镜像 `issue-354.md` / `issue-358.md` | #354 由 PR #363（`v1.63.0` Batch A / A2 收口）吸收：OO 建模 overlay 全家（DIAG-UC / DIAG-DOM / DIAG-CLS-PRELIM / DIAG-STATE / DIAG-CLS + 概念/物理 ERD 两层 + §13 用例图 plantuml 指引；全部「建议 + 可选」）+ 五阶段产物映射表按**通用化示例表**口径落 docs/README §2（不引外部方法论文档名与转换编号）；#358 由同 PR 吸收：§13 图表生成式镜像机制 + docs/README §5 两生成式子目录 + `template-docs/examples/extract-diagrams.mjs` 样例（manifest 留空）+ 同步清单/断言登记。维护者拍板新增 `docs/references/` 可选参考区约定。 |
| C1 形态裁剪与场景指引 Batch B+C：issue 镜像 `issue-351.md` / `issue-357.md`（仅 §2.2）/ `issue-350.md` | #351 四项全落地（PR #364，`v1.64.0`）：`new-project.sh --shape <docs|cli|web>` + project-rules §3 裁剪执行步骤 + post-sync-cleanup 双文件审计项 + 根目录三层地图（与 #357 §2.2 合并落一处：global-rules §5 规则口径 + beginner-guide 呈现 + 生成 README 表）；#357 §2.1 物理归拢为 MAJOR 另立评估、未落地；#350 落地 session-rules §4.3 存量代码维护触发口径（障眼法实现 / 契约失配也记录）。 |
| C1 历史关闭镜像归档：`issue-314.md` / `issue-320.md` / `issue-322.md` / `issue-332.md` / `issue-333.md` / `issue-335.md` | 2026-08-12 C1 triage 链闭环后的 CLOSED 镜像：#314 → session-rules §6.1；#320 → implementation-lifecycle-rules §6（`v1.61.0`）；#322 → global-rules §2.1 L0（`v1.61.0`）；#332 → 通用层代码一致性应用说明（`v1.61.4`）；#333 → web-fullstack-profile §9（`v1.61.2`）；#335 → 选 A + gap A/B（`v1.61.3`）。评估报告见 `docs/research/2026-08-12-c1-proposal-triage-*.md` 与 `2026-08-18-c1-proposal-triage-batch-plan.md`。 |
| 项目特有场景手册指引：`TEMPLATE-UPGRADE-project-scenario-handbook.md` | 已在 `v1.64.0`（PR #364）吸收：scenario-guides §8 第三条从「只说禁止」补成「给出去处」（同步清单外项目自有目录 + project-rules §4 登记 + 编号与 A/C/M 隔离 + 沿用三层步骤表结构）+ 14-new-project 步骤 9 追加场景手册待办；来源 web-ui-knowledge-base 首个实证（`knowledge/scenarios.md` K1-K3）。 |
