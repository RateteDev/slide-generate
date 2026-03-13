#!/usr/bin/env bash
set -euo pipefail

# scripts/tmux-hearing.sh
# hearing セッションのセットアップと Claude 起動
#
# Usage: ./scripts/tmux-hearing.sh <TALKDIR_ABSOLUTE>
#
# 終了コード:
#   0 — 正常起動
#   1 — 引数不足 / Claude 実行中 / その他エラー

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
TALKDIR=${1:-}
SESSION="hearing"

if [[ -z "$TALKDIR" ]]; then
  echo "usage: $0 <TALKDIR_ABSOLUTE>" >&2
  exit 1
fi

# --- セッション確認 ---
if tmux has-session -t "$SESSION" 2>/dev/null; then
  # pane の直下で node (Claude) が動いていないか確認
  pane_pid=$(tmux list-panes -t "$SESSION" -F '#{pane_pid}' | head -1)
  if pgrep -P "$pane_pid" node >/dev/null 2>&1; then
    echo "[hearing] Claude が実行中です（セッション: $SESSION）。終了してから再実行してください。" >&2
    exit 1
  fi
  echo "[hearing] 既存セッションを再利用します: $SESSION"
else
  tmux new-session -d -s "$SESSION"
  echo "[hearing] セッションを作成しました: $SESSION"
fi

# --- プロンプトを固定パスに展開 ---
# tmux セッション内のシェルから参照できるよう ROOT_DIR に置く
PROMPT_FIXED="$ROOT_DIR/.hearing-prompt.md"
TALKDIR="$TALKDIR" envsubst '${TALKDIR}' \
  < "$ROOT_DIR/docs/prompt-slide-hearing.md" \
  > "$PROMPT_FIXED"

# --- Claude 起動 ---
# ファイル展開後に $(cat ...) で読み込ませてプロンプト引数に渡す
# 起動後はプロンプトファイルを削除する
tmux send-keys -t "$SESSION" \
  "cd '$ROOT_DIR' && claude --model haiku \"\$(cat .hearing-prompt.md)\" ; rm -f .hearing-prompt.md" \
  Enter

echo "[hearing] ok – セッション '$SESSION' で Claude を起動しました。"
