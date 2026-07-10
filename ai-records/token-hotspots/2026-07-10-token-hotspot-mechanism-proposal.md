# Token Hotspot Record

- Date: 2026-07-10
- Project: ai-project-template
- Task type: proposal-evaluation / template-maintenance
- Trigger: 用户讨论模板 token 消耗、真实任务热点观察、自动记录与派生项目 opt-in 机制，并确认按建议执行首条记录。
- Full rules loaded: yes
- Commands / prompts used: local file reads, `rg`, `git status`, proposal patching via `apply_patch`
- High-cost reads:
  - `ai/index.md` and listed core rules were loaded before analysis / proposal work.
  - `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md` was read and patched multiple times while refining the proposal.
  - Earlier evaluation in the same discussion read `ai/document-lifecycle-rules.md`, `ai/implementation-lifecycle-rules.md`, `ai/session-rules.md`, `ai/commands/README.md`, and `ai/project-rules.md`.
  - Token footprint was estimated for large groups: `rules-core`, `docs-core`, `doc-standards`, `commands`, `prompts`, and `template-docs/docs-scaffold`.
- Repeated reads:
  - `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md` sections were re-read after each patch to locate exact insertion points and verify changes.
  - `git status --short --branch` was checked repeatedly as a safe audit step.
- Avoidable reads:
  - Full rules were necessary once because the task entered proposal design and file modification, but later follow-up questions could reuse same-session context instead of re-reading the full rules.
  - Full `template-docs/docs-scaffold/` and full `ai/prompts/` were not expanded in this task; only aggregate size was estimated, which was appropriate.
- Useful reads:
  - `ai/index.md` confirmed full-rule requirement for analysis / design / writing tasks.
  - `ai/session-rules.md` clarified quick resume versus task execution and handoff boundaries.
  - `ai/document-lifecycle-rules.md` provided scope-based reading and proposal / feedback routing constraints.
  - Existing proposal text provided the target file and ensured no formal rules were changed.
- Estimated hotspot: high
- Quality impact if optimized:
  - Safe optimization: reuse already loaded rules within the same session, read only changed target sections after patching, and prefer `rg` / line snippets over full-file rereads.
  - Unsafe optimization: skipping full rules before proposal writing or formal file changes would conflict with project governance.
- Suggested optimization:
  - Keep full-rule loading for the first analysis / writing task in a session.
  - Add a future rule candidate that follow-up tasks in the same session may reuse already loaded rules if no relevant files changed.
  - Continue avoiding full `ai/prompts/`, `template-docs/docs-scaffold/`, and `_archive/` expansion unless directly relevant.
  - Use this record plus 2–4 future records before deciding whether to formalize `ai-records/` in the template.
- Privacy check: no secrets, account credentials, customer data, or private business details recorded; only repository paths and task categories are included.

## Notes

- This is the first trial record for the candidate mechanism in `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`.
- It was created in the template repository, so any future summary here should be distilled into `_proposals/` rather than a派生项目 feedback issue.
