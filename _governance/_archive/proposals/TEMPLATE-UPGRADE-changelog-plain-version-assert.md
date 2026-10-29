# TEMPLATE-UPGRADE：check-template.sh 补 CHANGELOG-PLAIN ↔ VERSION 同步断言

> 来源：模板维护者（2026-09-10 会话发现；v1.74.0 发版实证）
> 状态：已确认，随本提案 PR 实施
> 目标版本：无版本递增（check-template.* 为模板仓专用脚本、不在 template-sync.json 下行清单；按「版本是发布边界，不是提案数量边界」口径，不触发 PATCH/MINOR/MAJOR，CHANGELOG.md 不新增版本段）

## 1. 动机（实证）

- v1.74.0 发版（PR #455）只更新了 CHANGELOG.md，漏写 CHANGELOG-PLAIN.md 的 v1.74.0 条目（PLAIN 最新版本段停留在 v1.73.0），两份 changelog 失同步；由维护者人工发现，PR #457 补齐内容。
- 根因：`scripts/check-template.sh` `require_changelog_current_version()` 的两条断言（包含当前 VERSION / 最新版本在顶部）只覆盖 CHANGELOG.md；CHANGELOG-PLAIN.md 仅有结构性断言（Sync notice、定位说明），无版本同步断言，CI 无法拦截该类漏写。

## 2. 拟改

| 文件 | 变更 |
|---|---|
| `scripts/check-template.sh` | `require_changelog_current_version()` 改为对 `CHANGELOG.md` + `CHANGELOG-PLAIN.md` 双文件循环，每文件两条断言：① `^## v{VERSION}（` 包含当前 VERSION；② 首个三段式版本标题 == 当前 VERSION（顶部判定）。断言总数 2 → 4，全量自检计数 2112 → 2114 |

`check-template.ps1` 不动（薄包装优先调 Git Bash；其原生 fallback 仅覆盖存在性 / 格式类守卫，与内容断言分工明确）。

## 3. 明确不做（范围裁决）

- 不给 CHANGELOG-PLAIN.md 加降序排列断言（`require_changelog_semver_desc` 维持 CHANGELOG.md-only）：本次失败类别是「版本同步滞后」，排序属低价值高约束。
- 不递增版本、不动 CHANGELOG.md：见头部「目标版本」。

## 4. 与既有规则 / 机制关系（去重）

- v1.72.2（issue #433，PR #434 改 sync-template.*）：sync 侧对**派生仓** CHANGELOG-PLAIN 双版本结构的改写提示启发式——对象是派生仓文件形态；本提案是**母仓 CI** 对自身两份 changelog 与 VERSION 一致性的发版门禁，方向互补不重叠。
- 既有结构性断言（`check-template.sh` 921-923 行区域：Sync notice / 定位说明）管「PLAIN 文件结构完整」；本提案管「PLAIN 与 VERSION 同步」，断言维度不同。

## 5. 验证

- 正向：全量自检非沙箱直跑 2114 项 / 0 失败。
- 负向（fail-closed 实证）：临时将 PLAIN 顶部版本标题篡改为不存在版本 → 断言红 → `git checkout -- CHANGELOG-PLAIN.md` 还原 → 复跑绿。
- CI Template Check 兜底。

## 6. 影响与风险

- 母仓 CI 门禁增强，对派生项目零影响（脚本不下行）。
- 风险：无（断言模式与 CHANGELOG.md 既有断言逐字同构，仅循环体扩到第二文件）。

## 处理记录

- 2026-09-10：起草并同会话实施（PR 见归档记录）；验证见 §5。
