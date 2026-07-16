# 派生项目登记（维护者侧）

> 本目录是 ai-project-template **维护者侧**的可选派生项目谱系索引，**不进入 `template-sync.json`，不下行同步**到派生项目。

## 定位

- **项目内谱系以 `TEMPLATE-BASE.md` 为准**：每个派生项目自己记录「我从哪里来、当前同步到哪个上游版本」。
- **本 registry 只做索引**：记录项目名、简介、仓库、上游、版本、最近同步等，不替代项目内事实。
- **默认不下行同步**：registry 是维护者私有 / 治理记录，不应进入派生项目。
- **可选登记**：登记是留痕，不是使用模板的前置条件；团队其他使用者可选登记。

## 为什么需要

派生是单向继承（派生项目 `TEMPLATE-BASE.md` 记录母模板来源，但母模板不记录派生项目）。维护者同时维护多个派生项目时，缺少一个轻量索引会导致遗漏（例如某派生项目直到人工指出才被发现）。本 registry 补这个缺口。

来源：`_proposals/TEMPLATE-UPGRADE-project-registry-and-web-app-runway.md` 提案 A（C-001 落定：`ai-records/project-registry/`，与 `ai-records/token-hotspots/` 同区，不入同步清单）。

## 字段

| 字段 | 说明 |
|---|---|
| Project name | 项目名 |
| Project type | ordinary project / domain template / domain-derived project |
| Repo URL | 仓库地址 |
| Short description | 项目简介 |
| Upstream template | 直接上游：`ai-project-template` 或某领域模板 |
| Inherited version | 当前同步到的模板版本（读派生项目 `TEMPLATE-BASE.md`） |
| Own version | 项目 / 领域模板自身版本（读派生项目 `VERSION`） |
| Last sync date | 最近同步日期 |
| Status | active / paused / archived / experiment |
| Notes | 回流提案、风险、特殊同步说明 |

登记表见 `registry.md`。版本字段是 point-in-time 快照，live 以各项目 `VERSION` + `TEMPLATE-BASE.md` 为准。
