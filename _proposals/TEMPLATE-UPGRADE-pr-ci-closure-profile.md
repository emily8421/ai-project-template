# TEMPLATE-UPGRADE: PR / CI 闭环速查 Profile 转正

> 来源：模板维护者；承接 `_proposals/TEMPLATE-UPGRADE-ai-coding-context-budget.md` §5.1
> 状态：处理中
> 目标版本：v1.56.6
> Release impact：patch（AI 建议，待维护者确认；把既有实验 Profile 转为同步范围内的可发现入口）
> Release strategy：单独发布

## 1. 背景

`template-docs/remote-ci-sop-profile.md` 已经存在，用于远端 / CI / PR 操作分诊，但仍标注为实验阶段，且未进入 `template-sync.json` 同步清单。实际模板维护中，PR / CI 闭环反复触发长规则读取：`CONTRIBUTING.md`、`git-guide.md`、`MAINTAINERS.md`、`SOP.md`、`ai/session-rules.md` 等经常被重复全文读取。

`ai-records/token-hotspots/SUMMARY.md` 和 `_proposals/TEMPLATE-UPGRADE-ai-coding-context-budget.md` 已指出：PR / CI 闭环是高频 token 热点，但写入确认、远端单步确认、CI pending 即停、失败日志最小化等门禁不能被削弱。

因此，本提案不新建一套并行 checklist，而是将现有 Remote / CI SOP Profile 转正为 PR / CI 闭环速查入口。

## 2. 目标

1. 让 PR / CI / Git 收尾任务先读一个短 Profile，再按需定位权威 SOP。
2. 减少每轮 PR / CI 闭环重复全文读治理文档的概率。
3. 保留远端高风险动作单步确认、失败即停、CI pending 不长等。
4. 让该 Profile 下行同步到派生项目，并用自检断言防止入口漂移。

## 3. 非目标

- 不改变 push / PR / merge / close issue / delete branch 的确认边界。
- 不新增远端自动化脚本。
- 不替代 `git-guide.md`、`SOP.md`、`MAINTAINERS.md` 或 `CONTRIBUTING.md`。
- 不自动创建 PR、不自动合并、不自动删除分支。
- 不处理 check-template 本地可用性问题；该主题另行评估。

## 4. 拟改文件

- `template-docs/remote-ci-sop-profile.md`：移除实验口径，补 PR / CI 闭环 checklist。
- `template-docs/capability-packages.md`：把 Remote / CI SOP Profile 从试点更新为已转正 Profile。
- `ai/index.md`：PR / CI / Git 收尾路由加入该 Profile。
- `ai/commands/README.md`：自然语言触发与执行流程中暴露 PR / CI 闭环入口。
- `template-sync.json`：将该 Profile 纳入下行同步。
- `scripts/sync-template.sh`：fallback 同步清单补该 Profile。
- `scripts/check-template.sh`：新增防漂移断言。
- `VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`：patch 版本记录。

## 5. 版本影响

建议 `v1.56.6`，`patch`。

理由：

- 新增下行同步范围内文档，改变派生项目可发现能力。
- 默认行为不变，不要求派生项目迁移。
- 只是把已有实验 Profile 转为正式速查入口，风险低。

## 6. 验证方式

- `git diff --check`
- `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals/TEMPLATE-UPGRADE-pr-ci-closure-profile.md template-docs/remote-ci-sop-profile.md template-docs/capability-packages.md ai/index.md ai/commands/README.md CHANGELOG.md CHANGELOG-PLAIN.md`
- `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`

若本机 Bash / WSL 不可用，则以 PowerShell fallback + 后续 CI `template-check` 兜底，明确记录未本地跑完整 Bash 自检。

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 是否把 Profile 纳入同步清单 | 建议纳入 | 不同步则派生项目新会话默认不可发现 | 继续实验阶段 | 不同步无法解决下游 PR / CI 闭环重复读问题 |
| C-002 | 是否新增独立 command | 暂不新增 | 现有任务路由和 scenario C4 已覆盖，新增 command 会扩大入口维护面 | 新增 `ai/commands/pr-ci-closure.md` | 暂不阻塞；若后续仍不可发现再评估 |
| C-003 | 是否修改远端操作确认边界 | 不修改 | 安全门禁必须保留 | 放宽确认 | 放宽会提高误操作风险，不建议 |

## 8. 验收标准

- PR / CI / Git 收尾路由能指向 `template-docs/remote-ci-sop-profile.md`。
- Profile 明确最小必读、动作前 checklist、PR 创建 / checks / merge / 清理闭环。
- Profile 进入 `template-sync.json` 和 `scripts/sync-template.sh` fallback。
- `scripts/check-template.sh` 有断言保护 Profile 入口、关键词和同步清单。
- 版本与 changelog 一致。
