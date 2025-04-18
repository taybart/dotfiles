------------------------------
------------ init ------------
------------------------------

-- remove pauses after j in insert mode
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- HoldCursor faster than 4s
vim.opt.updatetime = 800

-- use system clipboard
vim.opt.clipboard:prepend({ 'unnamedplus' })

-- better completion actions
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- cleaner completions
vim.opt.shortmess:append('c')

-- :h ww
vim.opt.whichwrap = 'b,s,<,>,[,]'

-- allow unsaved buffers
vim.opt.hidden = true

-- use 2 spaces as tabs and always
-- expand to spaces
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- allow mouse scrolling
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'

-- add sign column always
vim.opt.signcolumn = 'yes'

-- numbas
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

-- allow more complicated font/color stuff
vim.opt.termguicolors = true

-- swapfile bad
vim.opt.swapfile = false
vim.opt.backup = false

-- keep it tight
vim.opt.colorcolumn = '100'

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- don't wrap lines
-- vim.opt.wrap = false

-- vim.g.c_syntax_for_h=1

-- speed up modules
vim.loader.enable()

-- ensure lazy is installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: inject-field
vim.g.mapleader = ' '

require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'single',
  },
})

vim.cmd([[pa cfilter]])

require('looks')
require('keymaps')
require('utils')
require('commands')

if vim.fn.has('mac') then
  vim.g.tagbar_ctags_bin = '/opt/homebrew/bin/ctags'
end
