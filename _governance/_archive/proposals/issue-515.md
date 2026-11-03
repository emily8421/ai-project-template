# GitHub Issue #515: TEMPLATE-UPGRADE: 结构迁移类任务补「母仓结构取证」固定预检步

> Source URL: https://github.com/emily8421/ai-project-template/issues/515
> State: OPEN
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-11-03T04:37:33Z
> Updated: 2026-11-03T04:37:33Z
> Mirrored at: 2026-11-03

# TEMPLATE-UPGRADE: 结构迁移类任务补「母仓结构取证」固定预检步

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：**草案 · 待维护者确认**（2026-11-03 起草并提交母仓）
> 目标模板版本：ai-project-template v1.76.0+（本仓同步口径）
> Release impact：预估 PATCH（流程提示文档增量，与既往审计项提案同性质；不挂自检断言、不改脚本 / 清单）
> 仓库角色：B 组 · 待上行跨领域（回流母模板）

## 1. 动机

派生仓的目录结构迁移 / 布局对齐 / 容器审计类任务需要核对母仓真实结构，但现行 SOP 没有固定的取证前置步，靠临场发挥。实证（2026-09-11 一轮结构迁移）：

- 用户三轮结构追问（三个目录的归属判断）各触发一次母仓取证，每次都要重新对照母仓结构——没有「第一次就取好证据」的固定动作。
- 其间一次**险些得出错误结论**：按 `FETCH_HEAD` 取证母仓结构，但 FETCH_HEAD 已被中途 `git pull` 覆写，实际读到的是本仓自己的 origin/main，差点误判「母仓没有某治理目录」。事后人工发现纠正，坑已记录在派生仓本地。

根因：`FETCH_HEAD` / 上次 checkout 残留对象等 git 惯用引用**不可靠**（会被任何 pull 覆写），而结构判断的取证必须显式锚定母仓 ref——这一点现行文档没有写。

## 2. 拟改

1. **`git-guide.md` §5**（同步场景 SOP）增加结构类任务前置固定步：

   > - **结构取证预检（目录迁移 / 布局对齐 / 容器审计类任务）**：动本仓目录前，先显式锚定母仓结构证据——`git ls-tree <母仓 remote>/main --name-only`（或本地模板仓路径 `git -C <模板仓> ls-tree`），并 grep 母仓 CHANGELOG 的结构条目交叉印证。**禁止以 `FETCH_HEAD`、上次 pull 残留对象或本仓 origin/main 作为母仓结构证据。**

2. **`ai/prompts/maintainers/15-post-sync-cleanup.md`**：审计清单加一条取证项引用（指向 §5 预检步口径），供审计类任务复用。

## 3. 影响与边界

- 纯流程提示增量：不改脚本、不挂断言、不引入新命令；普通与领域派生路线同适用。
- 只约束「母仓结构证据的来源」，不改变同步 / 迁移本身的行为。
- 取证成本一次一条命令，远低于错误结论导致的返工。

## 3.1 验证方式

- 文档级提案：母仓 `check-template.*` 全量自检零变化。
- 下一轮结构类任务实测按预检步执行（实证样本：本轮结构迁移的复现路径）。

## 4. 与既有规则关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `git-guide.md` §1.1 `check-github-context.ps1` 预检 | 对象不同 | 那条管远端操作上下文（repo / 分支 / 账号），本条管母仓结构证据锚定，互补 |
| `ai/session-rules.md` §3.4 跨仓角色声明 | 层级不同 | 那条管角色边界可审计，本条管取证步骤，互补 |
| 已采纳提案「post-sync-cleanup 审计清单补存量仓治理容器迁移审计项」（v1.75.2） | 对象不同、同文件落点 | 那条管存量容器的**事后审计**，本条管迁移执行的**事前取证**；两者在 `15-post-sync-cleanup.md` 相邻落位，需注意条目措辞不重叠 |
| `CONTRIBUTING.md` §5.1 操作发起目录建议 | 机制不同 | 那条管「在哪个仓发起」，本条管「证据从哪个 ref 取」 |
