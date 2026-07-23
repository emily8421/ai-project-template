# TEMPLATE-UPGRADE: check-template 诊断与脚本维护性优化

> 来源：模板维护者（token-hotspot records：capability batches、derived version stage A/B、sync proxy debug、domain sync closure）
> 状态：**P1 已落地（v1.56.2, #244）**；P2.3 Windows fallback checklist 已落地（v1.56.7）；**P2.4 摘要 / quiet + early-exit 已落地（v1.56.8）**；P2.1 / P2.2 候选 / 待评估
> 目标版本：P1 = v1.56.2（已发布）；P2.3 = v1.56.7；P2.4 = v1.56.8；P2.1 / P2.2 待确认
> Release impact：P1 = patch（v1.56.2，已落地）；P2.3 = patch（v1.56.7）；P2.4 quiet / early-exit = patch（v1.56.8）；P2.1 结构拆分 / P2.2 双语言对照可能为 minor
> Release strategy：P1 小修诊断与注释（✅ v1.56.2）；P2.3 Windows fallback smoke checklist（✅ v1.56.7）；P2.4 摘要 / quiet + early-exit（✅ v1.56.8）；P2.1 / P2.2 继续观察

## 1. 背景

`scripts/check-template.sh` 是模板发布前的权威自检，但记录中反复出现三类成本：成功日志很长、失败时需要人工 grep 大日志定位断言、维护者新增断言时容易混淆 `grep -Eq` 的 ERE 语法。与此同时，模板长期维护仍有 Bash / PowerShell 双实现：`sync-template.*`、`check-derived-sync.*`、`check-template.*` 等需要对称修改和专项验证。

H-003 已解决“成功长日志不要回灌上下文”的问题，但没有解决“失败时诊断不够直接”和“新增断言 / 双脚本维护容易漂移”的问题。H-005 已在 token-hotspot proposal 中升为正式评估，本提案将可执行的小修和后续评估范围拆清楚。

## 2. 目标

1. 让 `check-template` 失败时更快定位：输出断言名、目标文件、期望模式、最小实际上下文。
2. 给 `require_contains` / `Require-Contains` 增加 pattern 风格提示，避免 ERE / BRE 误用。
3. 评估 `check-template.sh` 是否需要按主题拆分断言区，降低 1600+ 行脚本定位成本。
4. 评估 `.sh`↔`.ps1` 双语言对称对照的轻量机制，减少手工漏改。

## 3. 非目标

- 不取消 Bash `check-template.sh` 的权威地位。
- 不恢复 PowerShell fallback 的大规模镜像断言；既有 fallback 收窄策略不回退。
- 不为了省 token 跳过发布前自检或 CI。
- 不把所有脚本重写成单一语言。

## 4. P1 小修候选

| 文件 | 改动 |
|---|---|
| `scripts/check-template.sh` | 在 `require_contains` 附近加注释：该函数使用 `grep -Eq`，pattern 是 ERE；regex OR 用 `|`，匹配字面 `|` 才转义。 |
| `scripts/check-template.sh` | 失败输出补充断言 label / 文件 / pattern；必要时输出 `grep -n` 的最小上下文或提示复现命令。 |
| `scripts/check-template.ps1` | 若保留 `Require-Contains`，加同等 pattern / regex 说明；不扩大 fallback 断言范围。 |
| `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md` | 将 H-005 的评估入口指向本提案，避免重复候选分散。 |

## 5. P2 评估候选

### 5.1 check-template 断言分区

按主题拆分或逻辑分段：入口文件、文档骨架、版本治理、同步脚本、派生同步、PR / CI 模板。目标是让维护者通过主题定位断言，而不是在单个超长脚本里滚动。

可选方案：

1. 保持单文件，仅增加主题目录和稳定 anchor 注释。
2. 拆出 sourced 子文件，例如 `scripts/checks/*.sh`。
3. 生成断言索引，但不改变执行入口。

### 5.2 双语言对称对照

对 `sync-template.*`、`check-derived-sync.*`、`check-template.*` 维护一个轻量对照清单，检查关键能力是否两端都有对应实现 / 提示 / 参数。它不是逐行 diff，也不要求 PowerShell fallback 完全等价；目标是发现“Bash 改了、PowerShell 忘了”的高风险缺口。

可选方案：

1. 在 `check-template.sh` 中增加关键字符串对照断言。
2. 新增维护者 prompt checklist，不新增脚本。
3. 新增轻量脚本扫描双端参数和提示关键词。

### 5.3 Windows 本地可用性 / fallback smoke checklist（已落地 v1.56.7）

本项承接 `_proposals/TEMPLATE-UPGRADE-ai-coding-context-budget.md` 的 C-002。P1 已解决失败诊断主问题，但 Windows 本地失败时仍需要一条最短判断链，避免把 Git Bash / PowerShell fallback 环境问题误判为模板缺陷。

候选 checklist：

1. `check-template.ps1` 进入 fallback 时，输出必须明确 fallback 原因、fallback 覆盖范围和下一步。
2. fallback 通过只代表结构检查通过，不代表模板完整自检通过；发布仍以 `bash scripts/check-template.sh` 或 CI 为准。
3. Windows 本地维护优先执行 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`；若进入 fallback，再根据 Bash 启动错误决定修 Git Bash / PATH / 权限，或改跑 Git Bash 全路径。
4. 成功路径只保留摘要：`check-template` 通过时，在回复、handoff 或 hotspot 记录中只记录命令、退出码 / check 结论和通过摘要，不粘贴完整成功日志。
5. 失败路径只保留最小证据：失败断言块、文件、expected pattern、复现命令和必要的 Bash / fallback 错误。

落地范围：

1. `MAINTAINERS.md` / `SOP.md` 增加极短 checklist，不新增脚本。
2. `scripts/check-template.sh` 增加防漂移断言，锁定 checklist 关键词。
3. 不改 `check-template` 默认输出模式；成功日志摘要仍由 `ai/session-rules.md` 约束 AI 回复 / handoff / hotspot 记录。

#### 5.3.1 Windows 本地自检结论（2026-07-23）

- 本地完整 Bash 自检已在干净 Git Bash 入口（非 WSL、非 codex / PowerShell 派生）闭环通过：`bash scripts/check-template.sh` 退出码 0，1824 项全过、0 失败。
- 此前 codex / PowerShell 下反复失败与约 123s 超时，根因是「本机 PATH 污染（疑 Path / PATH 重复）+ codex 约 120s 命令墙 + 完整自检本身耗时」，非本轮 P2.3 内容断言失败。
- 完整自检在 Windows 上约需 5 分钟（1800+ 断言的 Cygwin 子进程派生开销累积）；本地复跑请开原生 Git Bash 窗口、超时给 400s 以上。发布仍以 CI 为权威。
- 详细排障（PATH 重复、WSL stub、空格 quoting）不入本提案；若再触发，再评估补进 `template-docs/smoke-test.md` 或 `SOP.md`。

### 5.4 check-template 成功输出摘要 / quiet 模式（已落地 v1.56.8）

> 本项重新评估并覆盖 v1.56.7 P2.3 的非目标「不新增 quiet / summary 参数」。触发依据：实测完整自检成功日志约 1800+ 行（≈1.5–2 万 token），AI 回灌会显著放大 token 成本；token 风险来自"日志回灌"而非检查本身。两条独立分析（本机实测 + 维护者核对）收敛于此结论。

现状：完整自检约 1800+ 项（其中约 740 项由 `template-sync.json` / `ai/index.md` / `_examples` 清单循环自动生成，约 960 项为手写 `require_contains`），作为发布门禁合理；但不适合作为 AI 每轮交互的默认输出，尤其在 Windows 本地（成功日志长 + 本机约 5 分钟）。

边界（不做什么）：不减少检查项；不削弱 CI / 发布门禁覆盖；不改默认退出码语义。

候选做法：

1. 新增 `--summary` / `--quiet`（opt-in）：成功只输出分组计数与总结果；失败沿用 P1 最小证据格式。
2. early-exit 守卫：`ROOT` 计算或首批核心结构检查失败时立即退出并报"环境 / ROOT 问题，非内容"，封堵一次环境故障引爆上千条假 `✗` 的 token 炸弹。
3. 全量成功日志写本地 log，默认不进回复 / handoff。

验证分层（明确）：`check-template.ps1` fallback = 结构兜底；`check-template.sh --summary` = 本地快速完整自检；CI 全量 `check-template.sh` = 发布权威。

验收：成功路径只记命令、退出码、总通过 / 失败数；失败路径保留最小可定位证据；环境类失败早退，不产生批量假断言。

后续：P2.1 断言分区仍单列评估；`--summary` 的"分组计数"输出为分区预留接口，两者后续自然衔接。

## 6. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 失败输出过长 | 中 | 只输出断言名、文件、pattern 和最小上下文；完整日志仍本地保存 |
| 断言分拆增加维护复杂度 | 中 | P2 先评估；P1 仅加注释和诊断 |
| 对称检查误报 | 中 | 只检查关键能力 / 参数 / 提示，不做逐行一致性 |
| fallback 覆盖被误解为等价 | 中 | 文档明确 `.ps1` 是结构性兜底，不等于 Bash 权威自检 |
| Windows 本地问题被误判为模板缺陷 | 中 | P2.3 先补最短判断链；fallback 仍保持结构性兜底，不扩大为完整自检 |

## 7. 验收标准

- 新增断言时能从函数注释判断 ERE pattern 写法。
- `check-template` 失败时无需先翻完整长日志即可知道失败断言、文件和期望模式。
- 若进入 P2，必须先给出分拆方案与回滚方式，不直接大改脚本结构。
- 双语言对称评估不扩大普通任务上下文读取范围。
- Windows fallback 场景能通过 checklist 快速判断是环境入口问题、fallback 结构检查结果，还是需要看 Bash / CI 完整自检。（P2.3 已落地 v1.56.7）
- `check-template` 成功路径的会话记录只保留命令、退出码 / check 结论和通过摘要，不回灌完整成功日志。（P2.3 已落地 v1.56.7）

## 8. 后续

- P2.3 已作为 patch 小修落地；观察 2–3 次 Windows 本地维护任务，判断是否仍需 `template-docs/smoke-test.md` 扩展。
- P2.1 / P2.2 若落地，应先给出分拆方案 / 对照方案与回滚方式，不直接大改脚本结构。
