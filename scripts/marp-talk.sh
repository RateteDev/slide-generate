#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
COMMAND=${1:-}
TARGET_INPUT=${2:-}

if [[ -z "$COMMAND" || -z "$TARGET_INPUT" ]]; then
  echo "usage: $0 <preview|render|watch|clean> <talk-dir|slides.md>" >&2
  exit 1
fi

resolve_repo_path() {
  local input=$1

  if [[ "$input" = /* ]]; then
    printf '%s\n' "$input"
  else
    printf '%s\n' "$ROOT_DIR/$input"
  fi
}

TARGET_PATH=$(resolve_repo_path "$TARGET_INPUT")

if [[ "$TARGET_PATH" == */slides.md ]]; then
  SLIDES_PATH="$TARGET_PATH"
  TALK_PATH=$(dirname "$SLIDES_PATH")
else
  TALK_PATH="$TARGET_PATH"
  SLIDES_PATH="$TALK_PATH/slides.md"
fi

THEME_PATH="$TALK_PATH/talk-theme.css"
DIST_PATH="$TALK_PATH/dist"
IMAGES_PATH="$DIST_PATH/images"

if [[ ! -f "$SLIDES_PATH" ]]; then
  echo "slides not found: $SLIDES_PATH" >&2
  exit 1
fi

marp() {
  if command -v bunx >/dev/null 2>&1; then
    bunx marp "$@"
    return
  fi

  echo "bunx not found: install Bun and run 'bun install' to use Marp commands" >&2
  exit 1
}

common_args() {
  printf '%s\n' --allow-local-files
}

render_html() {
  mkdir -p "$DIST_PATH"
  mapfile -t args < <(common_args)
  marp --html "${args[@]}" "$SLIDES_PATH" -o "$DIST_PATH/slides.html" 2>&1
}

render_pdf() {
  mkdir -p "$DIST_PATH"
  mapfile -t args < <(common_args)
  marp --pdf "${args[@]}" "$SLIDES_PATH" -o "$DIST_PATH/slides.pdf" 2>&1
}

render_images() {
  local generated
  mkdir -p "$IMAGES_PATH"
  rm -f "$IMAGES_PATH"/*.png
  rm -f "$TALK_PATH"/slides.*.png
  mapfile -t args < <(common_args)
  marp --images png --image-scale 2 "${args[@]}" "$SLIDES_PATH" 2>&1
  mkdir -p "$IMAGES_PATH"
  shopt -s nullglob
  for generated in "$TALK_PATH"/slides.*.png; do
    mv "$generated" "$IMAGES_PATH/"
  done
  shopt -u nullglob
}

render_all() {
  local output errors
  output=$(render_html && render_pdf && render_images) || {
    echo "[marp] render failed:" >&2
    echo "$output" >&2
    return 1
  }
  errors=$(echo "$output" | grep -i '\(error\|ERR\)' || true)
  if [[ -n "$errors" ]]; then
    echo "[marp] errors found:" >&2
    echo "$errors" >&2
    return 1
  fi
  local slide_count
  slide_count=$(find "$IMAGES_PATH" -name '*.png' | wc -l)
  echo "[marp] ok – ${slide_count} slides → $DIST_PATH"
}

watch_fingerprint() {
  local -a paths=()
  [[ -f "$SLIDES_PATH" ]] && paths+=("$SLIDES_PATH")
  [[ -f "$THEME_PATH" ]] && paths+=("$THEME_PATH")
  [[ -d "$TALK_PATH/assets" ]] && paths+=("$TALK_PATH/assets")
  [[ -d "$TALK_PATH/context" ]] && paths+=("$TALK_PATH/context")

  find "${paths[@]}" -type f -print0 \
    | sort -z \
    | xargs -0 stat --format '%n:%Y:%s' 2>/dev/null \
    | sha1sum \
    | awk '{print $1}'
}

watch_loop() {
  local last current
  render_all

  if command -v inotifywait >/dev/null 2>&1; then
    echo "[marp] watch mode via inotifywait"
    while inotifywait -qq -r -e close_write,create,delete,move "$TALK_PATH" "$THEME_PATH"; do
      render_all
    done
  fi

  echo "[marp] watch mode via polling"
  last=$(watch_fingerprint)
  while true; do
    sleep 1
    current=$(watch_fingerprint)
    if [[ "$current" != "$last" ]]; then
      render_all
      last="$current"
    fi
  done
}

clean_dist() {
  rm -rf "$DIST_PATH"
  rm -f "$TALK_PATH"/slides.*.png
  echo "[marp] cleaned $DIST_PATH"
}

case "$COMMAND" in
  preview)
    mapfile -t args < <(common_args)
    marp --server --watch "${args[@]}" "$TALK_PATH"
    ;;
  render)
    render_all
    ;;
  watch)
    watch_loop
    ;;
  clean)
    clean_dist
    ;;
  *)
    echo "unknown command: $COMMAND" >&2
    exit 1
    ;;
esac
