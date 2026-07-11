# Token Hotspot Record

- Date: 2026-07-11
- Project: ai-project-template
- Task type: resume / proposal-evaluation / template-maintenance / PR-closure
- Trigger: 用户要求读取续接点、执行下一步（评估 PR #172 是否影响母模板→直接派生项目主路径）、参考另一 AI 评估做合并前小改（方案A：README 命令名列标注）、amend + force-push、squash 合并 PR #172；收尾确认记录本轮 token hotspot。
- Full rules loaded: yes
- Commands / prompts used: quick resume flow, full rule loading from `ai/index.md`, local file reads, `git diff/status/log/push`, `scripts/check-template.sh` (via Git Bash full path on Windows), `gh pr view/merge`.
- High-cost reads:
  - `ai/index.md` listed core rules fully loaded after quick resume escalated into PR evaluation (`global-rules`, `document-lifecycle-rules`, `implementation-lifecycle-rules`, `session-rules`, `commands/README`, `project-rules`).
  - PR #172 full diff across 11 files + full reads of `template-sync.json`, `scripts/sync-template.sh`, `template-docs/domain-templates.md`, `ai/commands/domain-template-lab.md`, `ai/prompts/maintainers/23-domain-template-lab.md` to judge main-path pollution.
  - Cross-checking another AI's evaluation required re-reading parts of the same PR files to verify its claims.
  - `scripts/check-template.sh` run produced a large success log during amend validation.
- Repeated reads:
  - `git status/log/branch` repeated after amend, force-push, merge, and pull.
  - `.ai/session-handoff.md` patched 4 times to reflect the merge closure.
  - PR #172 CI status checked via `gh pr view --json statusCheckRollup` before push and again after push.
- Avoidable reads:
  - Once full rules were loaded for PR evaluation, the merge-closure tail (README edit, amend, push, merge, handoff) could reuse same-session rules; no rule file changed in between.
  - Full `check-template.sh` success log is low-value after the exit code is known (same pattern as record #2).
  - Re-reading PR files to verify another AI's claims was partly redundant; a structured claim→evidence table could let the verifying AI spot-check specific lines instead of re-reading full files.
- Useful reads:
  - Full rules were necessary before any write / PR / merge governance decision.
  - `template-sync.json` + `scripts/sync-template.sh` + `template-docs/domain-templates.md` full reads were essential to answer the core evaluation question (main-path pollution).
  - Two independent AI evaluations converging on "safe to merge" raised confidence; the cross-check had real quality value despite the token cost.
  - Local `check-template.sh` before push de-risked CI (CI passed first try after force-push).
- Estimated hotspot: medium-high
- Quality impact if optimized:
  - Safe optimization: reuse same-session rules for the sequential merge-closure steps since no rule changed; summarize `check-template.sh` success by command + exit code; prefer `gh pr view --json statusCheckRollup` for normal checks.
  - Unsafe optimization: skipping rule load before the merge verdict, skipping main-path file reads before "safe to merge", or skipping local `check-template.sh` before push would weaken governance and release safety.
- Suggested optimization:
  - Formalize a same-session rule-reuse note for sequential governance steps — this pattern now appears in records #1, #2, and #3.
  - For multi-AI cross-check: have each AI emit a claim→evidence table so the verifier spot-checks specific lines instead of re-reading full files.
  - Reached the 3-record threshold; per proposal §7 a `summaries/` report is now due.
- Privacy check: no secrets, account credentials, customer data, or private business details recorded; only repository paths, PR numbers, command names, task categories, and optimization suggestions.

## Notes

- Third trial record for the candidate mechanism in `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`; reaches the 3-record summary threshold in proposal §7.
- Created in the template repository, so any future summary here should be distilled into `_proposals/` (e.g., formalize the same-session rule-reuse candidate seen across all 3 records) rather than a derived-project feedback issue.
