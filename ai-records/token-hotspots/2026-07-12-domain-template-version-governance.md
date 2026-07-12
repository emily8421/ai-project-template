# Token Hotspot Record

- Date: 2026-07-12
- Project: ai-project-template (mother template)
- Task type: template-maintenance / domain-template-version-governance / sync-script
- Trigger: 用户「开始领域模板版本治理」——实现 inheritance Batch 3 / C-004：`sync-template.* --domain-template` 角色分支，让领域模板 sync 时保留自身 `VERSION`/`CHANGELOG.md` 并维护领域版 `TEMPLATE-BASE.md`。
- Full rules loaded: **是**——本会话以「读取续接点」快速续接模式开场，用户随后要求执行任务，按 `ai/session-rules.md` §3.2 升级，完整读取 `ai/index.md` 列出的全部规则（global-rules、document-lifecycle-rules、implementation-lifecycle-rules、commands/README、project-rules；session-rules 已在快速续接时读）。这是本记录的核心成本点：**快速续接 → 执行升级强制全量规则门禁**。
- Commands / prompts used: 多轮 Grep 定位、Read（规则 + 长脚本 + 提案 + 治理文档）、Edit（15 文件）、`bash -n` / PowerShell Parser 语法校验、`scripts/check-template.sh` 全量、`scripts/check-template.ps1` 全量、sync 函数单元测试、互斥参数测试、`git status/diff`。
- High-cost reads:
  - 6 个 `ai/*` 规则文件完整读取（升级门禁，不可省）。
  - `scripts/sync-template.sh`（~570 行）与 `scripts/sync-template.ps1`（~690 行）各完整读 1 次；`check-derived-sync.*`、`check-template.*` 区域读。
  - 3 份长提案/治理文档全文：`_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`、`_archive/proposals/TEMPLATE-UPGRADE-derived-project-version-governance.md`、`template-docs/domain-templates.md`；以及 `ai/prompts/maintainers/12-sync-template.md`、`git-guide.md`、`scenario-guides.md` A13/A20、`derived-sync-report-template.md`。
  - 两次全量自检：`check-template.sh` 输出 89.6KB（持久化后仅 grep 取结尾 + 失败行）、`check-template.ps1` 全量跑。
- Repeated reads:
  - Grep 反复定位 `--preserve-project-version` 的引用面（14 文件）与 `check-derived-sync` 断言精确行号，以确定联动范围。
  - `check-template.sh/.ps1` 两次各跑一遍（.sh 权威 + .ps1 Windows 镜像），断言集合几乎对称。
- Avoidable reads:
  - `check-template.ps1` 全量跑在 `.sh` 已 EXIT=0 后理论上可省（断言是镜像），但为确认 `.ps1` 端 Require-Contains 改动无误仍值得；可改为只跑受影响断言段。
  - 89.6KB 自检输出持久化后只用 grep 取了失败行与结尾——全量日志未回灌上下文（已按 §4.1 验证摘要约定处理）。
  - 定位联动范围的多轮 Grep 部分可合并为一次广度 Grep + 一次精读。
- Useful reads:
  - `_archive/...derived-project-version-governance.md` 提供 DV-003/DV-004 已落地参照，直接决定「领域模板走独立角色分支而非复用 `--preserve-project-version`」。
  - inheritance 提案 C-004 行 + 2026-07-11 试跑实证，精确锁定任务范围与「保留领域 CHANGELOG」决策依据。
  - `domain-templates.md` 现状（§5 预留/未启用）决定文档更新点。
- Estimated hotspot: medium-high（完整规则门禁 + 两个 ~600 行脚本 + 3 份长提案 + 两次全量自检；但 H-001 同会话复用让后续 15 文件编辑/验证未重读规则，显著压低了本可更高的成本）。
- Quality impact if optimized:
  - 安全优化：快速续接升级时，若规则文件未被修改且属于同任务链，可考虑按 §3.2 复用边界只补读增量（H-001 的延伸）；check-template 输出坚持只取失败行 + 结尾；联动范围定位用一次广度 Grep + 精读。
  - 不安全优化：跳过升级时的完整规则门禁、跳过 `check-template` 自检、或跳过对 `--preserve-project-version` 既有行为的回归核对，都会增加污染普通派生路径或断言漂移的风险。
- Suggested optimization:
  - 印证 H-001（同会话规则复用）：规则在升级门禁读一次后，后续 15 文件编辑、两次自检、单元测试全程复用，未重读——支持把「快速续接→执行升级」也纳入同任务链复用边界（当前 §3.2 已部分覆盖，但门禁仍要求全量）。
  - 新候选（H-005）：`sync-template.sh` 与 `.ps1` 是强制对称双语言实现，本次 25+ 处编辑需手工保持两端一致 + 双份断言；可评估一个「.sh↔.ps1 对称差异」轻量对照，减少人工对称漂移。
  - check-template 双端各跑一遍可考虑只在受影响断言段跑一次对端验证。
- Privacy check: 无 token、密钥、账号、客户敏感数据；仅仓库路径、命令名、任务类别与优化建议。

## Notes

- 第五份 trial 记录；再次印证 H-001（同会话规则复用）。本记录的特色成本点是「快速续接 → 执行升级」触发的全量规则门禁，以及 sync 脚本双语言对称改动的重复成本（新候选 H-005）。
- 母模板仓内任务；后续 summary 可把 H-005（双语言对称对照）与「升级门禁复用边界」折叠进 `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`。
