# TEMPLATE-UPGRADE：SOP ↔ scenario-guides 场景码衔接（v1.23.6）

> 去项目化提案。覆盖用户诉求 #16（SOP 场景索引与 scenario-guides 各说各的）。v1.23 文档体系重构系列 PR-5b。

## 动机

`SOP.md` 场景索引（自由文本场景名）与 `scenario-guides.md` 场景（A0–A14 / C1–C7 / M1 编码）是两套并行索引：场景重叠但标签不一致、互不引用 → 各说各的、易漂移，用户无法双向跳。违背模板「单一权威源 + 互相引用」原则。

## 拟改

定位澄清（两者职责互补不重复）：
- `scenario-guides` = 场景**剧本**（「AI 带我做」：引导计划 + 做什么/为什么/机器执行）。
- `SOP` 场景索引 = **命令速查**（「我知道做啥 → 找快捷命令 / 权威文档 / Prompt」）。

- `SOP.md`：
  - 顶部加**分工声明**：SOP = 命令速查；scenario-guides = 场景剧本；**场景码对齐，互补不重复**。
  - 场景索引加**场景码列**，每行对齐 scenario-guides 的 A/C/M 码（新建派生项目→A2、同步模板→A13、采集环境→A3、处理提案→C1…）。
  - 拆「操作场景（带码 + 命令）」与「文档入口（看哪，非操作场景）」两区。
- 两边用同一套场景码 → 用户找命令看 SOP、看剧本看 scenario-guides 对应码，可双向跳。

## 版本影响

- v1.23.5 → v1.23.6（PATCH，v1.23 文档重构系列 PR-5b；从已合并 main v1.23.5 序列推进，无版本冲突）。
- 无脚本 / 同步清单 / 断言变更；check-template 全过。

## 影响面

- 同步件：`SOP.md`（派生项目下次同步获得对齐后的场景索引）。
- 不影响：规则正文、脚本、同步机制、check-template 断言（~24 SOP 锚点全保留：场景名 + 命令 + PowerShell fallback + Windows 入口等）。

## 落地流程

从 main（v1.23.5）切分支 `change/docs-restructure-pr5b-v1.23` → SOP 加分工声明 + 场景码列 + 分区 → check-template 通过 → VERSION/CHANGELOG/提案 → PR-5b。之后 PR-5（document-lifecycle-rules #12 + global-rules 去重 #13，合并为一个 ai/ 规则 PR）。
