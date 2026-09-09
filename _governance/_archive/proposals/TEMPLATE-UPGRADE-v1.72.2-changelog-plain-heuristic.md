# TEMPLATE-UPGRADE: CHANGELOG-PLAIN 启发式对项目自有双版本结构误报（两段判定）

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流（GitHub issue #433，镜像 `_governance/_proposals/_remote-issues/issue-433.md`）
> 状态：已落地（PR #442，squash `4af612e`，v1.72.2）；issue #433 关闭、#412 残留吸收后关闭；2026-09-09 归档
> 目标版本：v1.72.2（PATCH）
> Release impact：patch（仅提示逻辑与文案，同步覆盖 / 保留行为零变化）
> Release strategy：单独发布（即时发布——排在 v1.72.1 派生同步窗口之前，消除双版本项目每轮同步误报）

## 1. 动机（去项目化）

`sync-template.sh` / `sync-template.ps1` 在 `--preserve-project-version` / 领域模板模式下对根 `CHANGELOG-PLAIN.md` 做存量迁移提示：当文件内容与母模板相同、或「首个 `## vX.Y.Z（` 版本标题」与本地 `VERSION` 不一致时，警告「可能仍是母模板内容，请改写为派生项目自有大白话 changelog」。

采用「项目自有双版本结构」的派生项目（顶部 `## 项目版本` 段记录项目自有版本 + 下方「模板继承历史」段保留母模板历史叙事）会持续误报：

- 项目版本段内的版本标题通常为 `### vX.Y.Z（…）`（三级），而启发式的 `first_changelog_plain_version` 只匹配 `^## v`（二级），首个命中落在模板继承历史段（母模板历史版本号），与本地项目 `VERSION` 对比必然不一致。
- 后果：每轮同步出现同一条 ⚠️ 警告；且警告指引（「请改写为自有 changelog」）对该类项目是已完成动作，按指引重做反而破坏双版本结构。

**本版已实证**（2026-09-09 triage，本地派生仓核验）：双版本派生仓的 `CHANGELOG-PLAIN.md` 项目版本段为 `### v0.3.0（…）`，启发式首个命中为继承历史段的 `## v1.56.13（…）` ≠ 本地 `VERSION v0.3.0` → 每轮同步必警告。连续 ≥2 轮同步（跨上游版本）复现，非环境偶发。

## 1.1 与既有规则的关系（去重）

- **v1.69.0「同步保留派生项目 `CHANGELOG-PLAIN.md`，不再覆盖」**（已落地）：本提案是其保留语义的**后置提示精度问题**，不改变保留行为、不新增机制——**互补不重复**。
- **`check-derived-sync.*` 的 `upstream/CHANGELOG-PLAIN.md` 断言**：管继承参考副本，不涉根 `CHANGELOG-PLAIN` 改写提示；2026-09-09 已核实其中**无同类改写提示**，无需统一口径——**对象不同**。
- **`check-template.*` 断言**（`warn_if_changelog_plain_needs_project_rewrite` / `Show-ChangelogPlainMigrationNotice` 存在性断言）：本提案保留两函数名，断言不受影响——**指向**。
- **GitHub issue #412（sync 输出 token 对齐，已随 PR #415 落地）**：其残留 `.sh` `（无差异）` vs `.ps1` `(no diff)` 措辞不一致由本提案**合并入**（同脚本家族顺手统一，关闭 #412）。

**本提案不重复它们**：只收窄「改写提示」的误触发面；双版本识别是该提示此前缺失的输入。

## 2. 拟改

### 2.1 两段判定（`sync-template.sh` + `sync-template.ps1`，逻辑对称）

1. **第一段——双版本识别**：文件含 `## 项目版本` 段时，提取**该段内首个版本标题**（`^#{2,4} vX.Y.Z（`，二级 / 三级 / 四级均可）作为项目自有版本：
   - 与本地 `VERSION` 一致 → 降级为 info：`✓ CHANGELOG-PLAIN.md 已确认为自有双版本结构，保留不动`；
   - 不一致 → 改报**版本漂移**提示（请核对版本记录），不再引导改写；
   - 段存在但未提取到版本标题 → 保守落入第二段存量判定（防漏报）。
2. **第二段——存量判定（现状保留）**：无 `## 项目版本` 段时，维持既有两条警告分支（内容与母模板相同 / 首个 `## vX.Y.Z（` 标题与本地 VERSION 不一致 → 引导改写）。

### 2.2 搭车项（吸收 #412 残留）

`sync-template.sh` 逐文件 no-diff 状态行 `（无差异）` → `(no diff)`（3 处），与 `.ps1` 输出对齐；该 token 不在 grep 提取面（步骤 9 清单提取用 `delta`/`skip`），纯人读输出一致性修正。

## 3. 版本影响

PATCH（v1.72.2）：仅提示逻辑 / 文案；同步覆盖行为、同步清单、断言语义零变化，派生项目零迁移。

## 4. 影响面

- 修改：`scripts/sync-template.sh`（启发式函数 + 3 处 no-diff token）、`scripts/sync-template.ps1`（对称改动）。
- 受益：所有采用双版本 `CHANGELOG-PLAIN.md` 的派生 / 领域项目（`--preserve-project-version` 与领域模板模式用户）。
- 新增提案文件 1 份（本文件）+ issue #433 镜像；落地后 #433 / #412 关闭、镜像随归档 PR 处置。

## 5. 验证方式

- `bash -n scripts/sync-template.sh`；PowerShell 解析检查 `.ps1`。
- fixture 四分支仿真（临时目录、不触真实仓库）：① 母模板原版（无项目版本段）→ 保持改写警告；② 双版本且段内版本 = 本地 VERSION（用真实双版本仓文件）→ ✓ info；③ 双版本但段内版本 ≠ 本地 VERSION → 版本漂移提示；④ 断言函数名保留（`warn_if_changelog_plain_needs_project_rewrite` / `Show-ChangelogPlainMigrationNotice`）。
- `bash scripts/check-template.sh --summary` 全量自检通过（非沙箱直跑）+ `git diff --check`。
- PR CI（Template Check）通过后合并；下行同步影响随下一同步窗口观察。
