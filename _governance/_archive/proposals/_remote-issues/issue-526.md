# GitHub Issue #526: TEMPLATE-UPGRADE：下行同步预检的 `git fetch` 写入边界措辞

> Source URL: https://github.com/emily8421/ai-project-template/issues/526
> State: OPEN
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-11-07T09:51:40Z
> Updated: 2026-11-07T10:54:29Z
> Mirrored at: 2026-11-09
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：下行同步预检的 `git fetch` 写入边界措辞

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流
> 状态：已提交模板仓 issue #526（2026-11-07）；待模板维护者评审，未创建 PR
> 版本影响：候选 PATCH；只修正既有同步 Prompt 的文字，不变更脚本、同步清单或安全门禁
> 证据范围：模板仓 `main` 本地及远端同为 `6a8f294`，issue #195 / #503 只读核对（2026-11-07）；不声称已在沙箱重新执行同步

## 1. 动机

模板 v1.77.1 已解决主要跨 CLI 摩擦：`ai/index.md` 明确 `MAINTAINERS.md` 仅模板仓存在；`ai/prompts/maintainers/12-sync-template.md` 的“使用前准备”已明确同步需要联网及写 `.git`；`ai/rules-core.md` §4 已补执行前权限分流。脚本不一致时，`scripts/sync-template.sh` 也有明确的 bootstrap 门禁。因此不再建议新增完整故障分流表。

仅发现一处本模板内部措辞不一致：`ai/prompts/maintainers/12-sync-template.md` 的“预检两阶段契约”把含 `git fetch origin` 的阶段统称为“只读预检”，并将命令写作 `git fetch origin（只读，不改工作区）`。`fetch` 虽不改工作区文件，却会更新 `.git` 中的对象、引用或 `FETCH_HEAD`，需要网络和 Git 元数据写入权限。受限环境的执行者可能据此把该命令误当成纯只读探测，在获得授权前执行并撞权限门禁。

## 1.1 与既有规则的关系（去重）

| 既有依据 | 已解决内容 | 本提案剩余范围 |
|---|---|---|
| 模板 v1.77.1 #523 与跨 CLI 过渡期 #525 | 路由标注、非沙箱前置提示、临时提示词 | **不重复**角色声明、权限门禁及过渡期文档；仅消除同一 Prompt 内的“只读”歧义 |
| `ai/rules-core.md` §4、`ai/session-rules.md` §3.3 | 权限分流、失败即停 | **合并入已有执行口径**，不加新规则、不要求默认全局关闭沙箱 |
| `scripts/sync-template.sh` 自身更新保护 | 提示先 bootstrap，再 dry-run | **不改**脚本、门禁或同步流程 |
| 模板 issue #195（已关闭，评论指向 #205） | 沙箱下远端操作与失败重试治理 | **对象不同**：只修正派生同步预检时的 Git 状态描述，不扩写远端 SOP |
| 模板 issue #503（已随 v1.76.1 PR #508 落地） | 新增派生仓 origin 新鲜度核验，同时把该阶段称为“只读预检” | **措辞校正**：不撤销其新增的检查，仅澄清 fetch 写 `.git` 的执行权限；保留既有 A/B 阶段语义 |
| 旧草稿 `TEMPLATE-UPGRADE-codex-sync-failure-routing.md` | 验证前拟补一整套三分流 | **收缩替代**：原 P1 已覆盖，原草稿标记“不提交”；大补丁工具故障无最小复现，本轮不立项 |

## 2. 拟改

目标为模板仓 `ai/prompts/maintainers/12-sync-template.md` 的“预检两阶段契约”，以及 `ai/commands/sync-methodology.md` 中引用该契约的“只读预检”镜像；模板仓发起模式同一称呼也应核对：

- 将“只读预检”限定为**不改工作区内容的事实核对**；若包含 `git fetch`，须直说会联网并写 `.git`，执行前按现有“使用前准备”获得相应权限。
- 把 `git fetch origin（只读，不改工作区）` 改为等价而不误导的文字，例如 `git fetch origin（不改工作区文件，但会联网并写入 .git；先核对权限）`。
- 不重复整段非沙箱执行说明；若维护者判定其他段落已足够清楚，可只修正括号里的三个字“只读”。

本提案是**措辞修正**，不是要求跳过 origin 新鲜度检查、重新设计预检顺序或允许运行在无权限环境。PowerShell 动态补丁解析失败没有明确底层根因，不纳入本轮改动。

## 3. 影响面、版本与风险

- 预期修改同步覆盖 Prompt 与命令镜像的少量文字；新文案随下一次正常同步下行。建议 PATCH，最终版本等级由模板维护者根据实际 diff 判定。
- 不改变派生项目业务文件、脚本行为、`VERSION` 解释或双阶段检查范围。只澄清“只读工作区”和“写 Git 元数据”的区别。
- 若模板仓当前分支已另行修复该文字，应直接标记重复，不创建新 PR；上行前不得把本地跟踪快照当实时远端事实。

## 4. 验证方式

1. 在模板仓当前主线重新核对目标文字及 #523/#525：如歧义已消失则结束，不实施修订。
2. 检索同步 Prompt 与 `ai/commands/sync-methodology.md` 镜像中的“只读预检 / 只读，不改工作区”；应用后应均明确 `git fetch` 需要网络及 `.git` 写权限，而 `git status` 等纯检查仍可单独只读进行。
3. 检查 `template-sync.json` 和同步脚本未改，`MAINTAINERS.md` 仍未进入 `files_all` / `files_ordinary` / `files_domain`。
4. 模板仓运行适用的文档卫生及自检；发布前按维护者流程评审版本影响。任何 issue 创建、push、PR、合并或 release 分别确认。

## 5. 待裁决

确认这一处措辞是否值得单独上行：若维护者更倾向将其并入近期文档整理，可把本文作为留痕材料而不另开 issue。其他原有问题已处理，不应以本提案重新立项。
