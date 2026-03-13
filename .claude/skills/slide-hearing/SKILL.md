---
name: slide-hearing
description: |
  tmux の hearing パネルで Claude をインタビュアーとして起動し、ヒアリングを別ウィンドウで行うスキル。
  TRIGGER when: 「ヒアリングして」「素材を集めて」「インタビューして」「hearing パネルで」など、発表素材のヒアリングを依頼された場合。
  DO NOT TRIGGER when: スライド執筆・レビュー・アウトライン作成のみが目的の場合。
---

# slide-hearing

tmux の `hearing` セッションを作成し、Claude をインタビュアーとして起動する。

## 手順

### 1. 対象ディレクトリを確認
ユーザーが指定した発表ディレクトリを使う。
指定がない場合は `talks/` 配下で最新更新のディレクトリを自動選択する（確認不要）。

### 2. hearing セッションを起動
以下のコマンドで `hearing` セッションを作成し、Claude を起動する。

```bash
TALKDIR="{talks/<発表ディレクトリ> の絶対パス}"
SESSION="hearing"
PROMPT="$(TALKDIR="$TALKDIR" envsubst '${TALKDIR}' < docs/prompt-slide-hearing.md)"

tmux send-keys -t "$SESSION" "cd $(pwd) && claude --model haiku \"$PROMPT\"" Enter
```

### 3. ユーザーに案内

コマンド実行後、以下を伝える。
"tmuxでhearingセッションを起動しました。ヒアリングが完了したらお伝えください。"
