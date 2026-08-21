# 综合评估：根目录重组（借鉴 miiot 工作空间）（glm5.3）

> **定位**：调研记录。本文是 5 份评估的交叉核实与综合判断，**新增**对前 4 份（gpt-5.6-terra / minimax-m3 自评 / minimax-m3 meta-eval / minimax-m3 fact-verification）与同日 deepseek-v4-flash 综合评估的事实补充与方法论修正；提出**方案 B'（模板单侧容器 + 派生侧 flatten）**作为对前 4 份"方案 B（双向嵌套）"的替代设计。
> **关联文件**：
> - [`2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md`](./2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md)
> - [`2026-08-21-workspace-root-structure-eval-minimax-m3.md`](./2026-08-21-workspace-root-structure-eval-minimax-m3.md)
> - [`2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md`](./2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md)
> - [`2026-08-21-workspace-root-structure-fact-verification-minimax-m3.md`](./2026-08-21-workspace-root-structure-fact-verification-minimax-m3.md)
> - [`2026-08-21-workspace-root-structure-eval-deepseek-v4-flash.md`](./2026-08-21-workspace-root-structure-eval-deepseek-v4-flash.md)
> 评估者：glm5.3（2026-08-21）。

---

## 一、5 份评估的可信度核实结论

| 评估 | 关键贡献 | 核实结果 | 主要问题 |
|---|---|---|---|
| **gpt-5.6-terra** | 首发提出 `project/` 单一复制入口、方案 A–D 对比 | 方向正确；自承只读了 ~30% | 未读 new-project.sh 实现，无影响审计 |
| **minimax-m3 自评** | 提炼 P1–P5 职责原则（"编号只是表象"）、11 项影响审计、ROOT-C-006 | 原则提炼成立；new-project.sh 机制描述确实错了（meta-eval 订正正确） | 根目录计数 24 错，实为 38；影响审计第一行就错 |
| **minimax-m3 meta-eval** | 交叉核对暴露前两份的事实错误 | 核对结论全部属实 | 自评同模型偏见已声明，可信度尚可 |
| **minimax-m3 fact-verification** | 4 项实测核对，收敛出 4 类来源文件 | 4 项核对本身准确（`git archive` 全量复制、`files_all` 仅 2 项含 docs/、docs-scaffold 结构、git-guide §5 禁止路径均属实） | **"影响面收敛到 4 类来源文件"是错的**——漏了最大的影响面（见下 §二.1） |
| **deepseek-v4-flash** | 综合四份 + 补 M1–M4（指出 miiot 简洁高度依赖多仓挂载） | 38 项计数属实；"单入口必须照搬、多仓挂载不能照搬"判断正确 | 沿用了 fact-verification 的影响面结论，继承了同一遗漏 |

**总评**：5 份全部收敛到方案 B（`project/` 容器）、全部否决编号化（方案 C）——大方向经核实认同。但它们**共享两个系统性盲区**，直接影响方案设计（见 §二）。

---

## 二、我补充核实的事实（5 份都没做或做错的）

### 1. `docs/` 路径引用面量化（fact-verification 完全遗漏的成本项）

本工作空间实测（grep `docs/(00|01|02|03|04|05|06|07|08|09|README|inputs|design|decisions|research|vision|archive|env|meetings|references)` 各处统计）：

| 位置 | docs/ 路径引用 | 文件数 |
|---|---|---|
| `ai/` 方法论（含 doc-standards、prompts） | **134 处** | 34 个文件 |
| `template-docs/` 手册 | **356 处** | 46 个文件 |
| `scripts/check-template.sh` 自检脚本 | **239 处** | 1 个文件 |
| `scripts/new-project.sh` 生成的派生项目 README 模板 | **31 处** | 1 个文件 |
| `_examples/` 参考样例 | **169 处** | 30 个文件 |
| **合计** | **929 处** | 112 个文件 |

> 注：原 glm5.3 报告本表的数据被截断未完整给出；上数由本工作空间 grep 实测填充，作为独立交叉来源。

"影响面收敛到 4 类来源文件"只统计了**机械改动点**（sync 清单、git-guide、scaffold、new-project.sh 脚本骨架），漏了这套模板用 **929 处路径引用** 把项目产物挂在 `docs/` 根上的隐式契约——这是当前布局的"使用成本"，方案 B/B' 都需要分摊。

### 2. 但这上千处引用大多不用改——关键甄别

929 处引用**绝大多数描述的是"派生项目侧的目录标准"**，不是模板仓自身路径。真正需要改的是**描述模板仓自身**的子集：

- `MAINTAINERS.md`、`README.md`（模板仓自描述）
- `git-guide.md §5`（同步 SOP 的禁止路径）
- `template-docs/maintainer/`（模板仓专用文档）
- `scripts/check-template.sh` 的"模拟派生仓内部"断言 fixture（**不动**，断言派生项目根的 `docs/`，与方案 B/B' 一致）
- `template-docs/docs-scaffold/README.md` 三层定位表

**甄别后真正需要改的是数十处**，不是 929 处。5 份评估都没做这个甄别，把"引用面"和"需改面"混为一谈。

### 3. 同步是 1:1 路径映射（5 份都没发现的机制约束）

实测：`scripts/sync-template.sh:901` 用：

```bash
git checkout "$REF" -- "$f"
```

把 `files_all` 里的模板路径**原样落到派生仓同路径**。若 `files_all` 里的 `docs/README.md` 改为 `project/docs/README.md`，派生仓会**长出 `project/docs/README.md`**，而不会自动回到根 `docs/README.md`。

**机制约束**：方案 B（minimax/deepseek/fact-verification 推的方案）必须给 sync 脚本加一条**"project/ 前缀剥离"** 规则（`sh` + `ps1` + 兜底数组三处）——这是 fact-verification §6 的 4 类来源清单**漏掉的最大改动点**。方案 B'（模板单侧 + 派生 flatten）通过 `new-project.sh` 在首提交前把 `project/*` 提升到根、删除容器，**天然规避**了这条机制约束。

### 4. 新发现：`new-project.sh` 治理记录泄漏

实测 `new-project.sh` 全文 417 行（fact-verification §2 已读）的裁剪清单：

```bash
rm -f "$TARGET/scripts/check-template.sh" "$TARGET/scripts/check-template.ps1" \
     "$TARGET/scripts/sync-all-derived.sh" "$TARGET/scripts/e2e-sync-check.sh" \
     "$TARGET/scripts/new-project.sh"   # 5 个 template-only 脚本

rm -f "$TARGET/template-docs/maintainer/e2e-regression-checklist.md" \
     "$TARGET/template-docs/maintainer/e2e-report-template.md" \
     "$TARGET/template-docs/maintainer/rd-data-chain.md" \
     "$TARGET/template-docs/maintainer/domain-derived-scenarios-template.md"  # 4 个 maintainer 文件

rm -rf "$TARGET/_proposals"  # 重写 README
# (--no-examples 时) rm -rf "$TARGET/_archive" "$TARGET/_examples"
# (--shape docs 时) rm -rf frontend backend tests docker + docs/06 + docs/07
# (--shape cli 时)  rm -rf frontend docker
```

`git archive HEAD` **全量复制后**，裁剪清单**不涵盖**：

- `ai-records/`（含 `project-registry/registry.md`、`pitfalls/SUMMARY.md`、`e2e-reports/`、`token-hotspots/` 汇总）
- `sync-records/template-sync/`
- `docs/research/`（含 4 份 C1 triage + 4 份 workspace-root-structure + 1 份 glm5.3 = 9 份现成调研）

这些会被**原样带进每个新派生项目**。新项目开局就拿到模板维护坑汇总与 registry，这是 5 份评估都没发现的存量问题——也正好被方案 B/B' **顺带修复**（统一归 `ai-records/research/`，并加进 `new-project.sh` 裁剪清单）。

### 5. 杂项核实

- `check-run*.log` 三个文件：纯本地临时日志（`git ls-files` 已确认未跟踪），处置=直接删除，无需归档。
- `.history/`：已 `.gitignore`，不会被 `git archive` 带走，无需处理。
- 模板仓 `docs/00-09` 本体是【撰写提要】骨架占位（已读 `template-docs/docs-scaffold/00-scenario.md` 验证：含 `【撰写提要：...】` 标记），非模板自己的项目事实；迁移语义上是"骨架种子"，应随 `project/` 容器一并迁入。

---

## 三、核心判断：miiot 清爽的真正机制，与本仓的结构性矛盾

5 份评估都正确指出了 M3（多仓挂载）不能照搬，但漏了更根本的一点：

- **miiot 根目录 = 工作空间层**（治理 + 各领域入口）；**`flowkit/` = 项目层**。它的根目录之所以干净，是因为把"工作空间"与"项目"分到了两层。
- **本仓把两个角色混在同一层**：既是模板方法论仓（`ai/` / `template-docs/` / `scripts/` / 治理记录），又是项目骨架实例（`docs/` / `frontend/` / ...）。用户感到的"不适"正来源于此——38 个条目里**双重身份纠缠**。

由此产生 5 份评估全部默认、但从未明确的设计选择：

- **B-全量**（它们实际设计的）：`project/` 成为模板和所有派生项目的**新标准** → 要重写派生 README 模板 30+ 处、更新派生路径预期、6 个存量派生仓各做一次目录迁移。deepseek-v4-flash 明确写了"`new-project.sh` 生成 README 30+ 处改 `project/docs/...`"，minimax-m3 fact-verification §2.4 也列出 30+ 处改造量。
- **B-模板单侧**（glm5.3 建议）：容器只是模板仓作为工作空间的**视角修正**——派生项目本来就不是工作空间，它整个仓库就是一个项目，给它套 `project/` 层是无意义的额外嵌套。

**派生侧根本不需要救**：`new-project.sh` 在派生时执行 flatten（`project/*` 提升到根、删容器，约 15 行 shell），派生项目拿到的仍是现在的平铺标准布局——`--shape` 裁剪、生成的 README、`_examples`、check 脚本里所有"模拟派生仓"的断言全部不用动。5 份评估设计的派生侧改造（30+ 处 README 重写、6 仓迁移）**全部省掉**。

---

## 四、我的建议：方案 B'（模板单侧容器）

```text
ai-project-template/                # ← 工作空间层（治理 + 方法论）
├─ project/                         # ★ 项目骨架层：未来只需代码时拷这一个目录
│  ├─ docs/                         # ← 现 docs/ 迁入（00-09 + decisions/design/inputs/research/vision/...）
│  ├─ frontend/  backend/  tests/  docker/  tasks/   # 现 4+1 个代码目录原样迁入（不套 src/）
│  └─ README.md
├─ ai/  template-docs/  scripts/    # 方法论（不动）
├─ ai-records/  sync-records/  _proposals/  _archive/  .ai/   # 治理（不动；模板自身 research 也归这里）
├─ template-sync.json  VERSION  CHANGELOG*  README  AGENTS/CLAUDE/INIT-PROMPT
└─ MAINTAINERS  CONTRIBUTING  SOP  git-guide
```

### 改动点（比 5 份评估的 B 少一半以上）

1. **迁移本身**：`docs/`、`frontend/`、`backend/`、`tests/`、`docker/`、`tasks/` 进 `project/` 下（git mv，一次提交）；模板自身 research/archive 材料搬 `ai-records/`（顺带解决 minimax-m3 的 ROOT-C-006，且 `docs/archive/e2e/` 本就该并入已存在的 `ai-records/e2e-reports/`）。
2. **`new-project.sh`**：加 flatten 步骤（约 15 行）+ 治理泄漏修复（裁剪清单补 `ai-records/` / `sync-records/` 内容 + 模板自身 research）。**不套 `src/`**——少一层嵌套，flatten 更简单。
3. **`sync-template.sh` / `.ps1`**：**不需**加 `project/` 前缀剥离规则——因为方案 B' 派生侧保持平铺，files_all 仍写 `docs/README.md`、`docs/inputs/README.md` 等原路径。**这是 B' 相对 B 的最大减负**。
4. **`check-template.*`**：逐条甄别 169+ 处引用——模拟派生布局的 fixture 不动，断言模板自身路径的改为 `project/...`（量级数十处，不上百）。
5. **手册更新**：`README.md` 目录速览、`MAINTAINERS.md`（登记"模板仓布局=工作空间视角，派生=平铺标准"的双层语义 + `new-project` flatten 行为）、`git-guide` §5（同步禁止路径不变；补充"`project/` 是模板仓内层、派生仓无此层"说明）、`docs-scaffold/README.md` 三层定位表改"`project/docs/`"指向。
6. **`template-sync.json`**：**不改 files_all 路径**（派生仓仍要 `docs/README.md`、`docs/inputs/README.md` 原路径）；`description` 字段中"`docs/`"字面引用改为"`project/docs/`"（与 B 一致）。

### 顺带的免费收益

- 根目录 38 → 33 项左右（去掉 6 个项目骨架目录的根级暴露，加 1 个 `project/` 容器）。
- **更重要的**：拷贝边界有了**物理体现**——与 miiot 的 M4（单一代码入口）等价，且**不需要它的 M3 多仓挂载**。
- 修复 `new-project.sh` 治理记录泄漏（5 份评估都没发现的存量 bug）。

### 可后补的可选项（不阻塞）

在 `template-docs` 登记一个"**代码聚合入口**"可选模式（如 `app/` 容纳 `frontend`/`backend`），让有同样"拷代码"需求的**派生仓**（真实代码在那里）自行选用并登记 `project-rules §4` 特例——不强制 6 仓迁移。

---

## 五、落地路径（若用户认可方向）

1. **本会话 / 下会话**：起草 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`（模板维护流程要求），引用 5 份 research + 本评估，附决策表（§六）。
2. **拍板决策项 → 分支实施一个 PR（MINOR，建议 v1.67.0）**：迁移 + 脚本改造 + 预检全绿（`check-template.sh` + `check-template.ps1` + `check-markdown-clean.ps1`）+ `e2e-sync-check.sh`（MINOR 必跑）。
3. **排期选择**（见 §六 Q3）：
   - **稳妥路径**：v1.66.0 六仓同步窗口先走、v1.67.0 下窗口携带方案 B/B'；
   - **激进路径**：方案 B' 先落地、一次窗口带两版（省一个窗口，但当前窗口需延后）。
4. **5 份 research 文件目前未跟踪**（包括本评估，共 6 份）：建议保留在 `docs/research/`，B/B' 落地时随迁 `ai-records/research/`（顺带解决 ROOT-C-006）。

---

## 六、待你拍板的决策项

| ID | 决策项 | AI 建议 | 依据 |
|---|---|---|---|
| **Q1** | 方案选择：B'（模板单侧 + 派生 flatten）vs B（minimax/deepseek 推的双向嵌套，派生也改） | **B'** | 派生仓不需要嵌套层；省 30+ 处 README 重写 + 6 仓迁移 + `sync-template` 前缀剥离规则；方法论正文基本不动 |
| **Q2** | 容器命名与结构 | `project/`，不套 `src/`，代码目录原名迁入 | 少一层嵌套，flatten 一步到位 |
| **Q3** | 排期：先做已计划的 v1.66.0 六仓同步窗口 vs B' 抢先落地一次窗口带两版 | **先走 v1.66.0 窗口（不阻塞存量改进），B' 作 v1.67.0 下窗口携带** | B' 还需提案+实施，赶不上当前窗口；两次常规窗口成本低于阻塞风险 |
| **Q4** | 模板自身 `research` / `decisions` / `meetings` 等"治理材料"放哪 | **搬 `ai-records/`**（支持 minimax ROOT-C-006） | 属模板治理材料而非项目骨架；`e2e-reports/` 已存在此模式 |
| **Q5** | `new-project.sh` 治理泄漏修复粒度：整目录裁剪 vs 保留 README 种子 | **裁内容、按需保留分区 README 种子** | 新派生仓需要空的治理区框架（三目录 README 即可），不要带内容记录 |
| **Q6** | `check-run*.log` 3 个本地垃圾文件处置 | **直接删除**（已 `git ls-files` 确认未跟踪，无历史包袱） | 已被 `.gitignore` 保护或从未入库 |
| **Q7** | 派生仓可选代码聚合模式是否本提案一起做 | **后补，不阻塞** | 先让模板侧落地验证，避免一次改太多 |

---

**一句话总结**：5 份评估大方向（方案 B、否决编号化）经核实成立，但它们共享两个盲区——低估了 `docs/` 引用面（实测 929 处，甄别后真正需改的数十处）、又都多余地把容器推广到派生仓。**方案 B' 只解决模板仓"工作空间 vs 项目"的双重身份问题**（这正是 miiot 清爽的本质），派生仓用 flatten 保持平铺标准。改动收敛为一个 MINOR PR + 顺带修复一个 5 份评估都没发现的 `new-project.sh` 治理记录泄漏。**Q1–Q7 拍板后**，按模板维护流程起提案。

---

## 七. 方法论与未核实事项声明

本评估由 glm5.3 撰写，落盘时由 minimax-m3 做了**只读交叉核对**。事实补正如下：

| 声明 | 验证方式 | 结果 |
|---|---|---|
| 5 份评估文件存在于本工作空间 `docs/research/` | `ls -la docs/research` | ✅ 全部存在；本文落盘后共 6 份未跟踪 |
| `scripts/sync-template.sh:901 git checkout "$REF" -- "$f"` | `grep -n` 实测 | ✅ 命中第 901 行，引用机制属实 |
| `docs/` 路径引用面量化（原表被截断） | 5 处分别 `grep` | ✅ 填充实测数：ai/ 134 处 / template-docs/ 356 处 / scripts/check-template.sh 239 处 / scripts/new-project.sh 31 处 / _examples/ 169 处 = **929 处** |
| `new-project.sh` 治理记录泄漏（不裁剪 ai-records/、sync-records/、docs/research/） | 实读 `new-project.sh` 全文 417 行 | ✅ 属实：裁剪清单仅覆盖 `_proposals`（重写）、`scripts/check-template.*`、`template-docs/maintainer/*`、`--no-examples` 删 `_archive`+`_examples`、`--shape` 删代码目录 |
| `docs/00-09` 本体是【撰写提要】骨架占位 | 实读 `template-docs/docs-scaffold/00-scenario.md` | ✅ 属实：含 `【撰写提要：...】` 标记 |
| 方案 B' 与方案 B 的设计差异（flatten vs 嵌套） | 设计判断，需用户拍板 | ⚠️ **未独立验证**——属方案选择而非事实问题，应由用户拍板 Q1 |

**未做但建议补做**（与 minimax-m3 fact-verification §9 一致）：

- 临时分支模拟方案 B' 落地后跑 `bash scripts/check-template.sh` + `powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1` 全绿实测；
- `git archive HEAD` 后 `tar -t` 列出"未被 `new-project.sh` 裁剪的模板仓目录"完整清单，确认治理泄漏的具体范围；
- 6 仓派生项目（LUMEN / agent-system / zhiyan / digital-cs / web-ui-kb / LumiOne-gmbl）同步窗口与方案 B' 实施窗口的耦合关系评估。

---

**维护提示**：本文为调研记录，按 `docs/README.md` §5 归 `docs/research/`。方案 B' 的设计选择（§四 + §六 Q1）属**用户决策**而非事实陈述；落盘不构成模板迁移决策。提案起草应基于本评估 + fact-verification 双源对照，避免单一模型偏见。