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
vim.opt.completeopt={ 'menuone','noinsert','noselect' }

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
vim.opt.inccommand='nosplit'

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

-- gaps while scrolling
-- vim.opt.scrolloff=5

-- old school tty
vim.opt.colorcolumn='80'

--[[
set undodir=~/.vim/something
set undofile
]]--

require ('tb/plugins')
require ('tb/looks')
require ('tb/keymaps')
require ('tb/autocmds')
require ('tb/lsp')

-- setups



require('gitsigns').setup{
  current_line_blame = true,
  current_line_blame_delay = 0,
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  keymaps = {

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>ghr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>ghr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>ghR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>ghp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>ghb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
}
