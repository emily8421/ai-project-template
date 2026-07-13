# Token Hotspot Record

- Date: 2026-07-13
- Project: ai-project-template / agent-system-template (cross-repo)
- Task type: template-maintenance / domain-template-sync / cross-repo-closure / PR-ops
- Trigger: 用户要求按建议完成 `agent-system-template` 的真实领域模板 sync 验证、同步记录、README 口径修复、`docs/00-09` scaffold 边界说明，以及最后的本地分支清理与 hotspot 记录。
- Full rules loaded: **是**——本轮在 `agent-system-template` 执行写入 / PR / 审计前读取了该仓 `AGENTS.md`、`ai/index.md` 及其列出的全部规则；此前在 `ai-project-template` 也已完成规则门禁。后续同一任务链复用已加载规则，只在跨仓执行前补读目标仓规则。
- Commands / prompts used: `git status/branch/log/diff`、`git fetch/checkout/reset/commit/push`、`gh pr create/view/checks/merge`、GitHub REST / GitHub CLI 状态核对、`sync-template.ps1 --summary --domain-template`、`sync-template.ps1 --commit --domain-template`、`check-derived-sync.ps1 <sync-commit>`、`check-template.ps1` fallback、PowerShell Parser、`rg` 文档审计与记录校验。
- High-cost reads:
  - 两仓规则门禁：`ai/index.md` 路由及 6 个 `ai/*` 规则文件；跨仓执行时需额外读取 `agent-system-template` 自己的 `AGENTS.md` 与规则清单。
  - 双仓长脚本：`scripts/sync-template.sh` / `.ps1`、`scripts/check-derived-sync.*`、`scripts/check-template.*` 多轮定位、patch 与验证。
  - 目标仓同步记录模板 `template-docs/derived-sync-report-template.md` 与旧记录 `sync-records/template-sync/2026-07-11-sync-template-v1.45.6.md`，用于生成 v1.47.1 运行记录。
  - 多个 PR 状态与 checks：母模板 PR #180 / #181，领域模板 PR #1 / #2 / #3 / #4。
- Repeated reads:
  - 多次 `git status -sb` / `git log` / `gh pr view` / `gh pr checks` 确认分支、合并状态和远端分支删除。
  - 反复 `rg` 检查 `VERSION` / `CHANGELOG.md` / `TEMPLATE-BASE.md` / `Domain standards scope` / README 旧口径。
  - `agent-system-template` 同步验证先跑 v1.47.0 暴露 TODO 迁移缺口，再修母模板 v1.47.1 后重跑真实 sync。
- Avoidable reads:
  - PR 合并后的状态核对模式重复度高，可封装为一个“merge-and-verify”小流程，统一输出：merge commit、local main、remote branch gone、check status。
  - GitHub REST 与 `gh` 在私有仓可见性上来回切换；私有仓优先直接用 `gh pr view/checks` 可减少一次 404/401 探测。
  - 同步记录写入前的轻量 docs 审计可拆成固定 checklist，避免大量 `rg` 结果进入上下文。
- Useful reads:
  - `agent-system-template` 旧 `TEMPLATE-BASE.md` 真实内容直接暴露 v1.47.0 的 TODO 迁移缺口，促成母模板 PR #181 / v1.47.1。
  - `check-derived-sync.ps1 be553af` 验证了应传实际同步提交而非 squash merge commit，避免误判。
  - `README.md` 口径审计发现两个后续小修：版本治理旧口径（PR #3）与 `docs/00-09` scaffold 边界（PR #4）。
- Estimated hotspot: high（跨两仓规则门禁 + 双语言 sync 脚本修复 + 真实 sync 重跑 + 6 个 PR 创建 / 检查 / 合并 + 同步记录与轻量审计）。
- Quality impact if optimized:
  - 安全优化：把“PR 创建 / checks / merge / 删除分支 / 本地 main 同步”压缩为标准化输出；对私有仓统一走 `gh`；同步记录先填固定字段，再只读补充审计摘要。
  - 不安全优化：跳过目标仓规则门禁、跳过真实 `agent-system-template` sync、跳过 `check-derived-sync` 或跳过 README 口径回梳，都会让领域模板版本治理只停留在母模板推断，无法发现真实兼容缺口。
- Suggested optimization:
  - 新候选（H-006）：跨仓 sync 收口可建立“verify-sync-pr”脚本 / prompt，串联 `sync-template --summary`、`--commit`、`check-derived-sync <sync-commit>`、`git diff --check`、PR checks 与同步记录骨架。
  - 新候选（H-007）：PR 运维动作模板化，合并后只记录 `PR # / merge commit / check / branch deleted / local clean`，避免每轮重复散落状态查询。
  - 继续印证 H-005：Bash / PowerShell 双实现仍是高成本对称维护点；本轮 v1.47.1 迁移修复必须同时改 `.sh` 与 `.ps1` 并做专项验证。
- Privacy check: 无 token、密钥、账号密码、客户敏感数据；记录仅含公开/仓内 PR 编号、提交短 SHA、文件路径、命令类别和优化建议。

## Notes

- 本轮从母模板 PR #180 的领域版本治理，延伸到 PR #181 的迁移兼容修复，再到 `agent-system-template` PR #1–#4 的真实同步、记录和文档口径收口。最高价值发现是：真实旧领域 `TEMPLATE-BASE.md` 的标准件范围迁移不能只靠 TODO 占位，必须兼容旧格式。
- Git Bash / MSYS 在本机 PowerShell 下多次报 `couldn't create signal pipe, Win32 error 5`，但 PowerShell fallback 路径完成 sync 与 check；后续记录应继续只保存摘要，不回灌完整成功日志。
