# TEMPLATE-UPGRADE: INIT-PROMPT 简化为指针

> 状态：草案（待维护者评审）
> 提案目标版本：v1.22.2
> 提出日期：2026-07-01
> 维护分支：`change/simplify-init-prompt`

## 1. 动机

`INIT-PROMPT.md` 的「场景→快捷命令→Prompt 文件→目的」17 行映射表与 `SOP.md` 场景索引同构重复。v1.19.0 引入 commands + v1.22.0 引入 scenario-guides 后，其索引作用已被 SOP 场景索引 / commands-README / prompts-README 完全替代，无独特价值。

## 2. 拟改

- `INIT-PROMPT.md` 简化为指针（指向 scenario-guides / SOP 场景索引 / commands-README / prompts-README），删 17 行表。
- `scripts/check-template.sh`：INIT-PROMPT 的 3 个内容断言（`Prompt Library` / `01-review-inputs` / `00-generate-or-complete-docs`）改查 SOP 场景索引（已含）；保留 `require_file INIT-PROMPT.md` 与「指向 commands-README」断言。
- 引用 INIT-PROMPT 的 ~13 处**不改**（文件保留为指针，向下兼容；现有引用仍有效）。
- `VERSION` → v1.22.2 + `CHANGELOG`。

## 3. 非目标

- 不删 `INIT-PROMPT.md`（保留指针，避免 ~13 处引用断裂 + 派生项目向下兼容）。
- 不迁移引用（指针版让现有引用仍有效；长期若指针文件多余，再走删除提案）。

## 4. 影响

`INIT-PROMPT.md` / `scripts/check-template.sh` / `VERSION` / `CHANGELOG.md`；提案归档。
