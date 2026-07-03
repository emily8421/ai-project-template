# TEMPLATE-UPGRADE-session-resume

> 来源：模板维护者（源于多 AI CLI 实际使用场景：窗口中断、撞 token / 时间上限被迫换 CLI 接手）
> 主题：让「会话续接 / 中断恢复」在多 CLI + 被动中断下更稳

## 动机

实际使用中高频出现：「读取续接点 / 继续上次 / 接着干」——尤其当某个 AI CLI 撞 token 或时间上限被强制中断、用户不确定接下来用哪个 CLI 接手时。当前规范有三个缺口：

1. **裁决优先级散落**：`session-rules.md` §1 末尾一句、§2 第 6 步一句，AI 每次得自己拼「以谁为准」。且 §2 第 2 步（读 handoff）在第 3 步（git）之前，易被过时 handoff 先入为主。
2. **被动中断未显式命名**：§2 默认 handoff 存在且较新；但被动中断（来不及写 handoff / 跨 CLI 接手）时 handoff 缺失或过时，此时应以 Git 为唯一锚点——规范没说。
3. **场景层缺入口**：25 个场景（A0–A15 / C1–C8 / M1）没有「会话续接」，用户说这句话时 AI 无显式路由，只能碰巧记得读 session-rules。

## 拟改

### 块 1：`ai/session-rules.md` §1 加固（优先级链 + 主动/被动中断 + NEXT-STEPS 定位收紧）

- §1 标题改为「续接文件定位与裁决优先级」。
- 「兼容旧文件」收紧为「仅读旧项目时兜底，新项目不再创建 `NEXT-STEPS.md`」。
- 原第二条 bullet（两者冲突以 git+用户为准）合并进新「裁决优先级」第 4 条，避免重复。
- 追加「裁决优先级」清单（Git 客观事实 > handoff > NEXT-STEPS > 冲突停下问用户）。
- 追加「主动 vs 被动中断」表：主动=handoff 新鲜交叉核对；被动（含跨 CLI 接手）=Git 为唯一锚点。
- 收尾点明：跨 CLI 时 handoff + Git 是公共状态，换 CLI 不丢上下文。

### 块 2：`ai/session-rules.md` §2 恢复流程（先 Git 后 handoff + 显式被动分支）

- 调整为「先取 Git 客观事实，再读续接文件」，避免被过时记录先入为主。
- 第 2 步先跑 `git status --short --branch` / `git log --oneline -8` / `git stash list`。
- 第 4 步显式「交叉核对判主动/被动」：一致→主动可信；缺失或冲突（分支不符/进度落后/孤儿改动）→被动（含跨 CLI），以 Git 为唯一锚点重建。
- 第 6 步：被动中断且上下文无法完全重建时，列出不确定项。

### 块 3：`template-docs/scenario-guides.md` 新增 A16 + 修索引

- 新增 `#### A16 会话续接 / 中断恢复（跨 CLI 接手）`，仿 A15 结构（说明/触发/cwd·前置/三列表格/完成判据/下一步/cmd 指针）。
- 触发说法：「读取续接点」「继续上次」「接着干」「我上次做到哪了」「换了 CLI 接着做」「恢复上下文」。
- 步骤：先取 Git 客观事实 → 再读续接文件 → 交叉核对判主动/被动 → 向用户简述恢复状态。
- cmd 指针：`ai/session-rules.md` §1 裁决优先级 + §2 恢复流程。
- 顺带修正已有索引 bug：§5 顶部「A 使用者（A0–A14）」与章节「### A 使用者（A0–A15）」均改为「（A0–A16）」，并在 A15 行后加 A16 索引行。

### 块 4：`ai/commands/README.md` 自然语言别名

- 自然语言示例块加一行 `读取续接点 / 继续上次`，让 AI 识别该短语时路由到 scenario → A16（不新增 command，避免与场景双写）。

## 版本影响

- 改的是 `session-rules.md` / `scenario-guides.md` / `commands/README.md`（均非 `global-rules.md`），不触发 global-rules 自身版本 bump。
- 模板整体 VERSION：新增场景 + 规则加固 = MINOR → **v1.26.0**。`CHANGELOG.md` + `README.md` 最近版本摘要同步。

## 影响面

- **模板文件**：`ai/session-rules.md`、`template-docs/scenario-guides.md`、`ai/commands/README.md`。
- **下行同步**：上述若在 `template-sync.json` 清单（落地时核实），会同步到派生项目（digital-cs-demo / zy-digital-cs 等）。纯增强 + 向下兼容（只新增场景、收紧规则），不破坏派生已有 handoff。
- **本仓库 housekeeping（附带，已做）**：删除根目录过时的 `NEXT-STEPS.md`（v1.21.3 旧记录，已 gitignore）——不进版本库，独立于本提案。

## 验证

- `bash scripts/check-template.sh`（PowerShell fallback）全过。
- 核对 scenario-guides 索引标题与实际场景数一致（A0–A16 / C1–C8 / M1）。
- 核对 session-rules §1/§2 内部引用一致。
- 人工：模拟一次「被动中断 + 换 CLI」恢复，走 A16 流程验证。

## 落地流程

1. 切 `change/session-resume`（已做；当前单会话用普通分支，未开 worktree）。
2. 落盘本提案到 `_proposals/TEMPLATE-UPGRADE-session-resume.md`。
3. 改块 1–4。
4. `check-template.sh` 自检 + 场景数核对。
5. VERSION → v1.26.0，CHANGELOG + README 摘要。
6. PR → CI → squash 合并 → 提案归档 `_archive/proposals/`。
