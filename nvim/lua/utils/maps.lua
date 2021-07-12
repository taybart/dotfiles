----------------------
-------- Maps --------
----------------------
local M = {}

local merge = require('utils').merge


local map = vim.api.nvim_set_keymap
function M.nmap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('n', key, cmd, opts)
end
function M.nnoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end

  map('n', key, cmd,  opts)
end
function M.imap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('i', key, cmd, opts)
end
function M.inoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end
  map('i', key, cmd, opts)
end
function M.vmap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('v', key, cmd, opts)
end
function M.vnoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end
  map('v', key, cmd, opts)
end
function M.cmap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('c', key, cmd, opts)
end
function M.cnoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end

  map('c', key, cmd,  opts)
end



return M
