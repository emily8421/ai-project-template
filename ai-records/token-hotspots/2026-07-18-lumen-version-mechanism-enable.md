# Token Hotspot 记录：LUMEN-DEMO 项目自有版本机制启用（post-sync-cleanup）

> 日期：2026-07-18
> 任务类型：派生项目同步后整理（post-sync-cleanup）——启用 LUMEN-DEMO 自有版本机制 v0.1.0（VERSION/CHANGELOG/TEMPLATE-BASE + project-rules §2.8 + 新建 project-check.yml + PR LUMEN-DEMO#82 + 合并）
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入分析/写入后读取规则路由 + post-sync-cleanup SOP + 多个派生项目文件；派 agent 跨项目取参考实现）

## 热点工作

- **规则读取**（快速续接 → 执行升级路径，非完整回退包）：`ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`（§1/§3.1/§4.1）、`ai/prompts/maintainers/15-post-sync-cleanup.md`（169 行 SOP）、`ai/commands/commit-message.md` + `ai/prompts/git/06-commit-message.md`（commit 规范）。
- **LUMEN-DEMO 派生项目文件**：`ai/project-rules.md`（146 行全文，确认无 §2.8 + 定位插入点 §2.7 后）、`template-sync.json`（150 行全文，确认 VERSION/CHANGELOG 在清单 → 引出覆盖矛盾）、`CHANGELOG.md`（顶部 40 行，定位模板 sync notice + v1.47.1 条目结构）、`sync-records/template-sync/2026-07-17-sync-template-v1.54.1.md`（62 行，提取待办 + 网络备忘）、`NEXT-STEPS.md`（114 行旧续接）、`VERSION`/`TEMPLATE-BASE.md`、`scripts/check-derived-sync.sh`（grep §185-198 定位双信号检测逻辑）。
- **zhiyan 参考实现采集**：派 general-purpose agent 读 zhiyan 8 个文件（template-sync.json / project-check.yml / project-rules §7 / VERSION / CHANGELOG 顶部 / TEMPLATE-BASE / sync-template.ps1 §215-219/564/659 / check-template.sh §940/947），主线只收 agent 结构化结果（完整 YAML + §7 全文 + 覆盖解法判断）——**zhiyan 文件原文未进主线上下文**。
- 只读检查 + 编辑：多次 git 只读（status/log/branch/check-github-context）、本地校验模拟、Edit 5 文件、commit 2 次、push、`gh pr create`、`gh pr merge`、Monitor CI。
- 留痕：LUMEN sync-record + NEXT-STEPS 重写 + 母模板 memory 更正（误判）+ MEMORY.md index + handoff。

## 热点判断

- **主要成本**：LUMEN 派生项目文件读取（project-rules 146 行 + template-sync.json 150 行 + sync-record 62 行 + NEXT-STEPS 114 行 + CHANGELOG 顶部 + 多次 VERSION/TEMPLATE-BASE）。
- **次要**：规则路由读取（按需非全回退包）；check-derived-sync grep 定位。
- **关键节省**：zhiyan 参考实现 8 文件**交给 agent**，主线只收结构化结论——若主线直读 zhiyan 全部文件，上下文会显著膨胀（project-check.yml + project-rules §7 + CHANGELOG + sync-template.ps1 片段等）。本轮最大的 token 优化点。
- **总量级**：medium。

## 质量影响

- **agent 分担模式生效**：跨项目取参考实现（派生项目对照已启用项目）是可复用的降上下文模式；agent 返回精确片段（YAML/Markdown 原文 + 判断），主线直接用，省去主线直读 + 自行提炼。
- **H-003（验证证据摘要）生效**：check-derived-sync 输出只留版本机制段 + EXIT（整体 EXIT=1 但定位到版本机制段 ✓，未全刷）；CI 输出只留 pass + 耗时。
- **快速续接交叉核对价值**：本轮从快速续接起，用户澄清 + 读 CHANGELOG 顶部（v1.47.1 条目实为模板脚本记录）→ 发现 handoff/memory「双版本正常」系误判。印证 `session-rules §1` 裁决优先级：handoff 主观记录要与 Git/文件事实交叉验证，不能盲信。
- **Glob 中文路径坑**：Glob 工具对含中文的 Windows 路径（`3-LUMEN_KnowledgeBase`）返回 No files found，Read 工具同路径正常 → 回退 Bash ls 兜底；未据 Glob 空结果误判 LUMEN 无 docs/.github。
- 关键合规：版本机制启用符合 `15-post-sync-cleanup §5` 双信号判定（主 project-check.yml + 辅 project-rules「项目版本管理」子串，规避节号漂移 C-002）；VERSION/CHANGELOG 留在 template-sync.json 靠 `--preserve-project-version` 防覆盖（不移除清单，过 check-template.sh）。

## 优化建议

- **推广 agent 分担取参考实现**：派生项目启用版本机制这类「对照已启用项目抄作业」场景，固定派 agent 取参考（project-check.yml / project-rules 版本章节 / CHANGELOG 组织 / 覆盖解法），主线只收结论。可写入 post-sync-cleanup prompt 或 git-guide 作为推荐做法。
- **Glob 中文路径回退**：Glob 对含中文 Windows 路径失效、Read 正常，应在工具使用备忘记一笔：Glob 空结果 + 路径含中文时回退 Bash ls，不得据空结果推断目录/文件不存在。
- **版本机制启用可沉淀 checklist**：本次操作（VERSION 改值 + CHANGELOG 顶部项目版本段 + 历史分隔符 + TEMPLATE-BASE + project-rules §2.8 + project-check.yml + 验证双信号）是可重复模式（zhiyan 已做、LUMEN 本次、digital-cs-demo 等后续可能做）。`post-sync-cleanup §5` 已有判定逻辑，但实际「怎么改」的步骤散在参考实现里；可考虑在 prompt 增「启用操作 checklist」小节，减少下次重新对照 zhiyan 的成本。
- **快速续接误判检测**：handoff/memory 关于派生项目「VERSION 与继承版本关系」的判断易误（本次 + 之前 v1.46.0 双版本治理都有类似混淆）；快速续接时若 handoff 提及版本号比较，应主动读 CHANGELOG/VERSION 原文核对，而非采信 handoff 结论。

## 关联

- PR LUMEN-DEMO#82（squash 合并 main `70b3b8e`，CI project-check pass 9s）。
- 派生项目：LUMEN-DEMO（ordinary）；参考实现：zhiyan-digital-cs-platform（v0.3.0，已启用）。
- SOP：`ai/prompts/maintainers/15-post-sync-cleanup.md` §5（版本机制启用状态审计）。
- 机制：`_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`（H-001 / H-003）。
- 相关 hotspot：`2026-07-12-domain-template-version-governance.md`、`2026-07-16-issue-221-stage-a.md` / `2026-07-16-issue-221-stage-b.md`（版本治理机制本身的建设记录）。
