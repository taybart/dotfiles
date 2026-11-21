# nvim-preview

Yazi previews text files with Neovim's tree-sitter highlighting, using the same
grammars, filetypes and gruvbox colors as the editor. Files Neovim has no
parser for fall back to Yazi's built-in `code` previewer.

## How it works

1. `yazi.toml` routes text mimes to the `nvim-preview` plugin
   (`plugins/nvim-preview.yazi/main.lua`).
2. The plugin runs `yazi-nvim-preview.sh`, which starts a throwaway headless
   `nvim -u preview_init.lua -i NONE` (no plugins, no shada; ~50 ms).
3. `preview_init.lua` sets up filetype detection, picks light/dark from the
   terminal, and loads gruvbox.
4. `dump.lua` parses the buffer (including injected languages, e.g. code
   blocks in markdown), resolves captures the way nvim's highlighter does, and
   prints ANSI 24-bit colors. It exits `3` when there's no parser/highlights
   query, so the plugin falls back to `code`.

Files over 512 KiB skip nvim and go straight to `code`.

## Custom filetypes (one place)

`~/.config/nvim/lua/tools/filetype_export.lua` (required at the top of
`init.lua`) records every `vim.filetype.add()` and
`vim.treesitter.language.register()` call your config and plugins make (e.g.
midnight.nvim's `.mn`, rest.nvim's `rest -> hcl`), and writes them to
`stdpath('state')/filetypes.json` on startup. `preview_init.lua` loads that file.

So after installing a plugin that adds a filetype, just open nvim once.
Function-valued filetype mappings are skipped.

## Adding languages

Install the grammar in nvim (`:TSInstall toml`); the preview picks it up
from `stdpath('data')/site` automatically.

## Debugging

Run the script by hand:

```sh
./yazi-nvim-preview.sh some/file; echo "exit=$?"
NVIM_PREVIEW_BG=light ./yazi-nvim-preview.sh some/file
```

Plugin errors (anything but exit `3`) are logged with `ya.dbg`
(run yazi with `YAZI_LOG=debug`).
