# TEMPLATE-UPGRADE: 派生项目 changelog 归属修复（CHANGELOG-PLAIN.md 保留 + 自有初始化）

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流（GitHub issue #273，本地镜像 `_proposals/_remote-issues/issue-273.md`）；本提案是 #273 拆分落地的**第一批（Batch 1 / P0 归属修复）**
> 状态：已处理 · v1.57.4 吸收（Batch 1 / P0 归属修复）
> 目标版本：v1.57.4（patch）
> Release impact：patch（AI 建议，待维护者确认；扩展已有保留过滤、修正文案、补项目自有初始化与迁移提示，不新增同步结构）
> Release strategy：单独先行发布；与 `TEMPLATE-UPGRADE-upstream-inheritance-reference.md`（Batch 2，upstream/ 继承参考，minor）分批；本批先关闭“派生项目无法拥有自有大白话 changelog”的归属 bug

## 1. 背景

母模板 v1.46.0 / v1.53.0 让派生项目（普通 + 领域）拥有自有版本治理：项目版本放 `VERSION`，继承的母模板版本放 `TEMPLATE-BASE.md`；v1.47.0（C-004）让领域模板保留自身 `VERSION` / `CHANGELOG.md`。但**大白话版 changelog 没有同步归属**：

- 权威同步清单 `template-sync.json`（`:5-7`）同时含 `VERSION` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md`。
- 版本保留过滤只剔除 `VERSION` + `CHANGELOG.md`，不含 `CHANGELOG-PLAIN.md`：
  - `scripts/sync-template.ps1` `Remove-ProjectVersionFiles`（`@215-219`，过滤条件 `$_ -ne "VERSION" -and $_ -ne "CHANGELOG.md"`）；
  - `scripts/sync-template.sh` 保留 case（`@262-275`，`VERSION|CHANGELOG.md)`）。
- 因此派生项目根 `CHANGELOG-PLAIN.md` 每次同步被母模板覆盖，**派生项目无法拥有自己的大白话 changelog**。
- 与之对称的 `CHANGELOG.md` 受保留保护、不被覆盖——形成非对称缺陷。
- `scripts/new-project.sh` 新建派生项目时初始化项目自有 `VERSION`（v0.1.0）、`CHANGELOG.md`，**但不初始化项目自有 `CHANGELOG-PLAIN.md`**；派生根的 `CHANGELOG-PLAIN.md` 仍是母模板内容（经 `git archive` / `clone` 带入），正是被覆盖问题的源头之一。
- `CHANGELOG-PLAIN.md:6` 自称「本文是 `CHANGELOG.md` 的大白话同步版」——在母模板仓成立，但下发到派生项目后误导：派生项目的 `CHANGELOG.md` 是它自己的 v0.x，而 `CHANGELOG-PLAIN.md` 是母模板的 v1.57.x，两者版本空间不同。

本批目标是**先修复归属错误**，让派生项目完全拥有自己的 changelog 对（正式 + 大白话），不引入新同步结构（`upstream/` 继承参考属 Batch 2）。

## 2. 目标

1. 派生项目（普通 + 领域）根 `CHANGELOG-PLAIN.md` 归项目自有，不再被母模板同步覆盖。
2. 新建派生项目时初始化项目自有的 `CHANGELOG-PLAIN.md`（与 `CHANGELOG.md` 成 v0.1.0 对）。
3. 修正 `CHANGELOG-PLAIN.md:6` 措辞，消除下发后的误导。
4. 存量派生项目根 `CHANGELOG-PLAIN.md` 仍是母模板内容时，同步脚本非阻断提示改写，不静默把母模板内容当成派生自有。
5. 自检断言覆盖“保留过滤含 `CHANGELOG-PLAIN.md`”。

## 3. 非目标

- 不新增 `upstream/` 继承参考目录或新同步路径（属 Batch 2 `TEMPLATE-UPGRADE-upstream-inheritance-reference.md`）。
- 不改两层主同步路径语义、不改 `git-guide.md` §5 主路径。
- 不改 `VERSION` / `TEMPLATE-BASE.md` 现有归属与保留机制。
- 不强制存量派生项目立即改写（仅非阻断提示）。
- 不绑定具体领域（agent 或其他）。

## 4. 拟改（Batch 1）

| 文件 | 改动 |
|---|---|
| `scripts/sync-template.ps1` | `Remove-ProjectVersionFiles`（`@215-219`）过滤条件扩展为同时剔除 `CHANGELOG-PLAIN.md`。 |
| `scripts/sync-template.sh` | 保留 case（`@262-275`）从 `VERSION\|CHANGELOG.md)` 扩展为 `VERSION\|CHANGELOG.md\|CHANGELOG-PLAIN.md)`。 |
| `scripts/new-project.sh` | 新建普通派生项目时，初始化项目自有 `CHANGELOG-PLAIN.md`（v0.1.0 大白话对，紧邻现有 `CHANGELOG.md` 初始化 `@137-145`）；领域模板路径同步覆盖。 |
| `CHANGELOG-PLAIN.md` | 第 6 行措辞改为：本文件是母模板 changelog 的大白话版，记录母模板自身演进；派生项目自有版本演进以其本地 `CHANGELOG.md` / `CHANGELOG-PLAIN.md` 为准。 |
| `scripts/sync-template.*` | 派生保留路径下，检测到根 `CHANGELOG-PLAIN.md` 仍是母模板内容时（检测机制见 §5），非阻断提示派生项目改写为自己的大白话 changelog。 |
| `scripts/check-template.sh` / `.ps1` | 新增断言：`sync-template.*` 保留过滤含 `CHANGELOG-PLAIN.md`（断言源文本，落模板自检，与既有 `--preserve-project-version` / `--domain-template` 标志断言同区）。 |
| `template-docs/domain-templates.md` / `template-methodology.md` / `beginner-guide.md` | 补“派生项目根 changelog 对（正式 + 大白话）归项目自有，不被模板同步覆盖”。 |

## 5. 存量迁移检测（C4，非阻断）

定义“根 `CHANGELOG-PLAIN.md` 仍是母模板内容”的判定方式（二选一或组合，待实现确认）：

1. **hash 比对**：派生根 `CHANGELOG-PLAIN.md` 的 `git hash-object` 等于母模板同步源 ref 的 `CHANGELOG-PLAIN.md` hash → 判定为未改写的母模板副本。
2. **版本串嗅探**：派生根 `CHANGELOG-PLAIN.md` 顶部版本号属于母模板版本空间（如 `v1.5x` / `v1.6x`）而非派生项目自身 `VERSION`（如 `v0.x`）→ 提示改写。

检测命中时仅输出非阻断提示，不中断同步、不自动改写、不把母模板内容计入派生自有版本。新项目由 `new-project.sh` 初始化自有 v0.1.0 对，不触发该提示。

> ⚠️ **§4.1 保留扩展与 C4 强耦合，不可拆**：本批一旦停止覆盖，若不同批带上 C4 提示，会把母模板内容**静默冻结**为派生自有（正是 C4 要防的）。

## 6. 影响面与版本

- **Release impact：patch**——扩展已有保留过滤、修正文案、补项目自有初始化与非阻断迁移提示；不新增同步结构、不改变非保留路径默认行为。让被错误覆盖的 `CHANGELOG-PLAIN.md` 恢复与 `CHANGELOG.md` 一致的“项目自有”归属，属兼容性修复。
- **目标版本**：v1.57.4。
- **存量派生项目**：根 `CHANGELOG-PLAIN.md` 当前是母模板内容，本批后归项目自有但**不会自动改写**；同步时给出非阻断改写提示，由派生项目维护者决定何时改写为自己的大白话 changelog。
- **与 Batch 2 的衔接**：本批关闭归属 bug；母模板 changelog 的“继承参考”可见性（`upstream/`）由 Batch 2 提供。两批之间，派生项目对母模板自身演进的可见性暂时仅依赖 `TEMPLATE-BASE.md` 记录的基线版本（可接受窗口）。

## 7. 验收

- `sync-template.* --preserve-project-version` / `--domain-template` 同步后，派生项目根 `CHANGELOG-PLAIN.md` 不被覆盖（断言 + 派生项目烟测）。
- `new-project` 烟测：新派生项目根 `CHANGELOG.md` + `CHANGELOG-PLAIN.md` 均为项目自有 v0.1.0 对。
- `CHANGELOG-PLAIN.md:6` 措辞不再误导（断言）。
- 存量派生项目同步时收到非阻断改写提示，且不自动改写、不中断同步。
- `check-template.*` 全过；新增的保留过滤断言生效。

## 8. 衔接

- 本批落地后，派生项目（含 agent-system-template 领域模板）即可补自己的 `CHANGELOG-PLAIN.md`，完成「正式 + 大白话」配对。
- 母模板 changelog 的继承参考下发（`upstream/`）见 Batch 2 `TEMPLATE-UPGRADE-upstream-inheritance-reference.md`。
- issue #273 在本批合并后**部分关闭**（归属部分）；upstream/ 继承参考部分由 Batch 2 关闭。
