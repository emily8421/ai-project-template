# TEMPLATE-UPGRADE: 跨 CLI 友好性——派生仓下行同步的非沙箱前置声明 + MAINTAINERS.md 路由标注

> 来源：模板维护者（2026-11-03 派生仓 Codex 会话下行同步暴露的跨 CLI 摩擦）
> 状态：候选
> 目标版本：待确认
> Release impact：none（本提案入库收件箱，不改 VERSION；实施时建议 patch）
> Release strategy：延后候选池（待 C1 triage；与既有沙箱分流规则同源，宜同主题聚合）

## 0. 摘要

模板规则当前对「按逐命令 ask/allow 权限模型工作」的 Claude Code 足够，但对「按字面读规则、默认沙箱受限」的非 Claude CLI（如 OpenAI Codex）有两处不够显式，导致派生仓下行同步时出现无谓的「文件不存在」误停 + 「Permission denied」往返：

1. `ai/index.md` 路由表「模板维护 / 规则改造 / 同步机制」行列了 `MAINTAINERS.md`，但未标注「仅模板仓存在、v1.70.0 起不下行」——派生仓 AI 走该路由读文件会撞 `os error 2` 并误判为规则缺口、触发「失败即停」。
2. 需非沙箱 / 联网的操作类别（下行同步、全量自检、git fetch/push/merge、gh 联网）只体现在「响应式分流」（撞到进程创建 / 权限失败再换非沙箱复核），缺「前置声明」——按字面读规则的 CLI 会先撞 `Permission denied` 再分流，多一轮往返。

## 1. 动机（去项目化）

**现象（已去项目化）**：任意派生仓、任意 CLI 执行下行同步时，都可能 (a) 误读 `MAINTAINERS.md` 为必须存在的文件，(b) 在沙箱受限环境直接跑 `git fetch` / 全量自检而撞 `Permission denied`。

**根因**：模板的沙箱要求是「响应式」的（撞到再分流），面向「逐命令 ask/allow」的 Claude Code 编写；对按字面读规则、默认沙箱受限的非 Claude CLI，缺「模板仓专用文件标注」与「需非沙箱操作类别的前置声明」。

**证据**：2026-11-03 `zhiyan-digital-cs-platform` 派生仓 Codex 会话执行下行同步——`rg MAINTAINERS.md → os error 2` 触发误停；`sync-template.sh --dry-run → .git/FETCH_HEAD: Permission denied`（获准非沙箱重跑即成功）。同源沙箱实证见 2026-09-03 B-001（Codex 沙箱拦 `check-template.sh` 进程创建）。

## 1.1 与既有规则的关系（去重）

- **`ai/rules-core.md` §4「沙箱 / 受限环境验证降级与 spawn 失败分流」**（已启用）：已有「撞到进程创建类失败 → 换非沙箱复核再定性」的响应式分流。**互补不重复**——本提案补「前置声明」：哪些操作类别需非沙箱 / 联网、动手前就申请，不改变既有分流语义。
- **`ai/rules-core.md` §2「Checkpoint Mode 触发」**（已启用）：已把「最近发生过 sandbox / 权限失败」列为进入 Checkpoint Mode 的触发。**互补不重复**——它管「失败后怎么走」，本提案管「动手前怎么声明环境要求」。
- **`ai/session-rules.md` §3.4「跨仓角色声明」**（已启用）：已说明 `MAINTAINERS.md` 为模板维护者手册、v1.70.0 起不下行。**指向**——本提案把该说明补进 `ai/index.md` 路由表（AI 路由必读入口），让它在路由时即可见，而非散落在 session-rules 深层。
- **`ai/session-rules.md` §3.1「Windows 乱码恢复」**（已启用）：已覆盖跨 CLI 的编码摩擦。**对象不同**——本提案处理的是「文件缺失」与「沙箱」，不是编码。

**本提案不重复它们**：现有规则是「响应式分流 + 深层说明」，本提案补「前置声明 + 路由表可见标注」，是同一沙箱主题的「前置化」升级。差异化：把「模板仓专用文件」和「需非沙箱操作类别」从散落说明提升为路由必读入口的显式标注。

## 2. 拟改

均为 advisory 文档级，不碰脚本 / 同步清单 / 自检断言：

1. `ai/index.md` 路由表「模板维护 / 规则改造 / 同步机制」行：`MAINTAINERS.md` 后标注 `（仅模板仓存在，v1.70.0 起不下行；派生仓下行同步不读）`。
2. `ai/rules-core.md` §4 沙箱分流条目（或 §2 Checkpoint 触发）补一句前置声明：`下行同步 / 全量自检（大量 spawn）/ git fetch·push·merge / gh 联网` 类操作需非沙箱或网络权限，沙箱受限环境应**开始前**申请非沙箱（如 Codex `workspace-write` + `network_access` 或逐命令批准），而非撞 `Permission denied` 后再分流。

## 3. 版本影响

- 本提案入库收件箱：`none`，不改 `VERSION`。
- 实施时：`patch`（文案澄清 + 治理说明补强，不改变默认行为 / 同步范围 / 门禁）。

## 4. 影响面

- `ai/index.md`、`ai/rules-core.md`：模板同步覆盖件，改动随下次下行同步到达各派生仓。
- 不触碰脚本 / 自检 / 同步清单 / 断言；对既有派生项目零破坏（纯说明性，不新增 gate）。

## 5. 验证方式

1. 文档评审：提案 PR 对照拟改清单核对（标注位置准确、不改变路由语义、不重复既有分流规则）。
2. `scripts/check-template.*` 不新增断言（advisory 语义）。
3. 可选人工验证：派生仓用 Codex 复跑一次下行同步，确认不再误读 `MAINTAINERS.md`、不再撞 `Permission denied` 往返。
