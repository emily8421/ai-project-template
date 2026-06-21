#!/usr/bin/env bash
# check-template.sh — 检查 ai-project-template 的关键入口、文档骨架与同步清单是否自洽
#
# 用法:
#   bash scripts/check-template.sh
#
# 说明: 本脚本只读取文件并输出检查结果，不修改工作区。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FAILURES=0

pass() {
  echo "✓ $1"
}

fail() {
  echo "✗ $1" >&2
  FAILURES=$((FAILURES + 1))
}

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "存在: $file"
  else
    fail "缺失: $file"
  fi
}

require_contains() {
  local file="$1"
  local pattern="$2"
  local message="$3"
  if [[ ! -f "$file" ]]; then
    fail "$message（文件缺失: $file）"
  elif grep -Eq -- "$pattern" "$file"; then
    pass "$message"
  else
    fail "$message"
  fi
}

extract_index_rules() {
  grep -E '^- ai/.+\.md$' ai/index.md | sed 's/^- //'
}

extract_sync_files_from_script() {
  awk '
    /^SYNC_FILES=\(/ { in_list=1; next }
    in_list && /^\)/ { in_list=0; next }
    in_list {
      gsub(/["[:space:]]/, "")
      if (length($0) > 0) print $0
    }
  ' scripts/sync-template.sh
}

echo "==> 检查 AI 入口文件"
require_file "AGENTS.md"
require_file "CLAUDE.md"
require_file ".cursor/rules/project-rules.mdc"
require_contains "AGENTS.md" 'ai/index\.md' "AGENTS.md 指向 ai/index.md"
require_contains "CLAUDE.md" 'ai/index\.md' "CLAUDE.md 指向 ai/index.md"
require_contains ".cursor/rules/project-rules.mdc" 'ai/index\.md' "Cursor 规则指向 ai/index.md"
require_contains ".cursor/rules/project-rules.mdc" '^alwaysApply: true$' "Cursor 规则启用 alwaysApply"

echo
echo "==> 检查 AI 规则索引"
require_file "ai/index.md"
while IFS= read -r rule_file; do
  [[ -n "$rule_file" ]] || continue
  require_file "$rule_file"
done < <(extract_index_rules)

echo
echo "==> 检查核心文档骨架"
for doc in \
  docs/00-scenario.md \
  docs/01-user-requirements.md \
  docs/02-srs.md \
  docs/03-prd.md \
  docs/04-architecture.md \
  docs/05-tech-spec.md \
  docs/08-dev-plan.md \
  docs/09-verification.md; do
  require_file "$doc"
  require_contains "$doc" '^# ' "$doc 含一级标题"
done

for optional_doc in docs/06-db-design.md docs/07-api-spec.md; do
  if [[ -f "$optional_doc" ]]; then
    require_contains "$optional_doc" '^# ' "$optional_doc 存在且含一级标题"
  else
    pass "可选文档已省略: $optional_doc"
  fi
done

echo
echo "==> 检查版本号与治理文件"
require_contains "ai/global-rules.md" '模板版本：v[0-9]+\.[0-9]+' "global-rules 含模板版本号"
require_file "README.md"
require_file "CONTRIBUTING.md"
require_file "INIT-PROMPT.md"
require_file "git-guide.md"
require_file "scripts/new-project.sh"
require_file "scripts/sync-template.sh"

echo
echo "==> 检查同步清单一致性"
while IFS= read -r sync_file; do
  [[ -n "$sync_file" ]] || continue
  require_file "$sync_file"
  require_contains "README.md" "$(printf '%s' "$sync_file" | sed 's/[.[\*^$()+?{}|\\]/\\&/g')" "README 同步清单包含 $sync_file"
done < <(extract_sync_files_from_script)

echo
if [[ "$FAILURES" -eq 0 ]]; then
  echo "✅ 模板自检通过"
else
  echo "❌ 模板自检失败：$FAILURES 项" >&2
  exit 1
fi
