# TEMPLATE-UPGRADE: 入口文档简化（simplify-entry-docs）

> 状态：草案（待维护者评审）
> 提案目标版本：v1.22.1
> 提出日期：2026-07-01
> 维护分支：`change/simplify-entry-docs`
> 主题：v1.22.0 引入 scenario-guides 后，重新定位根目录与 template-docs 入口文档，简化用户路径

## 1. 动机

v1.22.0 引入 scenario-guides（场景引导编排层）后，入口文档导航重叠：

1. **README 有 7 个 section**（5 分钟路径 / 推荐路径 / 我该看哪个文件表 / 常用命令 / 目录速览 / 轻量路径 / 当前版本），信息过载。
2. **5 个文档都在做导航**（README / SOP / beginner-guide / scenario-guides / commands-README），用户不知从哪进。
3. **新手起步被描述多次**（README 推荐路径、beginner-guide 路径 A/B、scenario-guides A0），重叠。

核心：确立 scenario-guides 为「场景/新手」唯一入口，其他文档收敛定位。

## 文档定位（简化后）

| 文档 | 角色 | 谁读 |
|---|---|---|
| `README.md` | 门面，1 屏三入口 | 所有人第一站 |
| `template-docs/scenario-guides.md` | 场景/新手唯一入口（引导式，23 场景剧本） | 不确定做什么 / 新手 |
| `SOP.md` | 速查表（场景→命令/文档） | 知道意图找入口 |
| `ai/commands/README.md` | 单点命令路由（`/run`） | 用快捷命令 |
| `git-guide.md` | **git 操作 SOP 权威**（新建 §2 / 提交 §3 / 同步 §5 / PR §3-4，被引用） | 执行 git 操作时 |
| `template-docs/beginner-guide.md` | 理解手册（为什么这么设计） | 想理解模板 |
| `template-docs/template-methodology.md` | 设计深入说明 | 想深入理解 |

> **git-guide 定位**：它是**操作手册**（被 scenario-guides A2/A13/C4 等场景与 SOP 引用为权威源），不是导航入口。本提案**不大改 git-guide**——它的详细是操作手册该有的；只在此明确角色，避免被误当入口或与 SOP 速查重复。
> **SOP vs git-guide §7 命令速查**：SOP 偏「场景→命令映射」，git-guide §7 偏「git/gh 命令速查」；落地时 SOP 接收 README「常用命令」要指 git-guide §7，不复制。

## 2. 目标 / 非目标

### 目标
- README 瘦身到 1 屏（是什么 + 三入口 + 版本）。
- scenario-guides 成为场景/新手唯一入口（v1.22.0 已基本就位）。
- SOP 定位「速查表」；beginner-guide 定位「理解手册」。
- 路由表分工，删冗余。

### 非目标
- 不改 scenario-guides.md 内容（v1.22.0 已定稿）。
- 不改规则文件（global-rules / document-lifecycle-rules / session-rules / project-rules）。
- 不删任何文档（只移 / 收敛 / 精简）。

## 3. 拟改

### 3.1 README 瘦身（新结构）

```
# ai-project-template
（2-3 句简介）

## 快速开始
- 想让 AI 带我做 → 打开 AI CLI，说场景 / `/run scenario`  ─→ scenario-guides
- 我知道要做什么，找命令 → SOP 场景索引 / commands 命令表
- 想理解模板为什么这么设计 → beginner-guide / template-methodology

## 当前版本
v1.22.1（最近版本摘要，完整见 CHANGELOG）

## 目录速览（精简到关键路径）
```

section 去向：
| 现 README section | 处理 |
|---|---|
| 5 分钟最小路径 | **删**（手动命令已在 scenario-guides A0/A1 cmd 指针 + SOP） |
| 推荐路径：先打开 AI CLI | **合并**到「快速开始」第一个入口 |
| 我该看哪个文件（大表） | **删**（快速开始三入口已覆盖） |
| 常用命令 | **移到 SOP**（SOP 已有场景/命令索引） |
| 目录速览 | **精简**（留关键路径） |
| 轻量项目路径 | **移到 docs/README** |
| 当前版本 | **保留** |

### 3.2 SOP 定位「速查表」
- 顶部加一句：「不确定该做什么 → `/run scenario` 或 `template-docs/scenario-guides.md`」
- 接收 README 移来的「常用命令」；保留场景索引 + 常见选择。

### 3.3 beginner-guide 定位「理解手册」
- 起步动作指向 scenario-guides（已在 v1.22.0 收敛）。
- 删「路径 A/B」冗余手动命令（scenario-guides + cmd 兜底已覆盖）。
- 保留「理解模板设计」内容（为什么这样分层、文档体系怎么理解等）。

### 3.4 路由表分工
- scenario-guides 场景目录 = 完整剧本（权威）
- commands 命令表 = 单点命令速查
- SOP 场景索引 = 场景→命令速查
- README 大表 = 删（三入口替代）

### 3.5 check-template 调整
- 移除/调整 README 旧 section 的断言（如「5 分钟最小路径」「常用命令」在 README 的断言）。
- 加新断言：README 含「快速开始」三入口、SOP 顶部指 scenario-guides、常用命令已移到 SOP。

## 4. 版本与影响面

- **版本**：v1.22.0 → **v1.22.1**
- **修改**：`README.md`、`SOP.md`、`template-docs/beginner-guide.md`、`docs/README.md`（接收轻量路径）、`scripts/check-template.sh` / `.ps1`、`CHANGELOG.md`、`VERSION`
- **不改**：`scenario-guides.md`（v1.22.0 定稿）、规则文件、commands/scenario.md

## 5. 落地步骤

1. README 瘦身（新结构 + 移走 section）
2. SOP 接收「常用命令」+ 顶部指 scenario-guides
3. beginner-guide 删路径 A/B，定位理解手册
4. docs/README 接收「轻量项目路径」
5. check-template 调整断言
6. VERSION → v1.22.1 + CHANGELOG
7. PR + 合并 + 归档

## 6. 验证

- `check-template.sh` / `.ps1` 通过（含调整后的断言）
- README 瘦身后仍含关键入口（scenario-guides、SOP、beginner-guide、VERSION）
- 三处（README / beginner-guide / ai-cli-setup）不重复新手起步描述

## 7. 风险

- README 瘦身可能丢失某些用户依赖的入口 → 保留关键链接（scenario-guides / SOP / beginner-guide / CHANGELOG / VERSION）。
- check-template 断言调整需与 README 改动同步，否则自检失败。
- 「常用命令」移到 SOP 后，README 读者需知道去 SOP 找 → 「快速开始」第二入口已指 SOP。
