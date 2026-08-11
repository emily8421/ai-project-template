# TEMPLATE-UPGRADE: 坑 / 问题观察日志（pitfall observation log）

> 来源：模板维护者（2026-08-11 评估：建设模板与派生项目过程中，AI 引入 bug、流程坑与低效行为反复出现，现有记录通道分散，无集中沉淀与定期审视）
> 状态：候选（已按 2026-08-11 评审意见修订 R1–R4，待评审）
> 目标版本：待确认
> Release impact：patch（AI 建议，待维护者确认；新增可选记录载体 + 索引 / 规则补强，不改变同步结构、默认行为与 CI 门禁）
> Release strategy：同主题聚合（与 `rd-data-chain` 索引、`session-rules` 触发点、`.gitignore` 一并落地）

## 1. 背景

在建设模板与派生项目过程中，反复出现同类问题：AI 生成引入的 bug、流程执行踩坑（worktree 漂移、同步脚本过旧需 bootstrap、提案未评估就实施、CI 误拦截等）、AI 低效行为导致的问题（越界搜索引发误改、长输出回灌掩盖失败细节等；纯上下文成本归 token-hotspots，本日志只记其导致的问题 / 教训）。这些观察目前散落在：

- `.ai/session-handoff.md`：gitignored，随 checkpoint rollup 被压缩 / 归档，观察易丢。
- `sync-records/template-sync/*`：只覆盖同步场景。
- GitHub issue 与 `_proposals/_remote-issues/`：只覆盖已上升为正式提案 / 反馈的条目。
- `.ai/token-hotspots/`：只覆盖 token 成本 / 上下文热点，不覆盖问题与教训。

**没有统一的「坑 / 问题教训」记录载体，也没有定期回看归纳的触发点**。结果：同类坑在不同项目 / 会话中重复踩，经验无法沉淀为模板优化。

## 2. 目标

1. 提供轻量的坑 / 问题观察日志：记录现象、根因、规避方式，作为定期审视的原始材料。
2. 建立「记录 → 定期审视 → 归纳 → 转提案」闭环：可通用的归纳为去项目化 `TEMPLATE-UPGRADE-*.md` 进入既有回流通道；项目专属的留在项目内。
3. 与既有通道分工明确，不重复造轮子：`token-hotspots` 管 AI 开发的上下文 / 成本热点，本日志管问题 / 教训（含低效行为导致返工或缺陷的教训，但不记纯 token 成本）；同步运行记录管同步场景，本日志管全场景；定期审视复用 `ai/global-rules.md` §9（模板优化反馈）的任务收尾审视规则，不另设并行审视机制。

## 3. 非目标

- 不做强制表单、必填字段校验或 CI 门禁（遵循「更少更硬、避免过度治理」，与 `rd-data-chain.md` §4 一致）。
- 不新增 `template-sync.json` 强制同步文件；`rd-data-chain.md` / `session-rules.md` 已在同步清单，随版本同步即可。
- 不记录 token、密钥、账号密码、客户敏感数据或无法提交到仓库的隐私事实。
- 不替代 `docs/00-09` 事实文档、`docs/decisions/` ADR、`_proposals/` 提案或 `docs/09` 验证记录；长期结论仍须回写正式文档。
- 不新增并行审视流程：审视动作复用既有触发点（global-rules §9 收尾审视、C1 提案收件箱 triage），本提案只补「原始材料载体 + 回看提示」。

## 4. 机制设计

### 4.1 载体

- 本地单条：`.ai/pitfalls/YYYY-MM-DD-<short-name>.md`（gitignored，类比 `.ai/token-hotspots/`）。
- 可选提炼入库：`ai-records/pitfalls/SUMMARY.md`（脱敏汇总，类比 token-hotspot summary）。**默认不建**：只有提炼出值得入库的脱敏结论时才创建，且首次创建前需用户确认路径与内容边界；派生项目不建议为「跟风」建 `ai-records/`。
- 模板仓 `.gitignore` 增加 `.ai/pitfalls/`；派生项目按需自行创建并 `.gitignore`（与 `.ai/token-hotspots/` 同款模式，`.gitignore` 不在同步清单、项目自有）。

### 4.2 单条记录字段（最小）

```markdown
- 日期：
- 项目 / 场景：
- 现象：（发生了什么问题 / bug / 低效行为）
- 根因分类：AI 引入 / 流程坑 / 环境 / 模板缺口
- 规避或修复：（怎么绕开或修掉的）
- 是否可通用：是 / 否（换一个项目是否还会踩）
- 已转提案：`_proposals/...` 或 issue 链接；未转为「待审视」
```

### 4.3 触发与写入

- 任务收尾自检（`ai/session-rules.md` §4 触发点 / §4.3）顺带判断本次是否产生坑观察；有则写单条（1–3 行，不膨胀）。
- 本地累计 ≥3 条未汇总时，收尾自检时提示 rollup / 审视（复用 token-hotspot §4.2 节奏），不靠事后想起。

### 4.4 定期审视与归纳

- 审视动作复用既有触发点：`ai/global-rules.md` §9（模板优化反馈）的任务收尾审视（任务收尾顺带判断是否暴露可通用优化点）+ §4.3 收尾自检的未汇总计数；本提案不另设并行审视机制，只提供被审视的原始材料。C1（`ai/prompts/maintainers/11-template-proposal-summary.md`）只负责提案 triage，不承担坑日志计数——token-hotspot 计数亦在 §4.2 收尾自检，不在 C1。
- 归纳去向：可通用的 → 去项目化转 `_proposals/TEMPLATE-UPGRADE-*.md`；项目专属的 → 留项目 `docs/decisions/` 或项目本地日志。
- **观察日志 ≠ 提案**：日志是原始材料，triage 后才转提案，避免提案收件箱噪音。

### 4.5 生命周期与清理

- 单条经 rollup 纳入 `SUMMARY.md` 或已转提案后，标注「已纳入 / 已转提案」；已覆盖的旧单条可归档到 `.ai/pitfalls-archive/`（gitignored）或清理，避免无限累积（类比 token-hotspot 生命周期）。
- 与 `session-rules.md` §6.1 handoff rollup 同构：用归档而非删除，保留可追溯。

### 4.6 示例（供格式参考，不强制模板）

```markdown
- 日期：2026-08-11
- 项目 / 场景：派生项目同步 v1.61.0（zhiyan）
- 现象：首次 dry-run EXIT=1，脚本停止，提示本地 sync-template.sh 不是远端最新版
- 根因分类：流程坑（本地脚本过旧，未先 bootstrap）
- 规避或修复：按脚本提示 `git checkout FETCH_HEAD -- scripts/sync-template.sh` + 单独提交后重跑
- 是否可通用：是（所有旧派生项目同步前都应先 bootstrap）
- 已转提案：待审视（脚本已有内置提示，暂无需改模板）
```

## 5. 拟改文件

| 文件 | 改动 |
|---|---|
| `.gitignore` | 增加 `.ai/pitfalls/` |
| `template-docs/rd-data-chain.md` | §2 辅助留痕索引新增「坑 / 问题观察」类别（载体 / 主链关系 / 生命周期 / 流转到提案）；§4「无门禁」枚举补 pitfalls 保持自洽 |
| `ai/session-rules.md` | 新增 §4.3「pitfall 观察日志」，与 §4.1 / §4.2 同构（载体 / 触发 / rollup ≥3 / 归档 / 汇总状态字段 / 派生项目 .gitignore 提示；不含 C1 triage 项）；§4 触发点顺带指向 §4.3 |

## 6. 影响面与验证

- 影响面：派生项目可选采用；不改变同步结构、默认行为与 CI；`check-template` 不新增断言。
- 依赖与去重：与 token-hotspots（成本热点）、sync-records（同步场景）、ADR（决策）、global-rules §9（审视规则，复用）分工明确，无重复、无冲突、无前置依赖。
- 验证：本提案评审通过后，落地改动跑 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1` 自检；手动走查一条样例记录 + 一次 rollup 提示。

## 7. 落地流程（候选）

1. 评审本提案（含 `Release impact` 判断：建议 patch；若判定为知识沉淀路径的首块地基、按新增能力层级则升 minor）。
2. 落地：改 `.gitignore`、`rd-data-chain.md`、`session-rules.md`。
3. 判断版本递增并更新 `VERSION` / `CHANGELOG.md`。
4. PR 合并后归档本提案；派生项目随下次同步获得规则与索引更新。
