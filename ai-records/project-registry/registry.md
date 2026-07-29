# 派生项目登记表

> 维护者侧索引，**不下行同步**。版本字段是 point-in-time 快照，live 以各项目 `VERSION` + `TEMPLATE-BASE.md` 为准。更新：2026-07-29。

| Project | Aliases | Type | Repo | Upstream | Sync mode | Local path | Path status | Inherited | Own ver | Last sync | Status | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| digital-cs-demo | digital-cs, dcs | ordinary | emily8421/digital-cs-demo | ai-project-template | `--preserve-project-version` | missing | missing | v1.57.1 | v0.1.0 | 2026-07-25 | active | 主派生 / 提案回流源；版本机制已启用（PR#36 v0.1.0）；2026-07-25 同步 v1.57.1（PR#37，squash） |
| zhiyan-digital-cs-platform | zhiyan | ordinary | emily8421/zhiyan-digital-cs-platform | ai-project-template | `--preserve-project-version` | missing | missing | v1.57.1 | v0.3.0 | 2026-07-25 | active | 版本机制已启用；2026-07-25 同步 v1.57.1（PR#52，squash） |
| agent-system-template | agent-system | domain template | emily8421/agent-system-template | ai-project-template | `--domain-template` | `D:\2-Project\5-Project Templates\agent-system-template` | verified | v1.59.0 | v0.3.0 | 2026-07-29 | active | 领域模板（agent 系统）；domain 版本保留；2026-07-29 本地分支 `sync-template-v1.59.0` 已完成同步主链（bootstrap `d2162fa` / sync `68c39ef` / record `b3fe15e`），远端收尾因疑似其他 AI 并发暂停，待复核后继续；`CHANGELOG-PLAIN.md` ownership 待 post-sync-cleanup；多级同步待 inheritance Batch 3 |
| LUMEN-DEMO | LUMEN, lumen | ordinary | emily8421/LUMEN-DEMO | ai-project-template | `--preserve-project-version` | `D:\2-Project\0-Product\3-LUMEN_KnowledgeBase\LUMEN_demo_T2.1` | verified | v1.59.0 | v0.2.4 | 2026-07-29 | active | 版本机制已启用；2026-07-29 分支 `sync-template-v1.59.0` 已完成同步主链（bootstrap `914e3e0` / sync `751ccd3` / record `c6cfbd6`），PR#85 已合并到 main（squash `30b068d`）；fetch / gh 使用代理 `127.0.0.1:7897`；`CHANGELOG-PLAIN.md` ownership 待 post-sync-cleanup |
