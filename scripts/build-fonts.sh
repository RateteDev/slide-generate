#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
FONT_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}/fonts
FONT_CACHE_DIR="$FONT_HOME/slide-generate"
APTOS_URL='https://download.microsoft.com/download/8/6/0/860a94fa-7feb-44ef-ac79-c072d9113d69/Microsoft%20Aptos%20Fonts.zip'
JETBRAINS_MONO_URL='https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip'

usage() {
  cat <<'EOF'
usage: scripts/build-fonts.sh <check|install>

check
  必要フォントが build 環境に存在するか確認します。

install
  必要フォントをユーザー領域 (~/.local/share/fonts/slide-generate) へ導入します。
EOF
}

has_font() {
  local family=$1
  fc-match "$family" >/dev/null 2>&1
}

require_tools() {
  local tool
  for tool in curl unzip fc-match fc-cache; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      echo "[fonts] required command not found: $tool" >&2
      exit 1
    fi
  done
}

copy_fonts_from_zip() {
  local url=$1
  local pattern=$2
  local target_dir=$3
  local tmpdir archive

  tmpdir=$(mktemp -d)
  archive="$tmpdir/archive.zip"

  curl -fsSL "$url" -o "$archive"
  mkdir -p "$target_dir"
  unzip -jo "$archive" "$pattern" -d "$target_dir" >/dev/null
  rm -rf "$tmpdir"
}

install_fonts() {
  require_tools

  mkdir -p "$FONT_CACHE_DIR/aptos" "$FONT_CACHE_DIR/jetbrains-mono"

  copy_fonts_from_zip "$APTOS_URL" '*.ttf' "$FONT_CACHE_DIR/aptos"
  copy_fonts_from_zip "$JETBRAINS_MONO_URL" '*/ttf/*.ttf' "$FONT_CACHE_DIR/jetbrains-mono"

  fc-cache -f "$FONT_CACHE_DIR" >/dev/null
  echo "[fonts] installed Aptos + JetBrains Mono into $FONT_CACHE_DIR"
}

check_fonts() {
  require_tools

  local missing=0
  local family
  for family in Aptos "JetBrains Mono"; do
    if ! has_font "$family"; then
      echo "[fonts] missing: $family" >&2
      missing=1
    fi
  done

  if [[ $missing -ne 0 ]]; then
    cat >&2 <<'EOF'
[fonts] build 出力をプレビューに近づけるには、必要フォントを導入してください。
[fonts] 実行: ./scripts/build-fonts.sh install
EOF
    exit 1
  fi

  echo "[fonts] ok"
}

case "${1:-}" in
  check)
    check_fonts
    ;;
  install)
    install_fonts
    check_fonts
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
