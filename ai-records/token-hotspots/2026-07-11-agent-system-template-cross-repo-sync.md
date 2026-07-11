# Token Hotspot Record

- Date: 2026-07-11
- Project: ai-project-template (cross-repo task targeting agent-system-template)
- Task type: cross-repo / template-maintenance / domain-template-sync
- Trigger: 用户启动 B：将派生领域模板 agent-system-template 从 v1.44.3 同步到母模板 v1.45.6，并验证 PR #172 的 domain-template-lab 入口在真实领域模板仓库可用。
- Full rules loaded: reused（复用本会话前面 #172 评估时已加载的规则，未重新全量加载——印证 H-001 same-session rule-reuse 候选）
- Commands / prompts used: cross-repo memory reads, `git fetch/checkout/commit/push`, `scripts/sync-template.sh` (--dry-run/--summary/--commit), local file reads in both repos.
- High-cost reads:
  - 3 derived-project memory files read to verify A/B feasibility and avoid stale-memory decisions (agent-system-template / digital-cs-demo / zhiyan).
  - `scripts/sync-template.sh` invoked multiple times: read-only staleness check → bootstrap → --summary → --commit (4 invocations across the sync).
  - agent-system-template file verification (VERSION, domain-template-lab entry, agent-system/ artifacts, TEMPLATE-BASE.md) after sync.
  - Mother-template ruleset (loaded earlier this session) reused instead of reloaded — a cost *avoided* thanks to same-session context.
- Repeated reads:
  - `cd "D:/2-Project/5-Project Templates/agent-system-template"` repeated at the start of nearly every bash call because the shell cwd resets to the mother-template repo between calls (documented in derived-project memory).
  - `git status --short --branch` checked in both repos across bootstrap, sync, push, and verification.
- Avoidable reads:
  - `sync-template.sh` was invoked 4 times; the staleness check + bootstrap could be a single guided step, and --summary before --commit is optional once the diff scope is understood.
  - Each cross-repo bash call re-`cd`s because cwd doesn't persist; batching multiple agent-system-template operations into one bash call (as done for verification) cuts reset overhead.
  - Re-reading memory files each cross-repo task is partly avoidable if a short derived-project status note is kept current — but memory verification before decisions remains high-value.
- Useful reads:
  - Derived-project memories confirmed agent-system-template path, v1.44.3 base, and the "domain version authoritative via TEMPLATE-BASE.md" policy — directly shaped the safe-sync decision (accept VERSION overwrite).
  - `sync-template.sh --summary` gave the all-clear (no risk-path hits, 0 deleted) cheaply before --commit.
  - Post-sync verification (4 checks) confirmed zero domain-artifact loss — the core safety question for a domain-template sync.
  - Same-session rule reuse (no reload) — empirically supports candidate H-001.
- Estimated hotspot: medium (cross-repo overhead — cwd resets, dual-repo git, repeated cd — but lower than it would be without same-session rule reuse).
- Quality impact if optimized:
  - Safe optimization: batch cross-repo operations into single bash calls to dodge cwd resets; merge sync staleness-check + bootstrap into one guided step; keep a tiny derived-status note to cut memory re-reads.
  - Unsafe optimization: skipping memory verification before a derived-sync decision, skipping --summary before --commit, or skipping post-sync domain-artifact verification would risk overwriting domain standards or trusting stale project state.
- Suggested optimization:
  - For cross-repo tasks: prefer one bash call bundling cd + multiple operations (already done for verification); document the cwd-reset cost as a known hotspot for derived-project work.
  - Reinforces H-001 (same-session rule-reuse): this record is the first to *not* reload rules mid-session, showing the candidate works — strengthens the case for eventually formalizing it.
  - New candidate (H-004): derived-project sync could offer a single "check + bootstrap + summary" combined mode to cut the 4-invocation pattern.
- Privacy check: no secrets, account credentials, customer data, or private business details recorded; only repository paths, command names, task categories, and optimization suggestions.

## Notes

- Fourth trial record; first **cross-repo** sample (prior 3 were mother-template-only). Per proposal §7.2, cross-repo / derived-project samples complement the maintainer-skewed mother-template samples.
- Empirically supports candidate H-001 (same-session rule-reuse) — rules were reused, not reloaded, during this task.
- Created in the mother-template repo; future summary should fold cross-repo findings (cwd-reset cost, sync multi-invocation, H-004) into `_proposals/`.
