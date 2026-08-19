# TEMPLATE-UPGRADE: template-docs 目录分组重组 + 手册文档同步边界

> 来源：模板维护者（2026-08-19「template-docs 平铺太多、不知怎么看；是否不必全部下行」评估会话）
> 状态：**已落地**（2026-08-19 PR #375 squash merge `1de22dd`，v1.66.0；CI template-check 通过 + L3 e2e 回归通过；归档时点随合并移入 `_archive/proposals/`；含 1 项维护者报告后修正：domain-derived-scenarios-template 改走 files_domain）
> 目标版本：v1.66.0（MINOR，两步聚合一个版本、两个 PR，沿 v1.64.0 两 PR 一版本先例）
> Release impact：minor（同步范围成员变化 + 同步文件路径迁移，派生项目需感知）
> Release strategy：Step 1 PR 先行（bump v1.66.0），Step 2 PR 并入同一版本条目；均赶在下次 6 仓同步窗口之前合并，派生项目一次同步携带全部变更

## 0. 执行摘要

现状：`template-docs/` 根目录平铺 28 个 .md + 3 个子目录，导航手册、专项 Profile、使用时才复制的模板、维护者专用文档六类性质混装；且 28 个全部无差别进入 `files_all` 下行到每个派生项目（含 4 个实测无派生侧消费者的文档）。

本提案两步走：

1. **Step 1（同步边界 + 导航）**：4 件文档停止无差别下行——3 件完全移出（`e2e-regression-checklist.md` / `e2e-report-template.md` / `rd-data-chain.md`，模板仓专用），1 件移入 `files_domain`（`domain-derived-scenarios-template.md`，领域模板保留）；`template-docs/README.md` 重写为六类分组导航。
2. **Step 2（目录重组）**：新建 `profiles/` / `templates/` / `maintainer/` 三个子目录，约 18 个文件按「读者何时用」归位；全量引用迁移 + 清单路径更新 + 孤儿审计。

两步共用一个 MINOR 版本 v1.66.0，均赶在下次派生同步窗口前合并，6 仓一次同步携带。

## 1. 动机（去项目化）

### 1.1 根目录平铺 28 文件六类混装

| 性质 | 文件 | 份数 |
|---|---|---|
| 入口 / 导航 | README、beginner-guide、glossary、template-methodology | 4 |
| 大手册 | scenario-guides（80KB）、env-setup、capability-packages、ai-cli-setup、smoke-test | 5 |
| 专项 Profile（按形态选读） | web-fullstack、web-app-scaffold-experiment、remote-ci-sop、domain-templates | 4 |
| 使用时才复制的模板 | demo-runbook、user-guide、derived-sync-report、smoke-test-report、e2e-report、5 个 UI 模板、2 个 example | 11 |
| 维护者专用 | e2e-regression-checklist、domain-derived-scenarios-template、rd-data-chain | 3 |
| 已归子目录 | docs-scaffold/（21）、ui-knowledge/（4）、examples/ | — |

「想找个模板在哪」需扫 28 个文件名；新文档加入时无归属规则可循。

### 1.2 同步边界证据（2026-08-19 引用实测）

对 4 件拟停下行文档逐一 grep 全仓消费者（`ai/` / `scripts/` / 根文档 / 派生仓 agent-system 实测）：

- **`e2e-regression-checklist.md` / `e2e-report-template.md`**：消费者仅 `e2e-sync-check.sh`（v1.65.0 起模板仓专用）、`MAINTAINERS.md` §3（维护者发布 checklist）、check-template 断言。L3 回归是模板维护者动作；与 v1.65.0「模板仓专用脚本」边界完全同构。
- **`rd-data-chain.md`**：消费者为 capability-packages（MECH-KNOW 机制行）、session-rules 两处一致性脚注、beginner-guide / methodology 导航行——全部是治理说明视角；派生项目知识沉淀的可执行规则已在 `ai/session-rules.md` §4（随行下行），本文件是模板仓视角的补充地图。
- **`domain-derived-scenarios-template.md`**：普通派生项目零消费者；领域模板 agent-system 的 `domain-overlay/agent-system/domain-derived-scenarios.md` 由它复制领域化，且 `ai/doc-standards/domain-rules.md`（files_domain 路线随行）引用它——**领域模板是真消费者**，走 `files_domain` 而非完全移出（此项为向维护者报告后的修正，非原拍板口径）。

### 1.3 为什么是 MINOR

- 同步范围成员变化（4 出，1 入 files_domain）——v1.65.0 先例：范围成员变化派生项目需在下次同步感知（dry-run 显示停更）。
- Step 2 路径迁移改变同步文件路径（约 18 个文件新路径），派生项目侧旧路径成孤儿需感知清理。
- 非 MAJOR：三级清单机制、覆盖式同步、文件内容均不变；派生侧无强制迁移（孤儿无害）。

## 1.1 与既有规则的关系（去重）

- **v1.65.0 脚本同步边界**（`_archive/proposals/TEMPLATE-UPGRADE-scripts-sync-boundary.md`）：**机制同构、对象不同**——那批管 `scripts/`（5 脚本移出清单），本提案管 `template-docs/` 文档；孤儿清理、防回流断言、new-project 裁剪、Template-only notice 均沿用其模式，不新建机制。
- **三级清单机制**（`files_all` / `files_ordinary` / `files_domain`，v1.60.0）：**复用不新增**——domain-derived-scenarios-template 从 files_all 挪入 files_domain 即该机制的首次实质启用（files_domain 原仅 domain-rules.md 一件）。
- **v1.65.1 手册主干重构**（PR #373）：**互补**——那批解决「主干与注册表的接线」，本提案解决「目录物理分组与同步边界」；Step 1 会顺带为 v1.65.1 新增的 rd-data-chain 导航行补「模板仓文档」标注。
- **`#357` §2.1 物理归拢（MAJOR）**：**对象不同**——#357 讨论的是根目录物理归拢（升级为 MAJOR 另议），本提案只动 `template-docs/` 内部，不动根目录结构。
- **C-016 / C-017 / C-018**（v1.65.0 遗留）：**互补**——本提案孤儿审计项与 C-017 的脚本孤儿清理合并在同一 post-sync-cleanup 小节执行；6 仓同步窗口（C-018）携带本版本。

**本提案不重复它们**：既有机制管「脚本边界」「三级清单」「手册导航」；缺的是 template-docs 文档维度的消费者划分与目录分组。

## 2. 拟改

### Step 1（本 PR）

#### 2.1 `template-sync.json`

- `files_all` 移出 4 项：`template-docs/maintainer/e2e-regression-checklist.md`、`template-docs/maintainer/e2e-report-template.md`、`template-docs/maintainer/rd-data-chain.md`、`template-docs/maintainer/domain-derived-scenarios-template.md`。
- `files_domain` 移入 1 项：`template-docs/maintainer/domain-derived-scenarios-template.md`。
- `description` 补充：template-docs 中模板仓专用文档（L3 回归、研发数据链地图）与领域专用模板不在 files_all。

#### 2.2 头部标注

- `e2e-regression-checklist.md` / `e2e-report-template.md` / `rd-data-chain.md`：`Sync notice` 改为 `Template-only notice`（仅模板仓维护，不下行；沿用脚本边界惯例）。
- `domain-derived-scenarios-template.md`：保留 `Sync notice`，补一句「仅领域路线下行（files_domain）」。

#### 2.3 `scripts/sync-template.sh`

- `DEFAULT_SYNC_FILES` 兜底清单同步调整（4 出；domain 路线补充清单加 domain-derived-scenarios-template——按现有 parse 机制兜底数组只覆盖 files_all，domain 项在 fallback 下缺失属既有兜底局限，注释说明即可，不扩兜底机制）。

#### 2.4 引用方措辞对齐（防派生侧断链感）

同步范围内引用这 4 件的文件，标注「模板仓文档 / 仅领域路线」：

- `ai/session-rules.md` 两处 rd-data-chain 脚注：改为「与模板仓 `template-docs/maintainer/rd-data-chain.md` §4（模板仓文档，不下行）一致」。
- `template-docs/beginner-guide.md` §7「查研发数据沉淀路径」行、`template-docs/template-methodology.md` §2 rd-data-chain 行：标注（模板仓文档）。
- `template-docs/capability-packages.md`：rd-data-chain 引用处标注；§5 补记本批边界变化。
- `template-docs/README.md`：重写为六类分组导航（Step 1 核心）——手册（根）/ profiles / templates / maintainer（模板仓专用）/ docs-scaffold / ui-knowledge；Step 2 落地前分组导航先按目标结构标注「（即将移入 X/）」或直接按现状分组、Step 2 再更新路径。**采用后者**：现状分组 + 一句话预告目录重组。
- `MAINTAINERS.md` §3 L3 回归行：标注 e2e 两件为模板仓文档；§4 同步清单规则段补本批边界。
- `SOP.md` / `git-guide.md` / `ai/prompts/maintainers/12-sync-template.md`：derived-sync-report-template 等不动（仍在清单）；仅 e2e / rd-data-chain 相关措辞标注。

#### 2.5 `scripts/new-project.sh` 初始裁剪

- 既有裁剪段（删 5 脚本处）追加：删除 `template-docs/maintainer/e2e-regression-checklist.md`、`template-docs/maintainer/e2e-report-template.md`、`template-docs/maintainer/rd-data-chain.md`、`template-docs/maintainer/domain-derived-scenarios-template.md`（新项目 = 普通路线，4 件都不该有）。

#### 2.6 post-sync-cleanup 孤儿审计

- `ai/prompts/maintainers/15-post-sync-cleanup.md` + `ai/commands/post-sync-cleanup.md`：既有「模板仓专用脚本残留」审计项扩展为「模板仓专用文件残留（脚本 + 文档）」，列出 4 个文档旧路径。

#### 2.7 `scripts/check-template.sh` 断言

- 防回流：4 项不在 `files_all`；domain-derived-scenarios-template 在 `files_domain`（扩展 `check_scripts_sync_boundary` 或并排新增文档边界分区）。
- 3 件 Template-only notice 头断言。
- 烟测：new-project 产物不含 4 件文档。

### Step 2（第二个 PR，并入 v1.66.0）

#### 2.8 目录重组（git mv，保留历史）

```text
template-docs/
├── README.md / beginner-guide.md / glossary.md / template-methodology.md
├── scenario-guides.md / env-setup.md / ai-cli-setup.md / capability-packages.md / smoke-test.md   ← 根目录 9 件手册
├── profiles/    ← web-fullstack-profile.md / web-app-scaffold-experiment.md / remote-ci-sop-profile.md / domain-templates.md
├── templates/   ← demo-runbook-template / user-guide-template / derived-sync-report-template / smoke-test-report-template / e2e-report-template(如 Step1 已停更则入 maintainer) / ui-brief-intake-template / ui-prototype-exploration-template / ui-prototype-strategy-template / frontend-experience-brief-template / frontend-ui-reference-analysis-template / session-handoff.example.md / docs-open-items.example.md
├── maintainer/  ← e2e-regression-checklist.md / rd-data-chain.md / domain-derived-scenarios-template.md
├── docs-scaffold/  ← 不动
├── ui-knowledge/   ← 不动
└── examples/       ← 不动
```

- 根目录从 28 件收敛到 9 件手册 + 3 子目录（既有 docs-scaffold / ui-knowledge / examples 不动）。
- e2e-report-template.md 归 maintainer/（Step 1 后为模板仓专用）；templates/ 共 11 件。

#### 2.9 全量引用迁移

- 实测引用文件数：web-fullstack-profile 17 / domain-templates 12 / derived-sync-report 9 / ui-prototype-strategy 9 / ui-brief-intake 8 / frontend-ui-reference 7 / demo-runbook 7 / ui-prototype-exploration 6 / remote-ci-sop 6 / web-app-scaffold 5 / smoke-test-report 5 / session-handoff.example 4 / frontend-experience-brief 4 / docs-open-items.example 3 / user-guide 2（引用处估计 80-120 处）。
- 迁移范围：`ai/`（commands / prompts / doc-standards / rules）、`SOP.md`、`MAINTAINERS.md`、`CONTRIBUTING.md`、`README.md`、`git-guide.md`、`template-docs/` 内部互引、`scripts/check-template.sh` 断言路径、`template-sync.json`、`sync-template.sh` 兜底清单。
- 领域仓连带：agent-system-template 的引用在它下次同步时由随行文件（domain-rules.md、commands、prompts 均同步覆盖）自动更新；其自建 domain-overlay 引用需其维护者自改（同步报告提示）。

#### 2.10 孤儿审计（Step 2 追加）

- post-sync-cleanup 审计项追加：旧路径残留（约 15 个旧路径 × 6 仓）；`check-derived-sync` 按新清单校验自动放行。

## 3. 版本

**MINOR → v1.66.0**（两步聚合，沿 v1.64.0「两 PR 一版本」先例：Step 1 PR bump 版本 + 首条目，Step 2 PR 并入同条目补充）。依据：同步范围成员变化 + 路径迁移 = 下游需感知的采用面变化；非 MAJOR：机制与内容不变、无强制迁移。

## 4. 影响

- **模板仓**：文件只移不删；引用全量迁移；CI 断言更新。
- **派生项目（下次同步起）**：普通路线少收 4 件文档；Step 2 后约 15 个文件路径变化，旧路径残留为无害孤儿，随 post-sync-cleanup 清理（脚本 + 文档孤儿一并）。
- **领域模板**：保留 domain-derived-scenarios-template（files_domain）；其余同普通路线。
- **新项目**：`new-project.sh` 产物不含 4 件模板仓 / 领域专用文档；Step 2 后新项目直接落新路径。
- **回滚**：模板侧 revert；派生侧孤儿从模板仓复制回（均为模板资产）。
- **风险**：① 引用迁移漏改 → 断链。控制：grep 全量核对 + check-template 路径断言 + L3 e2e。② 与 6 仓同步窗口叠加 → 两步均在窗口前合并，派生一次同步携带（窗口目标版本改为 v1.66.0）。③ 兜底清单 fallback 不含 domain 项 → 注释说明既有局限，不扩机制。

## 5. 验证方式

1. `bash scripts/check-template.sh --summary`：断言更新后全过（含防回流 / Template-only notice / 烟测）。
2. `check-markdown-clean.ps1` 改动 Markdown。
3. `bash scripts/new-project.sh <名> --local --no-remote --no-examples` 烟测：产物无 4 件文档（Step 2 后：新路径结构 + 无孤儿）。
4. `bash scripts/sync-template.sh <派生仓> --dry-run`：报告正确显示 4 件停更 / 1 件转 domain（Step 2 后新路径）。
5. **L3 e2e 回归**（MINOR 必跑）：`bash scripts/e2e-sync-check.sh` + `template-docs/maintainer/e2e-regression-checklist.md` R4-R6 人工项 + 报告。
6. 人工评审：README 分组导航可读性；引用迁移抽查。

## 6. 实施记录（2026-08-19，v1.66.0）

### 6.1 Step 1（commit `68ddf8e`）

- 18 文件 +267/-39：template-sync.json（4 出 1 转 + description）、3 件 Template-only notice 头 + domain-derived 头部领域路线标注、sync-template.sh 兜底清单（4 出 + 兜底范围注释）、session-rules 两处脚注标注、beginner-guide / template-methodology / capability-packages 导航与 §5 补记、MAINTAINERS §3/§4、new-project.sh 裁剪 4 件、post-sync-cleanup 孤儿审计（prompt + command）、template-docs/README.md 五组导航重写、check-template.sh 边界断言（28 项分区）+ 烟测 4 项、check-template.ps1 镜像。
- 验证：check-template.sh 2093 项 / 0 失败（Step 1 时点）。

### 6.2 Step 2（同分支后续 commit）

- git mv 19 文件归三子目录（profiles 4 / templates 11 / maintainer 4）；根目录收敛至 9 件手册。
- 引用迁移：sed 批量 + 分组验证——profiles 组 36 文件、templates 组 33 文件、maintainer 组 24 文件；grep 复查零旧路径残留（排除 _archive / .ai）。
- check-template.sh 断言 pattern 批量更新（约 105 处新路径）；发现并修复「sed 只改被检文件内容、漏改断言 pattern」的 27 项失败后全过。
- template-sync.json 指向文件存在性校验（files_all 151 + files_domain 2 全部存在）；两脚本 bash -n 语法通过。
- post-sync-cleanup 追加「旧路径残留」审计项（prompt §98 后新增 + command 4c）。
- 验证：check-template.sh 2093 项 / 0 失败。

### 6.3 验证结果汇总（PR 前，2026-08-19）

- `check-markdown-clean.ps1 _proposals template-docs`：61 文件通过；`git diff --check` 通过（仅 LF→CRLF Windows 常态提示）。
- `check-template.sh --summary`：Step 1 后 2093 项 / 0 失败；Step 2 断言修正后复跑 2093 项 / 0 失败。
- new-project 烟测（`--local --no-remote --no-examples`，HEAD 含 Step 2 后）：产物 `template-docs/` = 9 件手册 + profiles/（4 件）+ templates/（11 件）+ 既有子目录；maintainer/ 4 件文档已删、空目录已清（首测发现空目录残留，补 `rmdir` 后复测通过）。首测曾因「git archive HEAD 早于 Step 2 提交」产出旧结构——已确认是验证时序问题，非脚本缺陷。
- 分发逻辑直测（模拟普通 / 领域两条路线，8 项断言）：全 PASS——普通路线收 profiles + templates、不收 4 件模板仓/领域专用；领域路线额外收 domain-derived-scenarios-template、同样不收 e2e 两件与 rd-data-chain。
- 真实派生仓 dry-run：被同步脚本自身更新保护拦截（本地脚本旧版 + 远端 main 未含本分支，SOP 已知情形），改用上述清单分发直测等价覆盖；全链 dry-run 待 PR 合并后随同步窗口自然验证。
- L3 e2e 回归（MINOR 必跑）：`bash scripts/e2e-sync-check.sh` + checklist R4-R6 人工项——合并前执行，报告落 `ai-records/e2e-reports/`。
