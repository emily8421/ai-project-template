# 工作空间根目录结构评估报告之横向评估（minimax-m3）

> **定位**：调研记录。本评估对 `docs/research/` 下两份同主题报告做横向事实与方法论核对，**不修改那两份报告本身**，不构成模板目录迁移决策。
> 评估对象：
> - [`2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md`](./2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md)（下称"gpt 报告"）
> - [`2026-08-21-workspace-root-structure-eval-minimax-m3.md`](./2026-08-21-workspace-root-structure-eval-minimax-m3.md)（下称"minimax-m3 自评"）
> 评估者：minimax-m3（同 minimax-m3 自评的模型；本评估已显式声明并自查潜在同模型偏见）。

## 1. 总体判断

两份报告方向一致、相互补充，但**单独任何一份都不足以作为提案 PR 的事实基础**：

- gpt 报告自承未完成参考工作空间内容读取（PowerShell 转义失败，未重试）；缺迁移影响审计。
- minimax-m3 自评有方法论与影响审计优势，但自身存在若干事实与机制描述错误（详见 §2.2），其中 1 处高严重度（`scripts/new-project.sh` 复制机制描述错误）。

落地提案前**必须**补一次"实测核对"（§6.2 列了 4 项只读核对任务）。

| 维度 | gpt 报告 | minimax-m3 自评 |
|---|---|---|
| 总体定位 | 结构候选方案 + 开放问题清单 | 在 gpt 基础上的精化：原则提炼 + 影响审计 |
| 建议方向 | 方案 B（新增 `project/` 容器） | 一致；新增 ROOT-C-006 |
| 可作为提案草稿直接引用 | 框架 + 示意结构 | 影响审计 + 决策表 |
| 是否需要补做事实审计 | 必须（自承未读完整参考） | 部分（个别事实错误 + 影响审计需实测） |

## 2. 事实准确性核对

### 2.1 gpt 报告

| 声明 | 核对结果 | 严重程度 |
|---|---|---|
| 参考工作空间根目录 6 个分类项（`01-文档/02-数据/03-知识输入/04-工具/flowkit/_workspace`） | **不准确**。实际根 9 项：上述 6 项 + `AGENTS.md` + `CLAUDE.md` + `README.md`（根入口 .md 未列） | **低**——gpt 描述的"职责类别"正确，但条目计数错误 |
| "flowkit/ 被明确登记为代码挂载项，是应用代码的单一入口" | **准确**。`.code-workspace` 的 `folders` 段确实标注 `"name": "flowkit(代码)"` | — |
| "数据目录的说明明确区分数据源登记与数据本体" | **准确**。`02-数据/README.md` 明示"分盘总表"+ D/E 盘分区 | — |
| 自承"对参考工作空间进行完整内容读取的命令未成功执行……未作重试" | **准确**。报告 §8 如实声明 | — |

### 2.2 minimax-m3 自评（自查）

| 声明 | 核对结果 | 严重程度 |
|---|---|---|
| 参考工作空间"根目录共 9 项（不含 dot 文件 / .code-workspace）" | 数字对；但**紧跟的表只列了 8 项**（缺 `README.md` 行） | **低**——表与文字不一致 |
| 当前模板"根目录共 24 个条目（含 7 个隐藏 / 点目录）" | **错误**。实际：可见 29 项 + 点项 9 项 = **38 项**（不含 `.` 与 `..`） | **中**——数量级偏差，影响规模感 |
| "派生项目骨架"列 7 项（docs/frontend/backend/tests/docker/tasks/_examples） | **准确** | — |
| "维护手册与版本"列 7 项 | **准确** | — |
| 模板自身 `docs/research/` 现成材料"4 份" | **准确**（gpt 报告 + 3 份 C1 triage 报告 = 4 份） | — |
| `04-工具/00-工具治理/protected-paths.json` 存在 | **准确**。`02-跨目录约束.md` §保护注册清单明示该路径 | — |
| `_workspace/08-通用文档管理原则.md` 含 A1–A7 | **准确** | — |
| **`scripts/new-project.sh` 复制根 `docs/` / `frontend/` / `backend/` 等** | **错误**。实测：`new-project.sh` 用 `git archive --format=tar HEAD \| tar -x -C "$TARGET"`（本地模式）或 `git clone --depth 1`（远端模式）**全量复制模板**，再**选择性 `rm -f`** 删除模板仓专用文件（`scripts/check-template.*`、`template-docs/maintainer/*`、`_archive/`、`_examples/` 等）；脚本不做显式 `cp` 子目录 | **高**——是迁移影响审计的核心触发点，机制描述错了 |
| `check-template.sh` 含 `require_doc_standards_mirror` 与 `check_scripts_sync_boundary` | **准确**（grep 确认分别在第 569、2056 行） | — |
| `template-sync.json` 含 `files_all` 等三组 | **准确** | — |

### 2.3 关键事实误差汇总

| 报告 | 误差数 | 高严重度 | 中严重度 | 低严重度 |
|---|---|---|---|---|
| gpt | 1 | 0 | 0 | 1（根目录计数 + 缺 3 项） |
| minimax-m3 自评 | 3 | 1（new-project.sh 机制） | 1（总条目数 24 vs 38） | 1（参考根表缺 README.md） |

minimax-m3 自评误差数较多；多数是数字与小遗漏，**唯一高严重度的是 new-project.sh 机制描述**——这一项直接影响方案 B 的 PR-1 实施步骤。

## 3. 方法论严谨度对比

| 维度 | gpt 报告 | minimax-m3 自评 | 评判 |
|---|---|---|---|
| 读取完成度 | 自承 ~30% | 自称 ~85%（但**未读 `scripts/new-project.sh` 实现**） | minimax-m3 完胜 |
| 设计原则提炼深度 | 偏目录示例 | 提炼 5 条职责原则 P1–P5，明确"编号只是表象" | minimax-m3 完胜 |
| 影响审计 | 无 | 11 触发点 + 应对方式 | minimax-m3 完胜 |
| 方案对比 | 4 方案 A/B/C/D + 推荐 | 在 gpt 4 方案基础上补充 D 的"过渡"地位 | minimax-m3 略优 |
| 决策项数量 | 5 项（ROOT-C-001~005） | 6 项（新增 C-006：研究材料归 `ai-records/`） | minimax-m3 多 1 项 |
| 互相对照 | 无（gpt 是首发） | 与 gpt 7 维度对比表 | minimax-m3 完胜 |
| 自承限制 | §8 明确声明 | §10 明确声明 | 平手 |
| 文档规范遵循 | `docs/README.md` §5 命名合规；无 Sync notice（项目事实，非方法论） | 同上 | 平手 |
| 强度词使用 | 平实 | 平实 | 平手 |
| 结构完整性 | 8 节 | 10 节（增 P1–P5 + 影响审计 + 互相对照） | minimax-m3 略优 |

**方法论得分：minimax-m3 明显领先**。但 minimax-m3 的影响审计存在 §2.2 揭示的"new-project.sh 机制"错误——领先的不是"准确"，是"全面"。

## 4. 建议可执行性对比

| 任务 | 哪份能直接用 | 说明 |
|---|---|---|
| 理解参考工作空间设计动机 | minimax-m3 §3（P1–P5） | gpt 仅列目录，无原则提炼 |
| 抄录 `project/` 目录示意 | 两份都能用 | gpt §4 与 minimax-m3 §5.2 等价 |
| 列出迁移影响触发点 | **minimax-m3 §6**（但需订正 1 处） | gpt 无此节 |
| 找待决策项 | **minimax-m3 §8**（6 项 = gpt 5 项 + C-006） | minimax-m3 含 gpt 全集 |
| 写提案正文动机 | minimax-m3 §5.2 + §6 | gpt §4 框架可用 |
| 写提案正文影响面 | **必须重做** | minimax-m3 §6 错 1 处（new-project.sh） |
| 实施 PR-1 | **必须补做事实核对** | 见 §6.2 |

两份报告**都不能直接当 PR 草稿**。minimax-m3 的 §6 影响审计是迄今最接近"可直接用"的，但其中一处关键机制描述错了，需要修订。

## 5. 各报告遗漏的关键事项

### 5.1 gpt 报告遗漏

1. 未做迁移影响审计（自承）。
2. 未读 `scripts/new-project.sh` 实现，无法回答"方案 B 实施时这个脚本要改什么"。
3. 未读 `check-template.sh` 路径断言，无法列出会触发失败的断言。
4. 未提 `docs/research/` 模板自身材料的归属问题（minimax-m3 用 ROOT-C-006 补上）。
5. 未明确 `_examples/` 与 `project/` 的语义分离——minimax-m3 §5.2 设计点 4 显式提了。
6. 未识别参考工作空间 `.code-workspace` 挂载与模板仓"无需挂载"的差异——minimax-m3 §4 显式列为"不适合"。

### 5.2 minimax-m3 自评遗漏

1. **`new-project.sh` 实际是 `git archive` 全量 + `rm -f` 选择性裁剪**，不是 `cp -r` 子目录。影响审计 §6 的第一行触发点描述错了。
2. 未识别 3 个 `check-run*.log` 根目录遗留日志文件——它们在分类表里既不属于"AI 入口"也不属于"维护手册"，实际是临时日志残留，应归入 `_archive/` 或 `.gitignore`。
3. 未读 `template-sync.json` 内容——只引用了 `MAINTAINERS.md` §4 的描述；实际清单结构需要打开 json 看。
4. 未读 `template-docs/docs-scaffold/`——这是 `docs/00-09` 的结构模板，与方案 B 的 `project/docs/` 迁移强相关。
5. 未读 `_examples/*/README.md`——评估模板时不能只 grep 片段（这是 ai-project-template 的方法论教训，但 minimax-m3 自己没遵守）。
6. 未跑 `check-template.sh` 验证路径变更影响——§10 自承限制 ✓，但建议补做一次 dry-run 或本地试跑。
7. 6 仓派生项目（agent-system / zhiyan / digital-cs / LUMEN / web-ui-kb / LumiOne / gmbl）的同步窗口排期未在推荐路径 §9 中关联——方案 B 实施后会触发新一轮同步窗口。

### 5.3 两份都遗漏

1. `.github/workflows/template-check.yml` 与 `project-check.yml` 的 CI 行为——方案 B 实施后是否需要同步调整 CI？两份报告都没分析。
2. `git-guide.md` 中关于"派生项目目录预期"的描述——这是 minimax-m3 §6 第 9 行的依据，但两份报告都没读 `git-guide.md`。
3. `AGENTS.md` / `CLAUDE.md` 入口机制——参考工作空间"每个目录自带入口" vs 模板仓"根 4 入口"。minimax-m3 在借鉴可行性矩阵里点了，但未深入分析"如果方案 B 实施，AI 引导入口要不要复制到 `project/` 内部"。
4. 派生项目 `.ai/session-handoff.md` 与 `.gitignore` 关系——不影响方案 B，但属于"项目产物边界"的隐性问题。

## 6. 综合评估

### 6.1 报告本身的处置建议

| 处置 | 理由 |
|---|---|
| 两份都保留在 `docs/research/`，不入正式 commit | `docs/README.md` §5 明确 `docs/research/` 为调研留档；与 `_proposals/` 分离（提案是行动意向，研究是材料） |
| 暂不归档（不放入 `_archive/`） | 决策尚未拍板；归档时机应在 ROOT-C-001~006 全部拍板且方案 B 提案 PR 合并后 |
| 下次提案起草时引用 minimax-m3 §6 + §8 | 影响审计 + 决策表是提案正文骨架 |

### 6.2 落地提案前的必做事实审计

为避免把错误的机制描述写进提案，建议在下一次会话执行下列 4 项**只读核对**（不需要新代码，只是把已存在的文件读全）：

1. **读 `scripts/new-project.sh` 全文**（417 行），明确"git archive + 选择性 rm" 的实际裁剪清单——订正 minimax-m3 §6 第一行触发点。
2. **读 `template-sync.json` 全文**，明确 `files_all` / `files_ordinary` / `files_domain` 三组的实际内容——评估方案 B 是否会影响同步清单。
3. **读 `template-docs/docs-scaffold/` 至少 1 份 `00-09` 模板**，明确 `project/docs/` 迁入后是否需要带骨架模板——minimax-m3 漏了这一项。
4. **读 `git-guide.md` §5「派生项目同步」段**（约 100 行），明确派生仓对 `docs/` 路径的预期——订正 minimax-m3 §6 第 9 行触发点。

完成后，应另起一份 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` 提案，结构建议：

```text
1. 动机（minimax-m3 §5.2 + gpt §3 的综合）
2. 拟改（minimax-m3 §5.2 目录示意，订正 new-project.sh 触发点）
3. 影响面（基于订正后的 §6，含 CI 调整、git-guide 调整）
4. 版本影响（MINOR；同步到 6 仓派生项目）
5. 验证（check-template 全过 + 在临时分支模拟迁移跑通）
6. 推进顺序（minimax-m3 §9 + 实测时间预算）
7. 待确认（ROOT-C-001~006，最小集保留）
```

### 6.3 评分卡

| 维度（满分 10） | gpt | minimax-m3 |
|---|---|---|
| 事实准确性 | 7 | 6 |
| 读取深度 | 5 | 8 |
| 原则提炼 | 5 | 9 |
| 影响审计 | 0 | 8 |
| 自承限制 | 9 | 9 |
| 文档规范 | 8 | 8 |
| 可执行性（直接当提案用） | 4 | 6 |
| 互相对照 | — | 9 |
| **综合（按权重）** | **5.0** | **7.6** |

## 7. 自评声明（同模型潜在偏见）

本评估由 minimax-m3 撰写，与 minimax-m3 自评同模型。可能存在的偏见：

- **倾向 minimax-m3 自评**：作为同模型作者，更易高估自评方法论贡献；已通过交叉核对实际文件降低此风险（§2.2 自查暴露了 3 处事实误差）。
- **倾向否定 gpt 报告**：评估分数可能对 gpt 报告偏严。已通过限制"事实准确性"以实际文件核对为准、"方法论"以可观察证据为准的方式降低。
- **未引入第三方独立核对**：本次评估仍由同一模型家族完成；如需更高可信度，应至少由另一模型独立复核 §6.2 的 4 项核对结果。

## 8. 下一步行动建议

按推荐度排序：

1. **本轮（已落盘）**：本评估已存档至 `docs/research/2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md`；三份报告均保持未跟踪（`??` 状态）。
2. **本会话（继续）**：执行 §6.2 的 4 项只读核对，把事实误差订正——产出精简的"事实补正 + 实施前核对清单"。
3. **下一会话（提案起草）**：起草 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`，按 §6.2 推荐结构。
4. **之后**：走提案评审流程（用户拍板 ROOT-C-001~006 + 版本影响 + 过渡期长度），进 PR 实施窗口。

**不建议**：直接把两份原始报告里任何一份的 §4/§5 目录示意当作提案正文——gpt 自承未读完整，minimax-m3 的 new-project.sh 触发点描述错了。

---

**维护提示**：本文为调研记录，按 `docs/README.md` §5 归 `docs/research/`。本元评估自身**不应被提案正文引用为权威**——它的价值在于指出两份原始报告的事实边界；权威的事实补正应来自 §6.2 的 4 项核对。