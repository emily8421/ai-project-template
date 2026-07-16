# 派生项目登记表

> 维护者侧索引，**不下行同步**。版本字段是 point-in-time 快照，live 以各项目 `VERSION` + `TEMPLATE-BASE.md` 为准。更新：2026-07-16。

| Project | Type | Repo | Upstream | Inherited | Own ver | Last sync | Status | Notes |
|---|---|---|---|---|---|---|---|---|
| digital-cs-demo | ordinary | emily8421/digital-cs-demo | ai-project-template | v1.30.4（无 TEMPLATE-BASE） | v1.30.4 | 2026-06-28 | paused | 落后 ~24 版本，大工程暂缓（需 bootstrap 旧 sync 脚本）；主派生 / 提案回流源 |
| zhiyan-digital-cs-platform | ordinary | emily8421/zhiyan-digital-cs-platform | ai-project-template | v1.54.0 | v0.3.0 | 2026-07-16 | active | 版本机制已启用；2026-07-16 同步（PR zhiyan#50） |
| agent-system-template | domain template | emily8421/agent-system-template | ai-project-template | v1.54.0 | v0.1.0 | 2026-07-16 | active | 领域模板（agent 系统）；domain 版本保留；多级同步待 inheritance Batch 3（PR agent-system#5） |
| LUMEN-DEMO | ordinary | emily8421/LUMEN-DEMO | ai-project-template | v1.51.0 | v1.47.1 | 待补 | active | 落后 ~3 版本；⚠️ Own ver 数字低于 Inherited，疑似未重置项目自有 v0.x，同步时留意版本一致性校验 |
