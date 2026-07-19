# TEMPLATE-UPGRADE: check-template 诊断与脚本维护性优化

> 来源：模板维护者（token-hotspot records：capability batches、derived version stage A/B、sync proxy debug、domain sync closure）
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：patch / minor 待定（诊断增强为 patch；结构拆分或新增工具可能为 minor）
> Release strategy：P1 小修诊断与注释；P2 再评估结构拆分和 `.sh`↔`.ps1` 对照工具

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

## 6. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 失败输出过长 | 中 | 只输出断言名、文件、pattern 和最小上下文；完整日志仍本地保存 |
| 断言分拆增加维护复杂度 | 中 | P2 先评估；P1 仅加注释和诊断 |
| 对称检查误报 | 中 | 只检查关键能力 / 参数 / 提示，不做逐行一致性 |
| fallback 覆盖被误解为等价 | 中 | 文档明确 `.ps1` 是结构性兜底，不等于 Bash 权威自检 |

## 7. 验收标准

- 新增断言时能从函数注释判断 ERE pattern 写法。
- `check-template` 失败时无需先翻完整长日志即可知道失败断言、文件和期望模式。
- 若进入 P2，必须先给出分拆方案与回滚方式，不直接大改脚本结构。
- 双语言对称评估不扩大普通任务上下文读取范围。

## 8. 后续

- 可先落 P1 小修作为 patch；观察 2–3 次模板维护任务后，再决定 P2 是否必要。
- 若 P2 落地，应同时更新 MAINTAINERS 自检说明和相关 check-template 断言。
