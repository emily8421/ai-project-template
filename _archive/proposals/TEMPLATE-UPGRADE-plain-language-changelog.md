# TEMPLATE-UPGRADE: 大白话版 changelog 同步文件

> 来源：模板维护者（用户请求：将 changelog 更新说明翻译成大白话，作为同步文件）
> 状态：处理中（本分支落地，待 PR 合并后归档）
> 目标版本：v1.56.5
> Release impact：patch
> Release strategy：单独发布

## 1. 动机

`CHANGELOG.md` 是正式版本记录，信息完整但偏维护者视角。普通使用者想知道“从某个版本到现在到底优化了什么”时，需要在较长的技术条目里自行提炼。

因此新增一份与 `CHANGELOG.md` 同步的解释性 companion 文件，用大白话按版本说明每次发布的实际影响。

## 2. 拟改

| 文件 | 改动 |
|---|---|
| `CHANGELOG-PLAIN.md` | 新增根目录大白话版 changelog，同级跟随正式 `CHANGELOG.md`。 |
| `template-sync.json` | 纳入 `CHANGELOG-PLAIN.md`，让派生项目下行同步获得解释版。 |
| `scripts/sync-template.sh` | fallback 同步清单补 `CHANGELOG-PLAIN.md`。 |
| `scripts/check-template.sh` / `.ps1` | 增加存在性、Sync notice 与同步清单断言。 |
| `VERSION` / `CHANGELOG.md` | 发布 `v1.56.5` 并记录本次新增同步文件。 |

## 3. 边界

- `CHANGELOG.md` 仍是权威版本记录。
- `CHANGELOG-PLAIN.md` 只做解释，不替代版本治理、发布 checklist 或 Git 历史。
- 派生项目可读该文件理解模板版本影响，但不要求维护项目自己的大白话 changelog。
- 保持去项目化，不写入具体派生项目业务事实。

## 4. 验证

- `git diff --check`
- `bash scripts/check-template.sh`
- 对比 `CHANGELOG.md` 与 `CHANGELOG-PLAIN.md` 的版本标题，确认解释版覆盖所有正式版本条目。
