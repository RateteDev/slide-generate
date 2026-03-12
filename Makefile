MARP_WRAPPER := ./scripts/marp-talk.sh
.DEFAULT_GOAL := help

PRIMARY_TARGET := $(firstword $(MAKECMDGOALS))
TALK_DIR := $(word 2,$(MAKECMDGOALS))

ifneq ($(filter dev build watch,$(PRIMARY_TARGET)),)
ifneq ($(TALK_DIR),)
.PHONY: $(TALK_DIR)
$(TALK_DIR):
	@:
endif
endif

SLIDES = $(TALK_DIR)/slides.md

.PHONY: help dev build watch ensure-talk fonts

ensure-talk:
	@test -n "$(TALK_DIR)" || (echo "発表ディレクトリを指定してください。例: make build talks/2026-03-12-ai-dev-setup" >&2; exit 1)

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
# Example: make build talks/2026-03-12-ai-dev-setup
build: ensure-talk
	@$(MARP_WRAPPER) render "$(SLIDES)"

# Watch slide sources and rerender on changes
# Example: make watch talks/2026-03-12-ai-dev-setup
watch: ensure-talk
	@$(MARP_WRAPPER) watch "$(SLIDES)"
