------------------------------
------------ init ------------
------------------------------

-- long live zsh
vim.opt.shell='/bin/zsh'

-- remove pauses after j in insert mode
vim.opt.timeoutlen=1000
vim.opt.ttimeoutlen=0

-- HoldCursor faster than 4s
vim.opt.updatetime=800

-- use system clipboard
vim.opt.clipboard:prepend({'unnamedplus'})

-- better completion actions
vim.opt.completeopt={'menuone','noinsert','noselect'}

-- cleaner completions
vim.opt.shortmess:append('c')

-- :h ww
vim.opt.whichwrap = 'b,s,<,>,[,]'

-- allow unsaved buffers
vim.opt.hidden=true

-- use 2 spaces as tabs and always
-- expand to spaces
vim.opt.expandtab=true
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.softtabstop=2

-- allow mouse scrolling
vim.opt.mouse='a'

-- show incomplete commands (like substitute)
-- vim.opt.inccommand='nosplit' -- now default!

-- put signs in the number column
-- vim.opt.signcolumn='number'
vim.opt.signcolumn = "yes"

-- numbas
vim.opt.number=true
vim.opt.relativenumber=true

-- allow more complicated font/color stuff
vim.opt.termguicolors=true

-- swapfile bad
vim.opt.swapfile=false
vim.opt.backup=false

-- keep it tight
vim.opt.colorcolumn='81'

-- vim.g.c_syntax_for_h=1

require ('tb/plugins')
require ('tb/looks')
require ('tb/keymaps')
require ('tb/lsp')

if vim.fn.has("mac") then
  vim.g.tagbar_ctags_bin='/opt/homebrew/bin/ctags'
end

----- AU ------
require('tb/utils').create_augroups({
  nvim = {
    { 'InsertEnter', '*', 'set timeoutlen=100' },
    { 'InsertLeave', '*', 'set timeoutlen=1000' },
  },

  packer = {
    {'BufWritePost', 'plugins.lua', 'source <afile> | PackerCompile'},
  },

  nvim_tree = {
    { 'BufEnter NvimTree set cursorline' },
  },

  language_autocmd = {
    { 'BufRead,BufNewFile', '*.tmpl', 'setfiletype gohtmltmpl' },
  },

  commentary = {
    { 'FileType helm setlocal commentstring=#\\ %s' },
    { 'FileType svelte setlocal commentstring=<!--\\ %s\\ -->' },
    { 'FileType gomod setlocal commentstring=//\\ %s' },
  },
  looks = {
    { 'BufEnter,FocusGained,InsertLeave', '*',
    'lua require("tb/looks").toggle_num(true)' },
    { 'BufLeave,FocusLost,InsertEnter', '*',
    'lua require("tb/looks").toggle_num(false)' },
  },
  whitespace = {
    { 'BufWinEnter', '<buffer>', 'match Error /\\s\\+$/' },
    { 'InsertEnter', '<buffer>', 'match Error /\\s\\+\\%#\\@<!$/' },
    { 'InsertLeave', '<buffer>', 'match Error /\\s\\+$/' },
    { 'BufWinLeave', '<buffer>', 'call clearmatches()' },
  },
  goyo = {
    { 'User GoyoEnter nested lua require("tb/autocmds").goyo_enter()' },
    { 'User GoyoLeave nested lua require("tb/autocmds").goyo_leave()' },
  },
})


-- setups

-- -- different config if in browser
-- if vim.g.started_by_firenvim ~= nil then
--     vim.opt.guifont='JetBrainsMono_Nerd_Font_Mono:h11'
--     vim.g['airline#extensions#tabline#enabled'] = 0
--     vim.g.airline_disable_statusline = 1
--     vim.opt.showmode=false
--     vim.opt.ruler=false
--     vim.opt.laststatus=0
--     vim.opt.showcmd=false
--     vim.opt.cmdheight=1
-- end
