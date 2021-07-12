------------------------------
------------ init ------------
------------------------------

-- filetype plugin indent on

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
vim.optcompleteopt={ 'menuone','noinsert','noselect' }

-- cleaner completions
-- vim.opt.shortmess:append('c')

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
vim.opt.signcolumn='number'


-- numbas
vim.opt.number=true
vim.opt.relativenumber=true

-- allow more complicated font/color stuff
vim.opt.termguicolors=true

require ('plugins')
require ('lsp')
require ('looks')
require ('keymaps')
require ('autocmds')
