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

-- local configs
vim.o.secure = true
-- vim.o.exrc = true

-- load exrc's from buffer to cwd
local exrc_loaded = {} ---@type table<string, true>
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('RecursiveExrc', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' then return end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == '' then return end


    local cwd = vim.fs.normalize(vim.uv.cwd())
    local dir = vim.fs.dirname(name)
    -- only files inside the cwd
    if dir ~= cwd and not vim.startswith(dir, cwd .. '/') then return end

    local found = vim.fs.find('.nvim.lua', {
      path = vim.fs.dirname(name),
      upward = true,
      -- stop = vim.uv.os_homedir(),
      stop = vim.fs.dirname(cwd), -- `stop` is exclusive, so use the parent to include cwd itself
      limit = math.huge,
    })
    for i = #found, 1, -1 do -- outermost directory first
      local f = found[i]
      if not exrc_loaded[f] then
        exrc_loaded[f] = true
        local content = vim.secure.read(f)
        if content then
          local chunk, lerr = load(content, '@' .. f)
          if chunk then
            local ok, rerr = pcall(chunk)
            if not ok then vim.notify(f .. ': ' .. rerr, vim.log.levels.ERROR) end
          else
            vim.notify(f .. ': ' .. lerr, vim.log.levels.ERROR)
          end
        end
      end
    end
  end,
})

-- FINALLY set global float border
vim.o.winborder = 'single'

-- speed up modules
vim.loader.enable()

-- recurse/wildcard path for native fin[d]
vim.o.path = vim.o.path .. ',**'


-- some weird pcre lpeg thing is causing this to fail
package.loaded['vim.lsp._watchfiles'] = {
  register = function() end,
  unregister = function() end,
  cancel = function() end,
}
-- ensure lazy is installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

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
require('commands')
require('lsp')

if vim.fn.has('mac') then vim.g.tagbar_ctags_bin = '/opt/homebrew/bin/ctags' end
