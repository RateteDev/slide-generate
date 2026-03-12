MARP_WRAPPER := ./scripts/marp-talk.sh
.DEFAULT_GOAL := help

SLIDES = $(TALK)/slides.md

.PHONY: help preview render watch ensure-talk

ensure-talk:
	@test -n "$(TALK)" || (echo "TALK を指定してください。例: make render TALK=talks/2026-03-12-ai-dev-setup" >&2; exit 1)

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
# Example: make preview TALK=talks/2026-03-12-ai-dev-setup
preview: ensure-talk
	@$(MARP_WRAPPER) preview "$(SLIDES)"

# Render HTML, PDF, and PNG slide images
# Example: make render TALK=talks/2026-03-12-ai-dev-setup
render: ensure-talk
	@$(MARP_WRAPPER) render "$(SLIDES)"

# Watch slide sources and rerender on changes
# Example: make watch TALK=talks/2026-03-12-ai-dev-setup
watch: ensure-talk
	@$(MARP_WRAPPER) watch "$(SLIDES)"
