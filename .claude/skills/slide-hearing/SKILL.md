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
`scripts/tmux-hearing.sh` を使って起動する。

```bash
TALKDIR="{talks/<発表ディレクトリ> の絶対パス}"
./scripts/tmux-hearing.sh "$TALKDIR"
```

スクリプトが以下を自動で行う：
- `hearing` セッションの存在確認（なければ新規作成）
- pane 直下の node プロセス（Claude）が実行中でないことを確認
- 条件を満たせば Claude を起動。実行中の場合はエラーで終了

### 3. ユーザーに案内

スクリプトが正常終了したら以下を伝える。
"tmux で hearing セッションを起動しました。ヒアリングが完了したらお伝えください。"
