DEFAULT_TALK := talks/2026-03-12-ai-dev-setup
SLIDES_ARG := $(firstword $(filter %/slides.md,$(MAKECMDGOALS)))
SLIDES ?= $(if $(SLIDES_ARG),$(SLIDES_ARG),$(if $(TALK),$(TALK)/slides.md,$(DEFAULT_TALK)/slides.md))
TALK ?= $(patsubst %/slides.md,%,$(SLIDES))
MARP_WRAPPER := ./scripts/marp-talk.sh

.PHONY: preview render watch clean talk-path slides-path FORCE

FORCE:

%/slides.md: FORCE
	@if [ "$(words $(MAKECMDGOALS))" -eq 1 ]; then \
		$(MAKE) --no-print-directory render SLIDES="$@" TALK="$(patsubst %/slides.md,%,$@)"; \
	else \
		:; \
	fi

# 開発サーバーを起動する
#     Marp のサーバーを起動し、編集中のスライドをリアルタイムで確認できます
#     ブラウザでは /slides.md を開いて確認します
#     例: make preview talks/2026-03-12-ai-dev-setup/slides.md
#     例: make preview TALK=talks/2026-03-12-ai-dev-setup
preview:
	@$(MARP_WRAPPER) preview "$(SLIDES)"

# HTML / PDF / スライド画像 (PNG) を一括生成する
#     成功時は生成枚数と出力先を1行で表示し、エラー時のみ詳細を出します
#     例: make render talks/2026-03-12-ai-dev-setup/slides.md
#     例: make talks/2026-03-12-ai-dev-setup/slides.md
#     例: make render TALK=talks/2026-03-12-ai-dev-setup
render:
	@$(MARP_WRAPPER) render "$(SLIDES)"

# ファイル変更を検知して自動で再レンダリングする
#     slides.md, talk-theme.css, assets/, context/ の変更を監視します
#     例: make watch talks/2026-03-12-ai-dev-setup/slides.md
#     例: make watch TALK=talks/2026-03-12-ai-dev-setup
watch:
	@$(MARP_WRAPPER) watch "$(SLIDES)"

# dist ディレクトリを削除する
#     HTML / PDF / PNG など生成済みファイルをすべて消去します
#     例: make clean talks/2026-03-12-ai-dev-setup/slides.md
#     例: make clean TALK=talks/2026-03-12-ai-dev-setup
clean:
	@$(MARP_WRAPPER) clean "$(SLIDES)"

# 現在の TALK 変数の値を表示する
#     スクリプトやCIから対象トークのディレクトリパスを参照するときに使います
#     例: make talk-path talks/2026-03-12-ai-dev-setup/slides.md
#     例: make talk-path TALK=talks/2026-03-12-ai-dev-setup
talk-path:
	@echo $(TALK)

# 現在の SLIDES 変数の値を表示する
#     スクリプトやCIから対象スライドのパスを参照するときに使います
#     例: make slides-path talks/2026-03-12-ai-dev-setup/slides.md
#     例: make slides-path TALK=talks/2026-03-12-ai-dev-setup
slides-path:
	@echo $(SLIDES)
