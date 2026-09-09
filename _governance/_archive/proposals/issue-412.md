# GitHub Issue #412: TEMPLATE-UPGRADE：sync dry-run 输出 token 两入口不一致 + SOP 缺变更清单提取模式（sync output token alignment）

> Source URL: https://github.com/emily8421/ai-project-template/issues/412
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-08-27T04:20:59Z
> Updated: 2026-08-27T04:20:59Z
> Mirrored at: 2026-08-27
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流
> 状态：待提交（本地草案）
> 实证场景：2026-08-27 v1.70.0 下行同步（Windows Git Bash 入口 + PowerShell 包装）

# TEMPLATE-UPGRADE：sync dry-run 输出 token 两入口不一致 + SOP 缺变更清单提取模式（sync output token alignment）

## 1. 动机（去项目化）

派生项目执行模板下行同步时，`ai/prompts/maintainers/12-sync-template.md` 步骤 8-9 建议大同步「重定向日志 + grep 摘要而非完整输出」，但存在两个衔接缺口：

1. `scripts/sync-template.sh` dry-run 输出中文 token（`Δ`、`跳过`），而 `sync-template.ps1` fallback 输出英文 token（`delta`、`skip`）；同一脚本家族输出不可互换 grep，且没有文档说明。
2. SOP 步骤 9 缺少「变更文件清单」提取模式；执行者按英文 token grep `.sh` 输出会得到零命中，需人工换 token 重提取。

风险是大同步中可能放弃清单核对，或反复试错；`.sh` 的风险路径 grep 还会命中未变更 README 行。

## 2. 拟改

推荐方向 A：

- 统一 `scripts/sync-template.sh` 的逐文件状态 token 为 ASCII，向 `.ps1` 对齐：`Δ`→`delta`、`跳过`→`skip`、`（无差异）`→`(no diff)`；中文人读信息保留在节标题。
- `12-sync-template.md` 步骤 9 增加变更清单提取：`grep -E '^[[:space:]]+(delta|skip) ' sync.log`，并注明历史 `.sh` 中文 token 日志按旧 token 读取。

备选 B：脚本不动，仅在 SOP 支持中英 token 双模式；缺点是两入口长期不一致。

## 3. 版本影响

模板 PATCH：脚本输出措辞和 SOP grep 模式补充；无同步清单路径或断言语义变更，派生项目零迁移成本。

## 4. 与既有规则的关系（去重）

- `git-guide.md` §5.8 管 Git 层输出噪音，本提案管同步脚本 token 可 grep 性。
- `session-rules` §4.1 管成功长输出摘要，本提案让 sync 大日志场景可机械执行。
- `12-sync-template.md` 步骤 8 既有重定向日志建议，本提案补步骤 9 与实际输出的匹配。
- Windows UTF-8 读取规则管文件内容读取；本提案将机器 grep 面收敛到 ASCII。

## 5. 影响面

- 修改：`scripts/sync-template.sh`（约 3-5 处逐文件状态输出）和 `ai/prompts/maintainers/12-sync-template.md` 步骤 9。
- 不改：`sync-template.ps1`、同步清单、`check-derived-sync`、CRLF 处理、版本治理。
- 维护者需核对 `check-template.sh` 是否有 dry-run 输出 token 断言。

## 6. 验证方式

- `bash -n`、一次 dry-run 实跑、完整 check-template；若触及则跑三形态 new-project smoke。
