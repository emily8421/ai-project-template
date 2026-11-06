# 跨 CLI 同步过渡期提示词（Codex 等非 Claude CLI）

> Sync notice: 本文件为模板仓维护者文档，`template-docs/maintainer/` 不在同步清单（不下行），仅在模板仓存在。
> 用途：派生仓尚未同步到 v1.77.1 时，给在派生仓执行下行同步的非 Claude CLI（如 OpenAI Codex）提供一段开场提示词，避免重复踩已知的跨 CLI 坑。

## 背景

2026-11-03 zhiyan 派生仓 Codex 会话执行下行同步，暴露两类摩擦（详见 pitfall `2026-11-03-codex-derived-sync-rule-friction`）：

1. Codex 按「模板维护 / 规则改造」路由读取 `MAINTAINERS.md`（派生仓本无此文件，v1.70.0 起不下行），撞 `os error 2` 后按「失败即停」误停。
2. 同步需联网 + 写 `.git`，Codex 在只读沙箱直接执行，撞 `.git/FETCH_HEAD: Permission denied` 后才申请放行。

**v1.77.1 已在规则内补上这两处提醒**（`ai/index.md` 路由表标注 `MAINTAINERS.md` 仅模板仓存在；`ai/prompts/maintainers/12-sync-template.md`「使用前准备」补非沙箱前置声明；`ai/rules-core.md` §4 沙箱分流前置化）。但派生仓在同步到 v1.77.1 之前，本地规则仍是旧版，Codex 仍会复现上述摩擦。

## 有效期

本提示词仅用于**过渡期**：某派生仓同步到 v1.77.1 后，第 1、2 条提醒已内置于旧规则文件，不再需要手工粘贴（第 3~5 条为旧规则既有行为，可保留）。

## 使用方法

- 在派生仓新建 Codex 会话时，把下方提示词粘贴到任务开头；或
- 把完整版存到该派生仓的 `.ai/` 目录作本地备忘（本地文件，不入库、不随同步覆盖），每次会话引用。

## 完整版（直接复制）

```text
本次任务：派生项目模板方法下行同步（同步到 ai-project-template 最新版）。

执行前请先确认并遵守以下几点，避免无效往返：

1. 路由：按「派生项目下行同步」路径执行——读 ai/prompts/maintainers/12-sync-template.md 全文、
   git-guide.md §5、ai/session-rules.md §3.3/§3.4、ai/rules-core.md。
   不要读 MAINTAINERS.md：它是模板维护者手册，v1.70.0 起不下行，派生项目里本就没有这个文件。
   查询或读取它报「文件不存在 / os error 2」是预期结果、不是错误，直接跳过继续。

2. 环境：同步需要联网（git fetch 上游模板）并写 .git（git checkout FETCH_HEAD、同步提交）。
   请在非沙箱环境执行（Codex 可设 workspace-write + network_access，或逐命令批准网络与写入）。
   如果当前是只读沙箱，先停下告诉我并申请提权，不要直接跑然后撞
   .git/FETCH_HEAD: Permission denied 卡在半路。

3. 失败即停：命令失败、超时、权限不足、sandbox/network 错误时，停止并说明错误类别，不要自动连续重试。

4. 编码：Windows 下读中文规则若出现乱码但退出码为 0，判定为编码显示问题，用 UTF-8 显式重读，
   不要把乱码当文件损坏或规则缺失。

5. 授权：若流程要求更新同步脚本或创建 bootstrap 提交，先说明影响并等我确认，不要自行提交。
```

## 精简版（粘不动长文时用）

```text
本次做派生项目模板下行同步。请遵守：
1) 按「下行同步」路由读规则，不要读 MAINTAINERS.md（派生仓本就没有，报文件不存在属预期，跳过继续）；
2) 同步要联网 + 写 .git，必须在非沙箱执行，受限就先申请提权，别撞 Permission denied 后卡住；
3) 命令失败 / 权限 / sandbox 错误即停汇报，不自动重试。
```

## 坑点对照

| 提示词条目 | 对应现象 | 根因 |
|---|---|---|
| 1 路由 | `rg MAINTAINERS.md → os error 2` → 误停 | 路由表未标注该文件仅模板仓存在（v1.77.1 已修） |
| 2 环境 | `sync-template.sh --dry-run → .git/FETCH_HEAD: Permission denied` | 沙箱拦截 `.git` 写入 / 联网（v1.77.1 已补前置声明） |
| 3 失败即停 | 连环重试风险 | 旧规则既有行为，保留 |
| 4 编码 | 中文规则乱码（退出码 0） | Windows 编码显示问题，用 UTF-8 重读 |
| 5 授权 | bootstrap 前询问脚本更新 / 提交 | 高风险单步确认，正确行为，保留 |

## 维护者备注

- 本文件**不登记** `template-sync.json`（`template-docs/maintainer/` 不下行），随模板仓文档入库。
- 全部派生仓同步到 v1.77.1 后，本文件可评估删除或归档（届时过渡期结束）。
