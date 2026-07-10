# Token Hotspot Record

- Date: 2026-07-10
- Project: ai-project-template
- Task type: resume / template-maintenance / smoke-test / PR-closure
- Trigger: 用户要求读取续接点、执行下一步建议、合并 PR #168、运行 Windows 新手 smoke-test、修复 smoke-test 跟进点并合并 PR #169；随后询问本轮是否触发 token hotspot，并确认主动记录。
- Full rules loaded: yes
- Commands / prompts used: quick resume flow, full rule loading from `ai/index.md`, local file reads, `rg`, `git status`, `scripts/check-prereqs.ps1`, `scripts/new-project.sh`, `scripts/collect-env.ps1`, `scripts/check-template.sh`, GitHub CLI PR / Actions commands.
- High-cost reads:
  - `ai/index.md` listed core rules were fully loaded after quick resume escalated into task execution.
  - Full-rule output exceeded the tool display window and required segmented rereads of `ai/global-rules.md`, `ai/document-lifecycle-rules.md`, `ai/implementation-lifecycle-rules.md`, `ai/commands/README.md`, and `ai/project-rules.md`.
  - `scripts/check-template.sh` was run multiple times and produced very large success logs during PR #168 and PR #169 validation.
  - PR / CI loops for #168 and #169 required repeated `gh pr view`, `gh pr merge`, and failed-run log inspection.
  - Windows smoke-test execution read and validated `template-docs/smoke-test.md`, `template-docs/smoke-test-report-template.md`, `scripts/check-prereqs.ps1`, `scripts/new-project.sh`, and generated smoke project README / env outputs.
- Repeated reads:
  - `git status --short --branch`, `git log --oneline`, and branch checks were repeated after each PR, merge, pull, branch cleanup, and smoke cleanup.
  - `.ai/session-handoff.md` was read and patched multiple times to keep handoff metadata aligned with PR #168, PR #169, and v1.45.4.
  - PR #169 status was checked before merge, after CI failure, after amend / force-push, and after merge.
- Avoidable reads:
  - After the first full rule load in this same session, later maintenance follow-ups could safely reuse loaded rules unless relevant rule files changed.
  - Full `check-template.sh` success logs are low-value after the exit code is known; future runs could record command, exit code, and only failed sections unless detailed evidence is requested.
  - Some full-file reads were needed only because command output was truncated; targeted line snippets with `Select-String` / line ranges were more efficient once target sections were known.
- Useful reads:
  - Full rules were necessary before modifying files, creating proposals, versioning, opening PRs, and updating handoff state.
  - `template-docs/smoke-test.md` directly revealed the intended Windows smoke-test path and cleanup expectations.
  - `scripts/check-prereqs.ps1` and `scripts/new-project.sh` snippets directly identified the three user-facing follow-up fixes.
  - Failed CI log for PR #169 was high-value and quickly identified a single trailing blank line issue.
- Estimated hotspot: high
- Quality impact if optimized:
  - Safe optimization: reuse full rules already loaded in the same session; prefer exact section snippets; summarize successful long checks by command + exit code; read failed CI logs only for failed steps.
  - Unsafe optimization: skipping rule loading before write / PR work, skipping smoke-test cleanup checks, or skipping PR / CI state verification before merge would weaken governance and release safety.
- Suggested optimization:
  - Formalize a same-session rule-reuse note if repeated records keep showing full-rule rereads after no rule file changed.
  - Add a convention for validation evidence summaries: keep full command names and exit codes, but avoid pasting full successful `check-template.sh` logs into working context.
  - Prefer `gh pr view --json statusCheckRollup` for normal PR checks and `gh run view --log-failed` only when checks fail.
  - Keep smoke-test records focused on observed user-facing steps, not full generated project content.
- Privacy check: no secrets, account credentials, customer data, or private business details recorded; this record includes repository paths, task categories, PR numbers, command names, and optimization suggestions only.

## Notes

- This is the second trial record for the candidate mechanism in `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`.
- This record covers the post-PR #168 continuation through Windows smoke-test guidance PR #169 and final cleanup.
