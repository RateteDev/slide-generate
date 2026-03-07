TALK ?= talks/2026-03-12-ai-settings-env
MARP_WRAPPER := ./scripts/marp-talk.sh

.PHONY: help preview render watch clean talk-path

# 使い方を表示する
#     各ターゲットの実行例を一覧で出力します
help:
	@echo "make preview TALK=$(TALK)"
	@echo "make render TALK=$(TALK)"
	@echo "make watch TALK=$(TALK)"
	@echo "make clean TALK=$(TALK)"

# ブラウザでライブプレビューを開く
#     Marp のプレビューサーバーを起動し、編集中のスライドをリアルタイムで確認できます
preview:
	@$(MARP_WRAPPER) preview $(TALK)

# HTML / PDF / スライド画像 (PNG) を一括生成する
#     成功時は生成枚数と出力先を1行で表示し、エラー時のみ詳細を出します
render:
	@$(MARP_WRAPPER) render $(TALK)

# ファイル変更を検知して自動で再レンダリングする
#     slides.md, assets/, context/, theme.css の変更を監視します
watch:
	@$(MARP_WRAPPER) watch $(TALK)

# dist ディレクトリを削除する
#     HTML / PDF / PNG など生成済みファイルをすべて消去します
clean:
	@$(MARP_WRAPPER) clean $(TALK)

# 現在の TALK 変数の値を表示する
#     スクリプトやCIから対象トークのパスを参照するときに使います
talk-path:
	@echo $(TALK)
