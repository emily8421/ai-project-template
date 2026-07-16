# TEMPLATE-UPGRADE: 派生项目版本管理机制默认启用与存量迁移

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流；远端 issue #221 镜像见 `_proposals/_remote-issues/issue-221.md`（raw 副本，不改）
> 状态：阶段 A 已实现（待合并）；阶段 B 存量迁移检测 / 引导、阶段 C 文档治理延后
> 目标版本：v1.53.0（阶段 A，MINOR）；阶段 B / C 版本待评估
> Release impact：minor（AI 建议，已 bump v1.53.0；初始化流程新增必填项 + 新建项目默认行为变化，仅影响新建项目，不要求存量迁移）
> Release strategy：分阶段落地；阶段 A 单独 PR 合并；阶段 B / C 独立 PR

## 1. 背景

模板已建立双版本机制（v1.46.0）：派生项目 `VERSION` 记录项目自有版本，`TEMPLATE-BASE.md` 记录继承的模板版本。但模板只提供「版本骨架」，没有提供「版本机制」（递增规则 + 一致性校验 + 启用路径）。

在一个推进到 MVP 验收阶段的派生项目中复盘发现：`VERSION` 自双版本迁移后长期停滞、`CHANGELOG.md` 项目版本段只有基线一条、CI 不校验版本、`ai/project-rules.md` 无版本规则。这是结构性缺口。完整动机与原始拟改见 issue #221 镜像。

## 2. 范围拆分决策（重新评估结论）

issue #221 原提案 §4 把「新建启用（§4.2）」与「存量迁移（§4.3）」并列。两轮独立只读评估（Codex CLI + Claude）收敛：二者风险 / 复杂度量级不同，直接合实现范围易失控，应分阶段。拆成三个 PR：

- **阶段 A（PR A，本次）**：新建项目默认启用版本机制。覆盖 issue §4.1（bump 规则通用默认，落在 `ai/project-rules.md` 种子）+ §4.2（new-project 默认启用）+ §4.4（check-template 防回归断言）。
- **阶段 B（PR B，延后）**：存量派生项目启用路径（检测 + 引导 + 一次性人工确认）。覆盖 issue §4.3。依赖：`scripts/check-derived-sync.*` 已有非阻断版本提示模式可复用、`ai/prompts/maintainers/15-post-sync-cleanup.md` 现状。
- **阶段 C（PR C，延后 / 可并入 B）**：文档治理与发布说明。覆盖 `template-docs/scenario-guides.md`、`MAINTAINERS.md`、`CONTRIBUTING.md`、`TEMPLATE-BASE.md` 配套说明（issue §4.4 文档部分）。

理由：阶段 A 只影响新建项目，不碰存量、不碰同步清单结构（`ai/project-rules.md`、`project-check.yml` 是项目自有，不在 `template-sync.json`；`VERSION` / `CHANGELOG.md` 受 `--preserve-project-version` 保护），风险最小、验收最清晰；阶段 B 涉及存量项目检测基线与迁移引导，需独立设计；阶段 C 是配套文档，可聚合。

## 3. 阶段 A 实现记录

实际改动（6 文件 + 提案）：

- `scripts/new-project.sh`：
  - `VERSION` 初始化为项目自有 `v0.1.0`（`DERIVED_PROJECT_VERSION`），修正原继承模板版本号的遗留。
  - 生成派生 `CHANGELOG.md` 初始版本段 `## v0.1.0（date）`（**超纲补全**：issue §4.2 未明列，但 §5 验收要求 CHANGELOG 顶部项目版本匹配 VERSION，故必要）。
  - `TEMPLATE-BASE.md` 的 `Project version at sync time` 改记项目版本 `v0.1.0`；`Current synced template version` 仍记模板继承版本（**超纲**：issue §4.2 只说 TEMPLATE-BASE 仍记录继承版本，未明确该字段改记项目版本）。
  - `.github/workflows/project-check.yml` 增加 `Check project version consistency`：校验 `VERSION` 三段式 + `CHANGELOG.md` 顶部第一个 `## vX.Y.Z（` 等于 `VERSION`，**不做全文档降序检查**（派生 CHANGELOG 顶部项目版本下方接数值更大的模板历史版本，降序不适用）。
- `ai/project-rules.md` 种子：增加 `§2.8 项目版本管理`（PATCH / MINOR / MAJOR 默认语义 + 可覆盖提示 + git tag 待确认）+ 首次必填 checklist 增加「§2.8 项目版本管理」项。
- `ai/prompts/setup/14-new-project.md`：预期产出增「项目自有版本起点 v0.1.0」、待办增「项目版本管理」、禁忌项增「不要把 VERSION 改回模板版本号」。
- `scripts/check-template.sh`：`require_new_project_local_smoke` 增 5 条烟测断言（VERSION / CHANGELOG / TEMPLATE-BASE / project-check.yml / project-rules §2.8）；全局增 3 条断言（new-project.sh 含版本校验 step、含 `DERIVED_PROJECT_VERSION="v0.1.0"`、project-rules 含 §2.8）。
- `VERSION` / `CHANGELOG.md`：v1.52.5 → v1.53.0（MINOR）。

断言只加 `check-template.sh`，未碰 `check-template.ps1`（PowerShell fallback 只做结构检查，不塞复杂内容断言，符合既有约定）。

## 4. 评估发现与待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | TEMPLATE-BASE 字段 `Project version at sync time` 现装项目版本，命名拧 | 改名 `Project version at creation` | 字段语义已从「同步时模板版本」偏移到「创建时项目版本」 | `Initial project version` / 保持原名 | 烟测断言已锁定当前命名，改名需同步断言；可归阶段 A 收尾或阶段 C。不阻塞合并 |
| C-002 | `§2.8` 节号被 check-template 断言 + checklist 硬编码 | 记为已知约束，暂不改 | 将来在 §2.8 前插节会使节号漂移、断言失效 | 用稳定关键词而非节号匹配 | 属模板既有风格；不阻塞 |
| C-003 | 阶段 B 合并时的版本策略 | 阶段 B 启动时定，倾向独立 MINOR | 阶段 B 是新增存量迁移能力 | 同 MINOR 延续 | 影响阶段 B 的 VERSION / CHANGELOG |
| C-004 | 阶段 B「VERSION 是否仍为继承语义」的检测基线 | 对照 TEMPLATE-BASE 的 `Current synced template version` 判定，非朴素字符串比对 | 阶段 A 后 VERSION 默认 v0.1.0，不能再凭「VERSION == 模板版本号」判定未启用 | 检测 project-rules 是否缺 §2.8 / project-check.yml 是否缺版本校验 step | 阶段 B 设计前提，不阻塞阶段 A |
| C-005 | issue #221 的关闭时机 | 阶段 A 合并后保持 open，或拆分出新 issue 跟踪阶段 B/C | 存量迁移未做，原 issue 范围未完成 | 阶段 A 合并即关 #221，另开新 issue | 过早关闭会丢失存量迁移待办 |

## 5. 验证

- `scripts/check-template.sh`：实现完成；提交前烟测 1 项失败（`new-project 烟测 project-rules 含项目版本管理`），根因 = `new-project.sh --local` 用 `git archive HEAD`，未提交的 `ai/project-rules.md` §2.8 不在 HEAD（**非缺陷**，是验证时机假阴性）；提交后 §2.8 进入 HEAD，重跑预期全绿。
- `scripts/e2e-sync-check.sh`：MINOR 发布门（L3 可自动化部分），阶段 A 合并前跑；人工项 R4-R6 对本改动（不碰场景路由 / 文档生成 / PowerShell fallback）基本不相关，快速过。
- issue §5 验收对照：新建烟测（check-template 断言覆盖）；存量迁移烟测（阶段 B）；自检全过（提交后验证）。

## 6. 归档计划

阶段 A 合并后，本提案**保留在 `_proposals/`**（阶段 B / C 未完成）。待阶段 B / C 全部合并后再移 `_archive/proposals/`。issue #221 按 C-005 处理关闭时机。
