# 派生项目登记（维护者侧）

> 本目录是 ai-project-template **维护者侧**的可选派生项目谱系索引，**不进入 `template-sync.json`，不下行同步**到派生项目。

## 定位

- **项目内谱系以 `TEMPLATE-BASE.md` 为准**：每个派生项目自己记录「我从哪里来、当前同步到哪个上游版本」。
- **本 registry 只做索引**：记录项目名、简介、仓库、上游、版本、最近同步等，不替代项目内事实。
- **默认不下行同步**：registry 是维护者私有 / 治理记录，不应进入派生项目。
- **可选登记**：登记是留痕，不是使用模板的前置条件；团队其他使用者可选登记。
- **模板仓发起同步时优先读取**：维护者在 `ai-project-template` 模板仓目录下触发“同步至派生项目 / 同步 N 个派生”时，AI 应先读取本目录 `registry.md` 解析目标、别名、本地路径和同步模式，再进入各派生项目执行 A13 同步闭环；不得先全盘递归找目录，除非 registry 缺失或记录不完整。

## 为什么需要

派生是单向继承（派生项目 `TEMPLATE-BASE.md` 记录母模板来源，但母模板不记录派生项目）。维护者同时维护多个派生项目时，缺少一个轻量索引会导致遗漏（例如某派生项目直到人工指出才被发现）。本 registry 补这个缺口。

来源：`_proposals/TEMPLATE-UPGRADE-project-registry-and-web-app-runway.md` 提案 A（C-001 落定：`ai-records/project-registry/`，与 `ai-records/token-hotspots/` 同区，不入同步清单）。

## 字段

| 字段 | 说明 |
|---|---|
| Project name | 项目名 |
| Aliases | 常用简称 / 用户说法，如 `LUMEN`、`zhiyan`，用于从自然语言目标解析到登记项 |
| Project type | ordinary project / domain template / domain-derived project |
| Repo URL | 仓库地址 |
| Short description | 项目简介 |
| Upstream template | 直接上游：`ai-project-template` 或某领域模板 |
| Sync mode | 同步模式：普通派生 `--preserve-project-version`；领域模板 `--domain-template`；旧项目可标 legacy / pending |
| Local path | 维护者本机仓库路径，用于从模板仓发起同步时定位项目；可为空或写 `missing` |
| Path status | `verified` / `missing` / `stale-risk` / `not-local`；路径缺失或 stale-risk 时，AI 必须先停下列待确认项 |
| Inherited version | 当前同步到的模板版本（读派生项目 `TEMPLATE-BASE.md`） |
| Own version | 项目 / 领域模板自身版本（读派生项目 `VERSION`） |
| Last sync date | 最近同步日期 |
| Status | active / paused / archived / experiment |
| Notes | 回流提案、风险、特殊同步说明 |

登记表见 `registry.md`。版本字段是 point-in-time 快照，live 以各项目 `VERSION` + `TEMPLATE-BASE.md` 为准。

## 模板仓发起下行同步

当用户在模板仓目录下要求同步派生项目时：

1. 先读取 `ai-records/project-registry/README.md` 和 `ai-records/project-registry/registry.md`。
2. 用 `Project name` + `Aliases` 解析用户给出的目标；用户说“全部 / 4 派生”时默认筛选 `Status=active` 且 `Path status=verified` 的项目，并列出 missing / stale-risk 项等待确认。
3. 对每个目标路径做只读预检：路径存在、是 git 仓、工作区干净、`TEMPLATE-BASE.md` lineage 与 `Sync mode` 不冲突。
4. 输出逐项目同步计划；写入前仍按 A13 规则等待确认。
5. 同步完成后，只把 registry 的 point-in-time 字段（Inherited / Own ver / Last sync / Notes / Path status）作为维护者索引更新；同步事实以派生仓库提交、PR、`TEMPLATE-BASE.md` 和同步运行记录为准。

如果团队不希望把本机绝对路径入库，可在 registry 中保留 `Local path=missing`，并另用 gitignored 的 `.ai/project-registry.local.md` / `.ai/project-paths.json` 维护本机路径；但 AI 仍必须先读取 registry，不能跳过目标解析。
