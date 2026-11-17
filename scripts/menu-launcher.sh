#!/usr/bin/env bash
# Sync notice: 本文件由 ai-project-template 模板同步维护，派生项目同步时会被覆盖；不应直接修改，通用改进请经 _governance/_proposals/ 回流模板仓库。
# menu-launcher.sh —— 控制台启动器菜单（对话即界面的并列点选入口）。
# 单一清单源：scripts/launcher-menu.json（菜单渲染自清单，本脚本不复制条目）。
# 红线：点选 ≠ 授权——会话类仅生成点单词；远端状态变更仍须会话内逐项确认。
# 解析约束：清单每个条目必须单行 {} 且字段顺序固定（key,type,title,(target,runner,args|source,brief),scope）。
# 用法：bash scripts/menu-launcher.sh [--list]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST="$SCRIPT_DIR/launcher-menu.json"

[[ -f "$MANIFEST" ]] || { echo "launcher-menu.json 不存在：$MANIFEST"; exit 2; }

if [[ -f "$ROOT/MAINTAINERS.md" ]]; then
  REPO_SCOPE="maintainer"; REPO_LABEL="模板仓（维护者）"
else
  REPO_SCOPE="derived"; REPO_LABEL="派生仓"
fi

ITEMS=()
while IFS= read -r line; do
  _scope="$(printf '%s' "$line" | sed -E 's/^.*"scope":"([^"]+)".*/\1/')"
  [[ "$_scope" == "$line" ]] && _scope=""
  if [[ "$_scope" == "all" || "$_scope" == "$REPO_SCOPE" ]]; then
    ITEMS+=("$line")
  fi
done < <(grep -E '^[[:space:]]*\{' "$MANIFEST" | grep -v '^[[:space:]]*{$')

field_of() { # field_of <line> <field>：按固定字段序提取值；无该字段时输出空串
  local value
  value="$(printf '%s' "$1" | sed -E 's/^.*"'"$2"'":"([^"]*)".*/\1/')"
  [[ "$value" == "$1" ]] && value=""
  printf '%s' "$value"
}

if [[ "${1:-}" == "--list" ]]; then
  for line in "${ITEMS[@]:-}"; do
    [[ -z "$line" ]] && continue
    printf '%s\t%s\t%s\n' "$(field_of "$line" type)" "$(field_of "$line" scope)" "$(field_of "$line" title)"
  done
  exit 0
fi

run_script_item() {
  local line="$1" target runner args full
  target="$(field_of "$line" target)"
  runner="$(field_of "$line" runner)"
  args="$(field_of "$line" args)"
  full="$ROOT/$target"
  if [[ ! -f "$full" ]]; then
    echo "[跳过] 本仓不存在目标（模板仓专用脚本不下行）：$target"
    return
  fi
  echo ""
  echo ">> 执行：$target $args"
  # shellcheck disable=SC2086
  if [[ "$runner" == "powershell" ]]; then
    if command -v powershell >/dev/null 2>&1; then
      powershell -NoProfile -ExecutionPolicy Bypass -File "$full" $args
    else
      echo "[跳过] PATH 上未找到 powershell，请手动执行：powershell -NoProfile -File $target $args"
      return
    fi
  else
    if command -v bash >/dev/null 2>&1; then
      bash "$full" $args
    else
      echo "[跳过] 未找到 bash，请手动执行：bash $target $args"
      return
    fi
  fi
  echo ">> 退出码：$?"
}

run_session_item() {
  local line="$1" prompt source brief act cli
  source="$(field_of "$line" source)"
  brief="$(field_of "$line" brief)"
  prompt=""
  if [[ -n "$source" && "$source" != "inline" ]]; then
    if [[ -f "$ROOT/$source" ]]; then
      prompt="先读规则来源：$source"$'\n'"$brief"
    else
      prompt="规则来源在本仓缺失（同步缺口？）：$source"$'\n'"$brief"
    fi
  else
    prompt="$brief"
  fi
  echo ""
  echo "--- 会话点单词（请复制到正确的仓目录新开会话）---"
  echo "$prompt"
  echo "---"
  read -r -p "[c] 复制到剪贴板  [l] 启动 claude  [x] 启动 codex  [回车] 返回：" act
  case "$act" in
    c)
      if command -v clip.exe >/dev/null 2>&1; then
        printf '%s' "$prompt" | clip.exe && echo "[完成] 已复制。"
      elif command -v xclip >/dev/null 2>&1; then
        printf '%s' "$prompt" | xclip -selection clipboard && echo "[完成] 已复制。"
      elif command -v pbcopy >/dev/null 2>&1; then
        printf '%s' "$prompt" | pbcopy && echo "[完成] 已复制。"
      else
        echo "[提示] 未找到剪贴板工具（clip.exe / xclip / pbcopy），请手动复制上方文本。"
      fi
      ;;
    l | x)
      if [[ "$act" == "l" ]]; then cli="claude"; else cli="codex"; fi
      if command -v "$cli" >/dev/null 2>&1; then
        echo ">> 启动 $cli（Ctrl+C 可中止）..."
        "$cli" "$prompt"
      else
        echo "[跳过] PATH 上未找到 $cli。"
      fi
      ;;
  esac
}

while true; do
  echo ""
  echo "=== ai-project-template 启动器菜单 [$REPO_LABEL] ==="
  echo "点选 ≠ 授权：会话类仅生成点单词；远端状态变更仍须会话内逐项确认。"
  echo ""
  n=1
  echo "[脚本类——直接执行]"
  for line in "${ITEMS[@]:-}"; do
    [[ -z "$line" ]] && continue
    if [[ "$(field_of "$line" type)" == "script" ]]; then
      printf '  %2d. %s\n' "$n" "$(field_of "$line" title)"
      n=$((n + 1))
    fi
  done
  echo "[会话类——生成点单词拉起 AI 会话]"
  for line in "${ITEMS[@]:-}"; do
    [[ -z "$line" ]] && continue
    if [[ "$(field_of "$line" type)" == "session" ]]; then
      printf '  %2d. %s\n' "$n" "$(field_of "$line" title)"
      n=$((n + 1))
    fi
  done
  echo "   q. 退出"
  read -r -p "选择：" sel
  [[ -z "$sel" || "$sel" == "q" ]] && break
  if ! [[ "$sel" =~ ^[0-9]+$ ]] || (( sel < 1 || sel > ${#ITEMS[@]} )); then
    echo "无效选择：$sel"
    continue
  fi
  line="${ITEMS[$((sel - 1))]}"
  if [[ "$(field_of "$line" type)" == "script" ]]; then
    run_script_item "$line"
  else
    run_session_item "$line"
  fi
done
echo "再见。"
