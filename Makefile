TALK ?= talks/2026-03-12-ai-dev-setup
MARP_WRAPPER := ./scripts/marp-talk.sh

.PHONY: preview render watch clean talk-path

# ブラウザでライブプレビューを開く
#     Marp のプレビューサーバーを起動し、編集中のスライドをリアルタイムで確認できます
#     例: make preview TALK=talks/2026-03-12-ai-dev-setup
preview:
	@$(MARP_WRAPPER) preview $(TALK)

# HTML / PDF / スライド画像 (PNG) を一括生成する
#     成功時は生成枚数と出力先を1行で表示し、エラー時のみ詳細を出します
#     例: make render TALK=talks/2026-03-12-ai-dev-setup
render:
	@$(MARP_WRAPPER) render $(TALK)

# ファイル変更を検知して自動で再レンダリングする
#     slides.md, assets/, context/, theme.css の変更を監視します
#     例: make watch TALK=talks/2026-03-12-ai-dev-setup
watch:
	@$(MARP_WRAPPER) watch $(TALK)

# dist ディレクトリを削除する
#     HTML / PDF / PNG など生成済みファイルをすべて消去します
#     例: make clean TALK=talks/2026-03-12-ai-dev-setup
clean:
	@$(MARP_WRAPPER) clean $(TALK)

# 現在の TALK 変数の値を表示する
#     スクリプトやCIから対象トークのパスを参照するときに使います
#     例: make talk-path TALK=talks/2026-03-12-ai-dev-setup
talk-path:
	@echo $(TALK)
