# GitHub Issue #275: TEMPLATE-UPGRADE: token-hotspots 本地化与 Git 忽略约束

> Source URL: https://github.com/emily8421/ai-project-template/issues/275
> State: OPEN
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-07-27T13:11:26Z
> Updated: 2026-07-27T13:11:26Z
> Mirrored at: 2026-07-28T17:14:50+08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE: token-hotspots 本地化与 Git 忽略约束

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：草案 · 待母模板维护者确认（B 组 · 待上行跨领域）
> 目标仓库：母模板 `ai-project-template`（本提案先存派生项目 `_proposals/`，成熟后 `submit-proposal` 回流）
> 目标版本：母模板下一个 patch
> Release impact：patch（对母模板；治理与脚手架澄清，不新增能力层级）
> Release strategy：可单独小修，也可并入下一次会话治理 / AI 记录整理批次

## 1. 背景与动机

`ai/session-rules.md` 已把 `ai-records/token-hotspots/` 定位为“可选的 AI 协作观察记录”，并明确它不是项目事实文档，不替代 handoff、开发计划或验证记录。

但当前母模板机制没有把“本地观察材料不进入正式提交”落成硬约束：

- `.gitignore` 只忽略 `NEXT-STEPS.md` 与 `.ai/session-handoff.md`，没有忽略 `ai-records/token-hotspots/*.md`。
- `scripts/check-template.*` 只检查 `session-rules` 中存在 token hotspot 目录与 summary 描述，没有检查 `.gitignore`。
- `MAINTAINERS.md` 发布 checklist 提到“涉及 `_proposals/`、`ai-records/` 等 Markdown 记录时运行 markdown clean”，容易让维护者误以为 token hotspot 可作为正式记录提交。
- 派生仓实际已出现 token hotspot 记录被 Git 追踪的情况，说明仅靠“可选观察材料”的文字不足以防误提交。

本提案目标：把 token hotspot 明确收敛为**本地 meta 观察材料**，默认不进入 Git 历史；需要回流的通用改进，应去项目化转写为 `_proposals/TEMPLATE-UPGRADE-*.md` 或 GitHub issue。

## 2. 目标

1. 母模板 `.gitignore` 默认忽略 `ai-records/token-hotspots/*.md`。
2. `ai/session-rules.md` 明确 token hotspot 记录默认只留本地、不提交；如需长期化，只能转写为正式提案、README、SOP 或维护文档。
3. `MAINTAINERS.md` / `template-docs/rd-data-chain.md` 区分可提交的 `ai-records/project-registry/` 与本地化的 `ai-records/token-hotspots/`，避免笼统写“ai-records 可提交”。
4. `scripts/check-template.*` 增加断言：`.gitignore` 必须覆盖 `ai-records/token-hotspots/*.md`。
5. 存量仓库若已有被追踪的 hotspot 记录，提供迁移建议：`git rm --cached -- ai-records/token-hotspots/*.md`，保留本地文件。

## 3. 非目标

- 不删除 token hotspot 机制；仍允许 AI 在用户确认后写本地观察记录。
- 不新增 summary 强制门禁；`SUMMARY.md` 仍是可选 rollup，本地保存。
- 不禁止把通用优化回流母模板；只是要求从 hotspot 摘要中去项目化转写为正式提案或 issue。
- 不把具体派生仓的本地路径、对话内容或 token 消耗写入母模板。

## 4. 拟改（母模板侧）

### 4.1 `.gitignore`

新增忽略项：

```gitignore
# AI 协作观察记录（本地 meta，不进入正式提交）
ai-records/token-hotspots/*.md
```

### 4.2 `ai/session-rules.md`

在 §4.1 写入边界中补充：

- token hotspot 文件默认为本地观察材料，不进入正式提交。
- 若记录中出现可通用的模板优化点，应去项目化转写为 `_proposals/TEMPLATE-UPGRADE-*.md` 或通过 `submit-proposal` / `submit-feedback` 回流。
- 写入 token hotspot 不等于形成模板事实、项目事实或可发布记录。

### 4.3 `MAINTAINERS.md` 与 `template-docs/rd-data-chain.md`

- 发布 checklist 中将 `_proposals/` 与 `ai-records/` 的 markdown clean 口径拆开：可提交的正式记录按需检查；本地忽略的 `token-hotspots` 不作为提交内容。
- `rd-data-chain` 中说明 token-hotspots 是 local-only meta，回流路径是提案 / issue，而不是直接提交记录本身。

### 4.4 自检脚本

`scripts/check-template.sh` / `scripts/check-template.ps1` 增加稳定断言：

- `.gitignore` 包含 `ai-records/token-hotspots/*.md`。
- `ai/session-rules.md` 仍声明 token hotspot 不替代 handoff、正式文档或验证记录。

## 5. 影响面与版本

- **Release impact：patch（对母模板）**。这是治理和脚手架一致性修正，不改变核心同步协议，不要求派生项目迁移业务文档。
- **派生项目影响**：后续新项目默认不会误提交 token hotspot；存量项目可在同步后按提示执行 `git rm --cached` 清理历史追踪项。
- **风险**：若团队希望保留可审计的 AI 成本记录，需要另设正式、脱敏、可提交的汇总文档类型，而不是复用 token hotspot 原始记录目录。

## 6. 验收建议

母模板落地时建议验证：

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File scripts\check-markdown-clean.ps1 _proposals MAINTAINERS.md template-docs\rd-data-chain.md ai\session-rules.md
powershell -ExecutionPolicy Bypass -File scripts\check-template.ps1
```

如可用 Git Bash，再跑：

```bash
bash scripts/check-template.sh --summary
```

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C1 | token hotspot 是否一律 local-only | 确认为 local-only | 它记录上下文成本与过程观察，不是项目事实；提交会扩大无效历史与隐私审计面 | 允许提交脱敏 summary | 允许 summary 会增加规则复杂度；不阻塞本提案核心忽略规则 |
| C2 | 是否为可提交 AI 成本记录另设目录 | 暂不新增 | 当前已有 `_proposals/` 可承载去项目化改进，避免新建记录体系 | 新增 `ai-records/token-hotspots/SUMMARY.md` 可提交例外 | 会与 local-only 口径冲突，需额外自检和迁移规则 |
