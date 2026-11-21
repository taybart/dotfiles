#!/usr/bin/env bash
# Render a file with Neovim's tree-sitter highlighting as ANSI on stdout.
#
# Usage: yazi-nvim-preview.sh <file>
#
# Runs a throwaway headless nvim (minimal init in preview_init.lua) that dumps
# the buffer via dump.lua. Used by the nvim-preview.yazi plugin; also handy to
# run by hand when debugging a preview.
#
# Env: NVIM_PREVIEW_BG=light|dark picks the colorscheme variant (falls back to
#      piper's $t if set).
# Exit: 0 = ok, 3 = no tree-sitter support for this file (fall back), 1 = error.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

if [[ $# -lt 1 ]]; then
  echo "usage: $(basename "$0") <file>" >&2
  exit 1
fi

export NVIM_PREVIEW_BG="${NVIM_PREVIEW_BG:-${t:-}}"

# -i NONE: don't read/write shada (concurrent previews would race on it).
# dump.lua always exits itself; reaching the trailing `cq 1` means it failed
# to even load, and without it headless nvim would hang forever.
exec nvim --headless -i NONE \
  -u "$SCRIPT_DIR/preview_init.lua" \
  -c "luafile $SCRIPT_DIR/dump.lua" \
  -c 'cq 1' \
  -- "$1"
