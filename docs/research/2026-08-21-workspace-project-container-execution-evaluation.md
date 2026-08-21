# 实施评估报告：workspace-project-container 提案（执行后只读评估）

> **顶部锚定说明**（`ai/document-lifecycle-rules.md` §8）
> - **外部文档命名与本仓 docs 的映射关系**：本文评估另一 AI 在分支 `feat/project-container-introduction` 上对提案 `_governance/_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` 的执行；与本仓 `docs/` 内的项目事实文档体系无直接对应，仅作为提案/实施对照的留痕证据。
> - **定位声明**：本文为**实施评估**（Execution Evaluation），不是提案评估（Proposal Evaluation）；既不替代 `docs/09-verification.md` 的验收证据，也不替代 `template-docs/maintainer/e2e-regression-checklist.md` 的回归清单；不进 git 跟踪（实际状态 untracked），仅作本地分析留痕。
> - **追溯链**：实施依据 = 提案 `_governance/_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` §4 §5 + 评估报告（chat 内，未落盘）+ 本文 §2 问题项 / §4 修复建议。
> - **分区归属**：按 `docs/README.md` §1 分类，本文为"决策 / 调研类外部接入留痕"——只放 `docs/research/`，不得改 `docs/` 根目录或 00-09 正式文档。

---

## 0. 元信息

| 字段 | 值 |
|---|---|
| 评估时间 | 2026-08-21 |
| 评估者 | claude（MiniMax-M3，会话内） |
| 评估输入 | HEAD `0803813` + 278 staged rename + 15 unstaged 修改 + `bash scripts/check-template.sh` 实跑结果（79 项失败 / 2014 项通过） |
| 评估规则 | `ai/global-rules.md` §4 + `ai/implementation-lifecycle-rules.md` §5 §9 + 提案 §4 §5 + 评估报告 10 ISS / 7 RSK |
| 评估对象 | 分支 `feat/project-container-introduction` 工作区（含 staged + unstaged），未 commit |
| 评估性质 | 只读评估，**未修改任何文件**（落盘本文除外） |
| 评估产出 | 合规 8 / 问题 19 / 风险 7 / 修复建议 10 / 评分 50/100 / 结论：**不可进 PR** |

---

## 1. 总体结论

**执行完成度约 50%**，**check-template 自检仍红灯（79/2093 失败）**，**ROOT-C-006 派生仓首提交裁剪未完整落地**——**不可进入 PR 阶段**。

### 1.1 评分矩阵

| 维度 | 满分 | 得分 | 备注 |
|---|---|---|---|
| 目录迁移（git mv） | 20 | **20** ✅ | 278 文件 0+/0- 纯 rename，路径方向正确 |
| 关键脚本适配 | 20 | **20** ✅ | new-project / sync-template / check-derived / check-template 等 5 个脚本已改 |
| check-template.* 自身断言一致性 | 15 | **5** ❌ | 79 项失败（line 735-736 / 1433 / 1562-1563 / 1613-1616 / 2118+ 漏改） |
| 文档层引用同步（10+ 文档） | 15 | **5** ❌ | 改了 9/15+ 引用根级路径的文件 |
| **ROOT-C-006 派生仓首提交裁剪** | 10 | **0** ❌ | **关键漏洞**：new-project.sh 未 rm 根级 5 治理目录 |
| 垃圾清理 + proposal commit | 10 | **0** ❌ | check-run*.log 3 个未删；proposal 文件 untracked |
| 验证矩阵（smoke + e2e） | 10 | **0** ❌ | 三形态 smoke + e2e-sync-check 未跑 |
| **合计** | **100** | **50 /100** | |

### 1.2 一句话结论

另一个 AI 的实施"路径方向正确、关键脚本适配完成"，但**自检断言不一致 + ROOT-C-006 关键漏洞 + 10+ 文档层引用漏改**——按 `implementation-lifecycle-rules §9`「禁止未运行验证就宣布完成」「禁止把未验证、Mock、降级或人工假设写成已通过」属红线。

---

## 2. 合规项（passes）

按 `ai/global-rules.md §4` 与 `ai/implementation-lifecycle-rules §5 §9`：

1. **目录迁移完整**：278 文件 0+/0- rename，含 frontend/backend/tests/docker → project/、_archive/_examples/_proposals/ai-records/sync-records → _governance/，子目录结构完整保留。✅
2. **关键脚本已适配**：`scripts/new-project.sh`（19 行）、`scripts/sync-template.sh`（1 行）、`scripts/check-derived-sync.{sh,ps1}`（6 行）、`scripts/check-template.{sh,ps1}`（62 行合计）已全部 unstaged 改动。✅
3. **方法论层部分适配**：`ai/global-rules.md §5`（通用目录骨架 + 三层区分类）、`ai/project-rules.md`、`ai/doc-standards/project-rules.md`、`template-docs/profiles/web-fullstack-profile.md`（39 行）已改。✅
4. **管理层部分适配**：`README.md`、`MAINTAINERS.md`（5 处 `_proposals/` → `_governance/_proposals/`）、`git-guide.md`（6 处：批量同步 ai-records 路径 + 同步禁止路径 frontend → project + sync-records 路径）已改。✅
5. **`check-markdown-clean.ps1` 参数已更新**（ISS-004 修复）：`scripts/check-template.ps1` line 405-408 改为 `_governance/_proposals _governance/ai-records`。✅
6. **C1 triage 已闭环**：issue-290.md + issue-334.md（_remote-issues 镜像）已纳入 unstaged 修改。✅
7. **sync 模式保护路径已改**：`scripts/sync-template.sh`、`scripts/check-derived-sync.{sh,ps1}` 的禁止路径 frontend/* → project/frontend/* 等已正确。✅
8. **`tasks/` 不动符合 ROOT-C-007** ✅

---

## 3. 问题项（issues / 实施差距）

### 3.1 P0：实施层关键漏洞

| ID | 问题 | 证据 | 影响 |
|---|---|---|---|
| **ISS-101** | **check-template.sh 仍 79 项失败**：line 735-736 / 1433 / 1562-1563 / 1613-1616 / 2118+ 仍硬编码根级路径或旧字符串 | 实跑结果：`❌ 模板自检失败：79 项失败 / 2014 项通过` | 提案 §5.2 / §5.6 自检门槛不达标，**PR 不可合并** |
| **ISS-102** | **ROOT-C-006 派生仓首提交裁剪未落地**（关键漏洞）：new-project.sh 仅 `rm -rf "$TARGET/_governance"`（此时 _governance 不存在）+ mkdir 5 子目录 + 写 4 README 种子，但**未 rm 根级 5 治理目录**；而 HEAD 中 `_proposals/ _archive/ _examples/ ai-records/ sync-records/` 5 治理目录仍 tracked，`git archive HEAD \| tar -x` 会把整个模板仓拉进派生项目 → 派生仓首提交**含根级 5 治理目录（含模板治理内容 e2e-reports/pitfalls/token-hotspots 等）+ 空 `_governance/` 容器（冗余）** | new-project.sh line 215-245（grep 实查） | 派生仓首提交违反 ROOT-C-006 拍板（"裁内容、保留分区 README 种子"），违反"裁内容"语义；派生仓会被打回 |
| **ISS-103** | **check-run*.log 3 个文件未删除**（ROOT-C-009 拍板删除未执行） | `ls -la check-run*.log`：3 个文件 149K/152K/105K，Aug 13 时间戳 | 提案 §4 拍板未落地，根目录残留 |
| **ISS-104** | **proposal 文件未纳入版本管理**：`_governance/_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` 仍 `??` untracked | `git status` 显示 `??` | 提案不会被 commit 进 git 历史，违反 `document-lifecycle-rules §11`「生成后自检」要求 |

### 3.2 P1：文档层引用漏改（评估报告 ISS-003 风险实现）

执行者改了 9 个引用根级路径的文件，但**漏改 10+ 个**：

| 文件 | 漏改位置 | 严重度 |
|---|---|---|
| ❌ `template-docs/beginner-guide.md` | line 4（`_proposals/`）、132-133（`sync-records/ ai-records/ _proposals/`） | 高（提案 §4 第 8 行明确要求） |
| ❌ `CHANGELOG-PLAIN.md` | line 4、90（`ai-records/token-hotspots`）、143（`_examples`副本）、210、215 | 中 |
| ❌ `SOP.md` | line 4、51（`sync-records/template-sync`）、60（`_proposals/_archive`）、89 | 中 |
| ❌ `docs/README.md` | line 4、85（`_proposals/`） | 高（ISS-006 联动） |
| ❌ `ai/document-lifecycle-rules.md` | line 4（`_proposals/`） | 高（提案 §4 第 7 行明确要求） |
| ❌ `ai/commands/README.md` | line 4（`_proposals/`） | 中 |
| ❌ `ai/commands/new-project.md` | line 4（`_proposals/`） | 高（提案 §4 第 7 行明确要求） |
| ❌ `ai/prompts/setup/14-new-project.md` | line 4（`_proposals/`） | 高（提案 §4 第 7 行明确要求） |
| ❌ `ai/implementation-lifecycle-rules.md` | line 4（`_proposals/`） | 中 |
| ❌ `scripts/README.md` | line 3（`_proposals/`）、9（`_archive/proposals/`） | 高（提案 §4 第 8 行明确要求） |

这些文件含 "Sync notice: ... 改进请在 `_proposals/` 起草提案..."——这个 Sync notice 模板没改，会让后续误引用旧路径。

### 3.3 P1：check-template 自身断言不一致

执行者改 `check-template.sh` 时**改得不彻底**：

| 断言行号 | 期望 | 实际 | 状态 |
|---|---|---|---|
| line 548-564 | smoke 测试 `_governance/...` | 已改 | ✅ |
| line 1030-1056 | 模板根级 `_governance/_proposals/...` `_governance/ai-records/...` | 已改 | ✅ |
| line 2105-2110 | `_governance/_examples/...` | 已改 | ✅ |
| **line 735-736** | `new-project.sh` 含 `rm -rf "$TARGET/_proposals"` / `mkdir -p "$TARGET/_proposals"` | **未改** | ❌ |
| **line 1433** | 根级 `_proposals/README.md` 含 `GitHub issue` | **未改**（应改为 `_governance/_proposals/README.md`） | ❌ |
| **line 1562-1563** | 根级 `_proposals/README.md` 含 `PSObject.Properties['pull_request']` / `列表 \+ 单项状态复核` | **未改** | ❌ |
| **line 1613-1616** | 根级 `_proposals/README.md` 含 issue 镜像字段（4 条） | **未改** | ❌ |
| **line 2118+** | `_examples/vision-to-product/OVERVIEW.md` 等含 `ai/prompts/docs/00-generate-or-complete-docs\.md` | **未改**（应改为 `_governance/_examples/...`） | ❌ |

### 3.4 P2：评估报告 10 项修订均未落实

| 评估 ISS | 修订项 | 状态 |
|---|---|---|
| ISS-001 数字偏差（38→30/156→151/约15→约20） | proposal 文件 untracked，未修改 | ❌ |
| ISS-002 `docs/research/` 归属 | 未明确；new-project.sh 没 rm docs/research/ | ❌ |
| ISS-003 grep 巡检补缺 | 仅改了 9 个引用根级路径文件；漏 10+ | ⚠️（部分） |
| ISS-004 check-markdown-clean 参数 | ✅ 已改 | ✅ |
| ISS-005 entry-level 拆分 | 未拆 | ❌ |
| ISS-006 docs/README.md 联动 | 未改 | ❌ |
| ISS-007 实施分支 vs 模拟分支 | proposal 未改 | ❌ |
| ISS-008 回滚路径 | proposal 未加 | ❌ |
| ISS-009 命名工程惯例 | 未加 | ❌ |
| ISS-010 命名规则显式 | 未加 | ❌ |

### 3.5 P2：风险缓解未落实

| 评估 RSK | 风险缓解 | 状态 |
|---|---|---|
| RSK-001 派生同步窗口排期 | 未明示 | ❌ |
| RSK-002 grep 漏改 | 部分缓解（9/15+） | ⚠️ |
| RSK-003 三形态 smoke | 未跑 | ❌ |
| RSK-004 docs/research/ 处置 | 未防住 | ❌ |
| RSK-005 工作区保护 | 未 commit | ❌ |
| RSK-006 template-docs/maintainer/ | 未触及 | ✅ |
| RSK-007 派生仓首提交纯净度 | **未防住**（ISS-102 关键漏洞） | ❌ |

---

## 4. 风险项（执行后剩余风险）

| ID | 风险 | 触发条件 | 影响 |
|---|---|---|---|
| **RSK-101** | check-template.sh 跑红 → CI 红 → 提案 §5.2 自检门槛不达标 → 不可 PR | 任何跑 `bash scripts/check-template.sh` 的 CI 节点 | PR 必拒 |
| **RSK-102** | new-project.sh 派生仓首提交含根级 5 治理目录 + 空 `_governance/` → 违反 ROOT-C-006 | 任一派生项目用此模板 init | 派生项目被打回；用户需手动删根级 5 治理目录 |
| **RSK-103** | proposal 文件 untracked → git 历史不记录实施依据 → 提案与实施脱钩 | 实施 PR merge 后回查 | 失去追溯链（违反 `document-lifecycle-rules §11`） |
| **RSK-104** | 文档层 10+ 文件仍引用根级 `ai-records/_proposals/...` 路径 → 派生项目首提交后这些文档跳链/误引 | 派生项目首提交 + 用户阅读文档 | 用户看到"提案收件箱在 `_proposals/`"但实际是 `_governance/_proposals/` → 困惑 |
| **RSK-105** | 未跑三形态 smoke → `--shape web/docs/cli` 派生路径未实测 | 任何新派生项目 | 形态裁剪漏洞未发现 |
| **RSK-106** | 6 仓派生同步窗口与本提案时点未排期 → 同步 PR 含本提案时未做完整回归 | 6 仓同步窗口开启 | 派生仓回归失败 |
| **RSK-107** | unstaged + 7 个 untracked 混在工作区 → 未 commit 未 stage 部分 → `git reset --hard` 或 stash 误操作丢改动 | 任何 reset/clean 操作 | 实施成果部分丢失 |

---

## 5. 修复建议（按优先级）

### 5.1 立即修（P0，PR 不可合并）

**R1. 修 check-template.sh 自身断言不一致**（ISS-101）：
- line 735-736：改为 `rm -rf "\$TARGET/_governance"` / `mkdir -p "\$TARGET/_governance/_proposals"`，或保留新 new-project.sh 的 5 子目录创建行为
- line 1433 / 1562-1563 / 1613-1616：全部改为 `_governance/_proposals/README.md`
- line 2118-2118+：全部改为 `_governance/_examples/...`

**R2. 修 ROOT-C-006 派生仓首提交裁剪**（ISS-102 关键漏洞）：
在 `scripts/new-project.sh` line 220 之前插入：
```bash
# ROOT-C-006 派生仓首提交应不含模板治理内容，仅保留 _governance/ 空容器 + 4 README 种子
rm -rf "$TARGET/_proposals" "$TARGET/_archive" "$TARGET/_examples" "$TARGET/ai-records" "$TARGET/sync-records"
```
然后把 line 220 改为 `mkdir -p "$TARGET/_governance" "$TARGET/_governance/_proposals" ...`（逻辑同当前）。

**R3. 处理 proposal + check-run*.log**（ISS-103/104）：
- `git add _governance/_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`（纳入 commit）
- 删除 `check-run.log` `check-run2.log` `check-run3.log`（ROOT-C-009）

### 5.2 PR 前必做（P1）

**R4. 文档层引用同步**（ISS-101 + 评估报告 ISS-003）：
- 用 ripgrep 跑：
  ```bash
  rg -l -e "_proposals/" -e "ai-records/" -e "sync-records/" -e "_archive/" -e "_examples/" \
     --type-not-binary . | grep -v "^\.git/" | grep -v "^_governance/" | sort
  ```
- 把命中的 10+ 文件逐处替换为 `_governance/...` 前缀（除已迁的文件本身）
- 重点文件：`template-docs/beginner-guide.md`、`CHANGELOG-PLAIN.md`、`SOP.md`、`docs/README.md`、`ai/document-lifecycle-rules.md`、`ai/commands/README.md`、`ai/commands/new-project.md`、`ai/prompts/setup/14-new-project.md`、`ai/implementation-lifecycle-rules.md`、`scripts/README.md`

**R5. 评估报告 ISS-001~010 / RSK-001~007 修订项并入实施**：
- ISS-001 修订 proposal 数字（38→30、156→151、约 15→约 20）
- ISS-002 明确 `docs/research/` 归属（加到 ROOT-C-006 裁剪清单 OR 写明保留）
- ISS-006 联动 `docs/README.md`（与 R4 合并）
- ISS-008 加回滚路径段
- ISS-009 加"为什么不沿用 `src/`"说明
- ISS-010 加下划线前缀命名规则

**R6. 三形态 smoke 实跑**（RSK-003）：
```bash
bash scripts/new-project.sh smoke-web --local --no-remote --shape web
bash scripts/new-project.sh smoke-docs --local --no-remote --shape docs
bash scripts/new-project.sh smoke-cli --local --no-remote --shape cli
```
验证派生仓首提交目录树 + check-template 通过。

**R7. e2e-sync-check**（提案 §5.6）：
```bash
bash scripts/e2e-sync-check.sh
```
按 `template-docs/maintainer/e2e-regression-checklist.md` 完成 R4-R6 人工项。

### 5.3 PR 提交建议（P2）

**R8. 拆 3 个 commit**（评估报告 RSK-005 缓解）：
- commit 1：`refactor: 迁移 4 代码目录至 project/ + 5 治理目录至 _governance/`（git mv 278 文件）
- commit 2：`feat(scripts): 治理归拢 new-project.sh + sync/check-derived 路径适配`
- commit 3：`docs(guide): 同步禁用路径 + 顶层 README/MAINTAINERS/git-guide 引用更新`
- commit 4：`chore(proposals): 归档本提案到 _governance/_archive/proposals/`（如适用）

**R9. 6 仓派生同步窗口排期**（RSK-001）：
- 与首个 MINOR 携带本改动的窗口对齐
- agent-system 走 `--domain-template` 验证 domain-derived 分发
- LumiOne / gmbl 留 ≥1 完整窗口缓冲

**R10. 评估报告 ISS-005 / ISS-007 修订提案**：
- ISS-005 entry-level 拆分
- ISS-007 实施分支说明修订

---

## 6. 总体评估

### 6.1 关键判断

**可进 PR 阶段？**：❌ **不可**。理由：
1. check-template.sh 自检跑红 79 项（CI 必拒）
2. ROOT-C-006 派生仓首提交裁剪未落地（违反拍板）
3. 10+ 文档层引用未改（文档跳链）
4. proposal 文件未纳入版本管理（追溯链断）

**是否符合 `implementation-lifecycle-rules §9` 禁止项**：
- ❌ "禁止未运行验证就宣布完成"：check-template 跑了但 79 项失败未处理
- ❌ "禁止把未验证、Mock、降级或人工假设写成已通过"：new-project.sh 的"治理归拢"实际未删根级 5 治理目录

### 6.2 与评估报告（chat 内，未落盘）对照

| 评估项 | 评估预期 | 实际执行 | 差异 |
|---|---|---|---|
| 影响面 11 类来源文件 | 全部覆盖 | 覆盖 9-10 类 | 漏：git-guide 已改 ✓；但漏：scripts/README / docs/README / SOP / CHANGELOG-PLAIN / beginner-guide / document-lifecycle / commands / prompts/setup 等 10+ |
| ISS-003 grep 巡检 | 须做 | 仅改了部分 | 漏 10+ 文件 |
| RSK-005 工作区保护 | 须 commit | 未 commit | 风险仍存 |
| RSK-007 派生仓首提交纯净度 | new-project.sh 应 rm 根级 5 治理 | **未做**（关键漏洞） | 与评估报告反向 |
| ISS-004 check-markdown-clean 参数 | 应改 | ✅ 已改 | 完成 |

> 评估观察偏差：评估时 `git diff --name-only` 输出被 CRLF warning 行误导，我看错 unstaged 文件数为 11 个，实际是 15 个（git-guide.md / check-template.{sh,ps1} / MAINTAINERS.md 也已改）。但 10+ 文档层引用漏改与 new-project.sh 的 ROOT-C-006 漏洞是评估时已预警（ISS-003 + RSK-007），执行仍踩坑——属"知道风险但未防住"。

### 6.3 行动建议（按 `feedback-review-before-apply`）

**结论**：另一个 AI 的实施完成度约 50%，**关键漏洞是 ROOT-C-006 未完整落地**——`new-project.sh` 没删根级 5 治理目录会让派生仓首提交含模板治理内容（违反拍板）。

**建议下一步**：
1. (a) **修 P0（ISS-101/102/103/104）+ R1-R3**——补齐 4 项关键漏洞
2. (b) **修 P1（R4-R7）**——文档层引用同步 + ISS-001/002 修订入提案 + 三形态 smoke + e2e-sync-check
3. (c) **拆 3 commit（R8）+ 排期（R9）**——再开 PR
4. (d) **若用户同意继续推进**：让另一个 AI 继续修复，然后做二次评估

**不建议**：
- ❌ 现状直接进 PR（必被 CI 拒 + 违反 ROOT-C-006 拍板）
- ❌ 推翻重来（git mv 278 文件已 staged，再撤成本高）
- ❌ 撤销 staged 重新设计（路径方向已对，缺的是补漏）

---

## 7. 关联文件

| 类型 | 路径 | 说明 |
|---|---|---|
| 评估对象提案 | `_governance/_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`（untracked） | 18.7KB / 149 行 |
| 评估对象工作区 | 分支 `feat/project-container-introduction` + HEAD `0803813` | 278 staged + 15 unstaged |
| 评估前报告 | chat 内"评估提案是否合理"输出（**未落盘**） | 12 合规 / 10 ISS / 7 RSK / 14 修复建议 |
| 本评估报告 | `docs/research/2026-08-21-workspace-project-container-execution-evaluation.md`（本文） | 本文件 |
| 相关研究材料 | `docs/research/2026-08-21-workspace-root-structure-eval-{gpt-5.6-terra,deepseek-v4-flash,glm5.3,minimax-m3}.md` | 第三方评估佐证（untracked） |
| 远程 issue 镜像 | `_governance/_proposals/_remote-issues/issue-{290,334,370,374}.md` | C1 triage 镜像 |

---

## 8. 复审建议

- 本报告落盘后**作为实施 PR 评审的输入**之一，与提案 §5 验证门槛、chat 内评估报告交叉核对；
- 二次评估（实施 PR 阶段）应重新跑 `bash scripts/check-template.sh`，目标 **0 失败**；
- 派生仓首提交目录树应手工核对（提案 §5.5 + R6 三形态 smoke 合并验证）；
- 本报告落地后建议同步登记到 `.ai/session-handoff.md` 的最新 checkpoint（按 `session-rules §3.2` 强制）；
- 本文为只读评估报告，**不替代**提案的修订与实施 PR 的合并判断。

---

## 9. 元数据

| 字段 | 值 |
|---|---|
| 报告版本 | v1（首次落盘） |
| 报告生成时间 | 2026-08-21 |
| 报告生成者 | claude（MiniMax-M3，会话内） |
| 输入数据版本 | HEAD `0803813`（v1.66.0），工作区 feat/project-container-introduction |
| 评估完整性 | 100%（覆盖 §0-6 全部维度 + §7 关联 + §8 复审建议） |
| 评估独立性 | 高（chat 内独立评估，未受提案作者影响） |
| 评估可重复性 | 高（输入确定则结论确定） |
| 报告性质 | 留痕 / 不替代 / 不阻塞 PR |
| 下次复审时机 | 实施 PR commit 后 / 二次评估时 |