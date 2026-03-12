MARP_WRAPPER := ./scripts/marp-talk.sh
.DEFAULT_GOAL := help

PRIMARY_TARGET := $(firstword $(MAKECMDGOALS))
TALK_DIR := $(word 2,$(MAKECMDGOALS))

ifneq ($(filter dev build build-html build-pdf build-image build-all watch,$(PRIMARY_TARGET)),)
ifneq ($(TALK_DIR),)
.PHONY: $(TALK_DIR)
$(TALK_DIR):
	@:
endif
endif

SLIDES = $(TALK_DIR)/slides.md
DIST_DIR = $(TALK_DIR)/dist
HTML_OUTPUT = $(DIST_DIR)/slides.html
PDF_OUTPUT = $(DIST_DIR)/slides.pdf
IMAGE_DIR = $(DIST_DIR)/images

.PHONY: help dev build build-html build-pdf build-image build-all watch ensure-talk fonts prepare-html prepare-pdf prepare-image prepare-all

ensure-talk:
	@test -n "$(TALK_DIR)" || (echo "発表ディレクトリを指定してください。例: make build-all talks/2026-03-12-ai-dev-setup" >&2; exit 1)

# Show available targets
help:
	@printf "Usage: make <target>\n\n"
	@awk '\
		BEGIN { desc = ""; example_count = 0; } \
		/^# [^#]/ { \
			line = substr($$0, 3); \
			if (line ~ /^Example: /) { \
				examples[++example_count] = substr(line, 10); \
			} else { \
				desc = line; \
			} \
			next; \
		} \
		/^[a-zA-Z0-9_.\/%-]+:/ { \
			target = $$1; \
			sub(/:.*/, "", target); \
			if (target != ".PHONY" && target != "FORCE" && desc != "") { \
				printf "%-20s %s\n", target, desc; \
				for (i = 1; i <= example_count; i++) { \
					printf "%-20s %s\n", "", "Example: " examples[i]; \
				} \
				printf "\n"; \
			} \
			desc = ""; \
			example_count = 0; \
			delete examples; \
			next; \
		} \
		{ desc = ""; example_count = 0; delete examples; } \
	' $(MAKEFILE_LIST)

# Start the Marp preview server for a talk
# Example: make dev talks/2026-03-12-ai-dev-setup
dev: ensure-talk
	@$(MARP_WRAPPER) preview "$(SLIDES)"

# Example: make fonts
# Install fonts used by the Marp theme into the user environment
fonts:
	@./scripts/build-fonts.sh install

# Render HTML, PDF, and PNG slide images
# Example: make build-all talks/2026-03-12-ai-dev-setup
build: build-all

# Render HTML only
# Example: make build-html talks/2026-03-12-ai-dev-setup
build-html: ensure-talk prepare-html
	@$(MARP_WRAPPER) render-html "$(SLIDES)"

# Render PDF only
# Example: make build-pdf talks/2026-03-12-ai-dev-setup
build-pdf: ensure-talk prepare-pdf
	@$(MARP_WRAPPER) render-pdf "$(SLIDES)"

# Render slide images only
# Example: make build-image talks/2026-03-12-ai-dev-setup
build-image: ensure-talk prepare-image
	@$(MARP_WRAPPER) render-image "$(SLIDES)"

# Render HTML, PDF, and PNG slide images
# Example: make build-all talks/2026-03-12-ai-dev-setup
build-all: ensure-talk prepare-all
	@$(MARP_WRAPPER) render-all "$(SLIDES)"

prepare-html:
	@echo "[make] Removing existing HTML output: $(HTML_OUTPUT)"
	@rm -f "$(HTML_OUTPUT)"

prepare-pdf:
	@echo "[make] Removing existing PDF output: $(PDF_OUTPUT)"
	@rm -f "$(PDF_OUTPUT)"

prepare-image:
	@echo "[make] Removing existing image output: $(IMAGE_DIR)"
	@rm -f "$(IMAGE_DIR)"/*.png
	@rm -f "$(TALK_DIR)"/slides.*.png

prepare-all: prepare-html prepare-pdf prepare-image

# Watch slide sources and rerender on changes
# Example: make watch talks/2026-03-12-ai-dev-setup
watch: ensure-talk
	@$(MARP_WRAPPER) watch "$(SLIDES)"
