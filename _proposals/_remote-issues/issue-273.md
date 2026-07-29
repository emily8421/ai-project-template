# GitHub Issue #273: TEMPLATE-UPGRADE: 派生项目 changelog 归属与继承参考分离（upstream/ + 大白话版配对）

> Source URL: https://github.com/emily8421/ai-project-template/issues/273
> State: CLOSED
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-07-27T07:10:43Z
> Updated: 2026-07-28T01:11:53Z
> Mirrored at: 2026-07-28T17:14:50+08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE: 派生项目 changelog 归属与继承参考分离（upstream/ + 大白话版配对）

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：草案 · 待母模板维护者确认（B 组 · 待上行跨领域）；设计决策 C1-C4 已由派生项目维护者锁定（2026-07-27），可回流
> 目标仓库：母模板 `ai-project-template`（本提案先存派生项目 `_proposals/`，成熟后 `submit-proposal` 回流）
> 目标版本：母模板下一个 minor
> Release impact：minor（对母模板；改变下行同步行为：保留清单扩展 + 新同步路径）
> Release strategy：可分批落地；需考虑存量派生项目迁移（根 `CHANGELOG-PLAIN.md` 归属转移 + `upstream/` 新增）

## 1. 背景与动机

母模板 v1.46.0 / v1.53.0 让派生项目（普通 + 领域）拥有自有版本治理：项目自己的版本放 `VERSION`，继承的母模板版本放 `TEMPLATE-BASE.md`。v1.47.0 让领域模板（`--domain-template`）保留自身 `VERSION` / `CHANGELOG.md`。

但**大白话版 changelog 没有同步归属**：

- `sync-template.*` 的保留清单（`--preserve-project-version` / `--domain-template`）只排除 `VERSION` + `CHANGELOG.md`，**不含 `CHANGELOG-PLAIN.md`**（见 `sync-template.ps1:218` / `sync-template.sh:267`）。
- 因此派生项目的根 `CHANGELOG-PLAIN.md` 仍被母模板同步覆盖，**派生项目无法拥有自己的大白话 changelog**。
- 同时 `CHANGELOG-PLAIN.md` 第 6 行自称「本文是 `CHANGELOG.md` 的大白话同步版」——在母模板仓成立，但下发到任何派生项目后**误导**：派生项目的 `CHANGELOG.md` 是它自己的 v0.x，而 `CHANGELOG-PLAIN.md` 是母模板的 v1.56.x，两者版本空间不同。

后果（所有派生项目，普通 + 领域均受影响）：

1. 派生项目无法为自己的演进维护大白话 changelog（被覆盖）。
2. 母模板的变更记录占着根目录 `CHANGELOG-PLAIN.md`，与派生项目自己的 changelog 命名冲突、语义混淆。
3. 「每份 changelog 都配大白话版」的约定在派生项目里无法成立。

本提案目标：让派生项目**完全拥有自己的 changelog 对（正式 + 大白话）**，母模板的变更记录**分离到 `upstream/` 作继承参考**，且**每份 changelog 都配大白话版**。

## 2. 目标

1. 派生项目（普通 + 领域）完全拥有根目录 changelog 对：`CHANGELOG.md`（正式）+ `CHANGELOG-PLAIN.md`（大白话），均不被母模板同步覆盖。
2. 母模板的变更记录以**继承参考**形式下发到 `upstream/`（`upstream/CHANGELOG.md` + `upstream/CHANGELOG-PLAIN.md`），与派生项目自己的 changelog 物理分离、命名不冲突。
3. 每份 changelog 都配大白话版（派生项目自己的对 + 继承对，都成对）。
4. 修正 `CHANGELOG-PLAIN.md` 第 6 行措辞，消除「派生项目里它是派生 changelog 的大白话版」的误导。

## 3. 非目标

- 不改两层主同步路径语义、不改 `git-guide.md` §5 主路径。
- 不强制存量派生项目立即迁移（提供向后兼容窗口）。
- 不改变 `VERSION` / `TEMPLATE-BASE.md` 现有归属与保留机制。
- 不绑定具体领域（agent 或其他）；本提案是跨领域通用的同步机制改进。

## 4. 拟改（母模板侧）

### 4.1 保留清单加入 CHANGELOG-PLAIN.md

`sync-template.sh` / `sync-template.ps1` 的 `--preserve-project-version` 与 `--domain-template` 保留清单，从 `VERSION, CHANGELOG.md` 扩展为 `VERSION, CHANGELOG.md, CHANGELOG-PLAIN.md`。派生项目根目录的 `CHANGELOG-PLAIN.md` 不再被覆盖，归派生项目自有。

### 4.2 母模板 changelog 对同步到 upstream/

母模板把自己的 changelog 对**同步到派生项目的 `upstream/`**（而非根目录）：

- `upstream/CHANGELOG.md`：母模板正式 changelog（继承参考）。
- `upstream/CHANGELOG-PLAIN.md`：母模板大白话 changelog（继承参考）。
- 更新 `template-sync.json` 同步路径 + `sync-template.*` 兜底清单 + `check-template.*` 断言。
- `upstream/` 顶部加定位说明：本目录是继承自母模板的只读参考件，记录母模板自身演进；派生项目自有版本以根 `VERSION` / `CHANGELOG.md` / `TEMPLATE-BASE.md` 为准。

### 4.3 修正 CHANGELOG-PLAIN.md 第 6 行措辞

母模板 `CHANGELOG-PLAIN.md` 第 6 行改为说明「本文件是母模板 changelog 的大白话版，记录母模板自身演进；派生项目自有版本演进以其本地 `CHANGELOG.md` / `CHANGELOG-PLAIN.md` 为准」。消除下发后的误导。

### 4.4 自检与文档

- `check-template.sh` / `.ps1`：更新 changelog 相关断言（保留清单含 `CHANGELOG-PLAIN.md`、`upstream/` 路径存在与定位说明、配对完整性）。
- `template-docs/domain-templates.md` / `beginner-guide` / `template-methodology`：补 changelog 归属与 `upstream/` 继承参考约定。
- `new-project.sh`：新建派生项目时，根目录初始化项目自有的 `CHANGELOG.md` + `CHANGELOG-PLAIN.md`（v0.1.0 对），`upstream/` 由首次同步填充。

## 5. 影响面与版本

- **Release impact：minor（对母模板）**——改变下行同步行为（保留清单扩展 + 新同步路径 `upstream/`），不破坏现有项目创建主流程，但派生项目同步后会观察到根 `CHANGELOG-PLAIN.md` 不再被覆盖 + 新增 `upstream/`。
- **存量派生项目迁移**：根 `CHANGELOG-PLAIN.md` 当前是母模板内容，本提案后归派生项目自有；建议同步脚本检测到根 `CHANGELOG-PLAIN.md` 仍是母模板内容时，非阻断提示派生项目改写为自己的大白话 changelog。`upstream/` 是纯新增，无破坏。
- **目标版本**：母模板下一个 minor。

## 6. 已确认决策（派生项目维护者 2026-07-27 确认）

> 以下决策已由 `agent-system-template` 维护者确认；提交母模板时作为既定设计，非开放问题。

| ID | 决策点 | 选定 |
|---|---|---|
| C1 | 继承参考目录名 | **`upstream/`**（简短、自说明「上游继承」、可扩展放其他继承参考件） |
| C2 | 适用范围 | **普通派生 + 领域模板都纳入**（普通派生也有自有 `CHANGELOG` v0.x，同样面临冲突；一致性） |
| C3 | `upstream/` 内容 | **正式 + 大白话一对**（满足「每份 changelog 配大白话版」+ 完整参考） |
| C4 | 存量派生项目根 `CHANGELOG-PLAIN.md` 迁移 | **同步脚本非阻断提示改写**（不静默把母模板内容当成派生自有） |

## 7. 验收（母模板侧落地后）

- `sync-template.* --preserve-project-version` / `--domain-template` 保留清单含 `CHANGELOG-PLAIN.md`（断言）。
- 派生项目同步后：根 `CHANGELOG.md` + `CHANGELOG-PLAIN.md` 归项目自有（不被覆盖）；`upstream/CHANGELOG.md` + `upstream/CHANGELOG-PLAIN.md` 存在且为母模板继承参考。
- `CHANGELOG-PLAIN.md` 第 6 行措辞不再误导（断言）。
- `check-template.*` 全过；`new-project` 烟测新派生项目 changelog 对 + `upstream/` 就位。
- 不影响两层主同步路径；不绑定具体领域。

## 8. 衔接

- 落地后，派生项目（含 `agent-system-template` 领域模板）即可补自己的 `CHANGELOG-PLAIN.md`（项目自有版本的大白话），完成「正式 + 大白话」配对，并与 `upstream/` 继承参考清晰分离。
- 本提案属派生项目回流（B 组），先存本仓库 `_proposals/`，成熟后经 `submit-proposal` 回流母模板 issue 仓；不在本仓库内直接改母模板。
