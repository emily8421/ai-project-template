# TEMPLATE-UPGRADE: 母模板 changelog 继承参考下发（upstream/ 映射）

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流（GitHub issue #273，本地镜像 `_proposals/_remote-issues/issue-273.md`）；本提案是 #273 拆分落地的**第二批（Batch 2 / P1 upstream/ 继承参考）**
> 状态：候选 · 待维护者确认；**映射机制方案待定（见 §5），确认前不进入实现**
> 目标版本：v1.58.0（minor）
> Release impact：minor（AI 建议，待维护者确认；新增 `upstream/` 同步结构与路径映射，改变下行同步行为）
> Release strategy：在 `TEMPLATE-UPGRADE-derived-changelog-ownership.md`（Batch 1，归属修复）之后发布；本批提供母模板 changelog 的继承参考可见性，**完整关闭 #273**

## 1. 背景

Batch 1（`TEMPLATE-UPGRADE-derived-changelog-ownership.md`）让派生项目完全拥有自己的 changelog 对（正式 + 大白话），母模板不再覆盖派生根 changelog。但派生项目随之**失去对母模板自身演进的可见性**：

- 此前派生根 `CHANGELOG-PLAIN.md`（虽位置错误）至少携带了母模板的大白话 changelog；Batch 1 后该位置归派生自有，母模板内容不再下发到根。
- 母模板正式 `CHANGELOG.md` 在派生保留路径下本就被过滤、**从未下发**。
- 派生项目仅靠 `TEMPLATE-BASE.md` 记录的基线版本，看不到母模板“这版到底改了啥”。

本批目标：把母模板 changelog 对以**继承参考**形式下发到派生项目的 `upstream/`，与派生项目自有 changelog 物理分离、命名不冲突，并满足「每份 changelog 都配大白话版」。

## 2. 目标

1. 母模板 changelog 对（`CHANGELOG.md` + `CHANGELOG-PLAIN.md`）以继承参考下发到派生项目 `upstream/`。
2. `upstream/` 只存在于派生项目；**母模板仓不维护 `upstream/` 物理副本**，避免双写漂移。
3. `upstream/` 顶部有定位说明：本目录是继承自母模板的只读参考件，记录母模板自身演进；派生项目自有版本以根 `VERSION` / `CHANGELOG.md` / `TEMPLATE-BASE.md` 为准。
4. 自检断言覆盖 `upstream/` 路径存在、定位说明、正式 + 大白话配对完整性。

## 3. 非目标

- 不改两层主同步路径语义、不改 `git-guide.md` §5 主路径。
- 不改 `VERSION` / `TEMPLATE-BASE.md` / 派生根 changelog 的归属与保留（Batch 1 已定）。
- 不要求 `upstream/` 内容与母模板实时一致（同步时点刷新即可）。
- 不绑定具体领域。

## 4. 拟改（Batch 2）

| 文件 | 改动 |
|---|---|
| `scripts/sync-template.sh` / `.ps1` | 派生保留路径下，把母模板根 `CHANGELOG.md` / `CHANGELOG-PLAIN.md` 映射下发到派生 `upstream/CHANGELOG.md` / `upstream/CHANGELOG-PLAIN.md`（路径映射，非同名复制）。 |
| `template-sync.json` | 视映射机制方案（§5）：若扩 schema 支持 `{src,dest}`，则登记映射；若脚本硬编码特例，则不改本文件结构（仅注释说明）。 |
| `upstream/` 定位说明 | 同步时在 `upstream/` 顶部写入只读参考件定位说明（由脚本生成，不在模板仓维护物理副本）。 |
| `scripts/check-derived-sync.sh` / `.ps1` | 新增断言：派生项目 `upstream/CHANGELOG.md` + `upstream/CHANGELOG-PLAIN.md` 存在、含定位说明、正式 + 大白话配对完整。**断言落派生边界检查器 `check-derived-sync.*`，不落模板自检 `check-template.*`**（`upstream/` 只存在于派生项目）。 |
| `template-docs/domain-templates.md` / `template-methodology.md` / `beginner-guide.md` | 补 `upstream/` 继承参考约定与“只读、不编辑、同步时刷新”说明。 |

## 5. 映射机制（待定，落地前必须确认）

当前 `template-sync.json` 是扁平同名路径清单（`files:[...]`，无 `src→dest`），脚本按同名路径下发，**无法直接表达“母模板根 `CHANGELOG.md` → 派生 `upstream/CHANGELOG.md`”**。两个候选方案：

1. **脚本硬编码特例（低风险，推荐起点）**：在 `sync-template.*` 派生保留路径里，对 changelog 对做特殊映射，不扩 `template-sync.json` schema。优点：改动小、不影响现有同名复制语义；缺点：映射规则散在脚本里。
2. **扩展 `template-sync.json` schema 为 `{src,dest}` 映射对象**：更通用，可支撑未来其他重映射需求；缺点：schema 不兼容变化，需同步改两端脚本解析 + 兜底 + 自检，工作量与回归面更大。

> 建议先以方案 1 落地（与 Batch 1 同属“保留 / 映射”补丁族，风险可控）；若后续出现更多重映射需求，再升级到方案 2。**本项确认前不进入实现。**

## 6. 双写漂移防护（关键约束）

- **母模板仓不创建 `upstream/` 目录或 `upstream/CHANGELOG*.md` 物理文件**；`upstream/` 内容由同步脚本在派生项目侧、同步时点从母模板根 changelog 映射生成。
- 若任何环节出现物理副本，必须配一致性断言（hash / 版本对齐），否则两份真理源会漂移。
- `upstream/` 在派生项目标注为只读继承参考，派生维护者不应直接编辑（下次同步会被覆盖）。

## 7. 影响面与版本

- **Release impact：minor**——新增 `upstream/` 同步结构与路径映射，改变下行同步行为（派生项目同步后会观察到新增 `upstream/`）；属“新增同步范围结构目录”。
- **目标版本**：v1.58.0。
- **前置依赖**：Batch 1（`TEMPLATE-UPGRADE-derived-changelog-ownership.md`）已落地。Batch 2 在 Batch 1 之上叠加映射，不改 Batch 1 已定的归属与保留。
- **两份 changelog 下发性质不同**：`CHANGELOG-PLAIN.md` 是从派生根**搬迁**到 `upstream/`（Batch 1 停止根覆盖后，参考件改放 upstream/）；`CHANGELOG.md` 是**首次下发**到派生（此前保留路径下从未下发）——属新增能力，本批显式提供。

## 8. 验收

- 派生项目同步后：`upstream/CHANGELOG.md` + `upstream/CHANGELOG-PLAIN.md` 存在、为母模板继承参考、含定位说明、正式 + 大白话配对完整。
- 母模板仓**不含** `upstream/` 物理副本（仓库结构核查 / 断言）。
- 派生根 `CHANGELOG.md` + `CHANGELOG-PLAIN.md` 仍归项目自有（Batch 1 行为不退化）。
- `check-derived-sync.*` 新断言全过；`check-template.*` 全过。

## 9. 衔接

- 本批合并后，issue #273 **完整关闭**（归属修复 Batch 1 + 继承参考 Batch 2）。
- 派生项目（含 agent-system-template）此后同时拥有：自有 changelog 对（根）+ 母模板继承参考对（`upstream/`），清晰分离。
