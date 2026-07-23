# Token Hotspot 汇总：2026-07-10 ~ 2026-07-22

> 生成日期：2026-07-22
> 归纳方法：基于已通读的 4 份记录（07-20 v1.55 归档 + 本地插件资料评估、07-22 v1.56 PR#240 闭环、07-22 check-template PR#244、07-22 C1 B4/B2/#232 归档 PR#245-247）+ 其余 12 份文件名 / 任务类型分布归纳；**非逐份全文审计**。后续记录累积后再更新。

## 1. 汇总范围（记录日期、任务类型、主要热点）

- **份数**：14 份历史 + 本会话 2 份（check-template PR#244、C1 B4/B2/#232 归档 PR#245-247）= 16 份（截至 2026-07-22）。
- **日期范围**：2026-07-10 ~ 2026-07-22。
- **任务类型分布**（按文件名）：
  - 机制自身（07-10 mechanism-proposal、windows-smoke-test-guidance）
  - 领域模板 / 跨仓同步（07-11 ~ 07-13 domain-template 系列 4 份）
  - 能力包 / issue 处理（07-15 capability-package、07-16 issue-221 stage A/B）
  - 派生项目同步（07-18 dcs-sync-stage2、lumen-version-mechanism、template-sync-proxy）
  - PR/CI 闭环 + 归档 + 评估（07-20 v1.55 归档 + 本地插件资料评估、07-22 v1.56 PR#240、07-22 check-template PR#244、07-22 C1 B4/B2/#232 归档 PR#245-247）
- **主要热点**：规则门禁读取（反复全文读 CONTRIBUTING / git-guide / rules 包）、PR/CI 闭环的远端 gh 查询、归档 / 同步目录 Glob 大列表、跨仓同步的多仓库上下文、验证失败的环境诊断往返、**triage 对照（提案描述 vs 实际现状，如 #232 阈值已落地、B3 标候选但实际已合并）**。

## 2. 为什么触发 / 为什么此前未触发

- **为什么触发**：rollup 机制（§4.2）落地前，记录分散积累到 14 份无汇总；多数记录都走「快速续接 → 升级为写入 / PR 闭环」路径，天然命中 §4.1（读完整规则包 + 大文件 + 远端操作）。
- **为什么此前未触发**：§4.2 rollup 是 v1.56.1（#243）才闭环的；此前无累计汇总触发点，记录各自独立、未回流。

## 3. 重复热点模式

- **规则读取（最高频）**：模板维护 / PR 闭环按 `ai/index.md` 路由反复全文读 CONTRIBUTING、git-guide、template-sync.json、project-rules、rules-core、proposals README。每轮 PR 闭环都重读一遍。
- **验证日志 / 环境诊断**：check-template / CI / runtime 检查的失败诊断（PowerShell stderr 包装、new-project smoke 超时、node 解析路径）反复消耗往返。
- **远端 gh 查询**：PR review / checks / merge / 分支清理的多次 gh api + `ConvertFrom-Json` 精简。
- **目录 Glob 大列表**：`_archive/proposals/`（90+ 文件）、`ai/prompts/` 全列用于定位命名规范 / 先例。
- **跨仓同步**：派生项目同步的多仓库上下文（dcs / lumen / zhiyan / agent-system-template）。

## 4. 已形成的改进建议（必须保留 / 应压缩 / 应沉淀 / 应拆会话）

- **应压缩**：模板维护 + PR 闭环的规则门禁可提炼为「PR 闭环 checklist」速查（CONTRIBUTING §3 / §4 + git-guide §1.1 / §3.1 + project-rules §6 + 预检命令），减少每轮全文重读。
- **应沉淀**：check-template 本地 Windows 卡在 `require_new_project_local_smoke`（>2min）→ 评估 CI-only / 超时跳过（独立提案候选）；PowerShell 5.1 native stderr 陷阱 → 脚本内防御（`2>$null` 或宽松 ErrorActionPreference）。
- **必须保留**：规则门禁本身（写入前确认 + 任务路由）是质量护栏，不可省；远端单步确认 + 代理配置（7897）；issue 镜像硬门禁（远端正文不直接作分析依据）。
- **应拆会话**：跨仓批量同步（sync-all-derived）+ 多 issue triage（C1）应独立会话，避免单会话上下文过载。
- **记录节奏（本轮教训）**：连续多轮 PR 闭环（B4 / B2 / #232）累积补记而非每轮即时——可在每轮 PR 合并后即写单条记录，降低事后回忆成本；CI 轮询 sleep 应 ≥20s（template-check 实际 ~11–17s，15s 易二次轮询）。

## 5. 模板回流判断（是否需要形成 _proposals/ 提案，去项目化边界）

- **check-template 本地可用性**（new-project smoke 在 Windows 慢 + PowerShell stderr 脆弱）：去项目化、通用于所有 Windows 维护者 → **适合形成 `_proposals/TEMPLATE-UPGRADE-check-template-local-usability.md`**（候选，非本轮范围；已记入 07-22 PR#244 记录的「非目标」+「优化建议」）。
- **PR 闭环规则速查 checklist**：若规则重读成本反复出现，可评估沉淀为 `template-docs/` 速查页或 command 速查（候选，先观察频率）。
- **本汇总机制自身**：§4.2 rollup 已落地，本次为首份 SUMMARY，验证结构可用性；后续按阈值更新即可，无需额外提案。
