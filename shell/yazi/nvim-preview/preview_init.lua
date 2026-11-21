-- Minimal Neovim init for Yazi preview highlighting (tree-sitter).
-- Loaded with: nvim --headless -u preview_init.lua
--
-- Parsers/queries come from the default runtimepath (stdpath('data')/site),
-- where nvim-treesitter installs them, so no plugins are loaded here.

vim.opt.termguicolors = true
vim.opt.modeline = false
vim.opt.swapfile = false

-- Filetype detection: built-in rules + every vim.filetype.add() your real
-- nvim config and plugins made (exported by lua/tools/filetype_export.lua on
-- startup). Open nvim once after installing a plugin to refresh it.
vim.cmd('filetype on')
local f = io.open(vim.fn.stdpath('state') .. '/filetypes.json', 'r')
if f then
  local ok, data = pcall(vim.json.decode, f:read('*a'))
  f:close()
  if ok and type(data) == 'table' then
    -- JSON turns the { 'ft', nil } form into { 'ft' }; both are valid here.
    if type(data.filetype) == 'table' then pcall(vim.filetype.add, data.filetype) end
    -- filetype -> parser, e.g. rest -> hcl
    for ft, lang in pairs(type(data.treesitter) == 'table' and data.treesitter or {}) do
      pcall(vim.treesitter.language.register, lang, ft)
    end
  end
end

-- Light/dark follows the terminal (yazi passes NVIM_PREVIEW_BG=light|dark).
local bg = os.getenv('NVIM_PREVIEW_BG')
if bg == 'light' or bg == 'dark' then vim.o.background = bg end

-- Match the editor's colorscheme (gruvbox) when it's installed, so the
-- preview colors line up with Neovim. Falls back to default colors otherwise.
local gruvbox = vim.fn.stdpath('data') .. '/lazy/gruvbox.nvim'
if vim.uv.fs_stat(gruvbox) then
  vim.opt.rtp:prepend(gruvbox)
  pcall(vim.cmd, 'colorscheme gruvbox')
end
