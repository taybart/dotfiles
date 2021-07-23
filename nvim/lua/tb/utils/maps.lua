----------------------
-------- Maps --------
----------------------
local M = {}

local merge = require('tb/utils').merge

local map = vim.api.nvim_set_keymap
-- normal map
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

-- insert map
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

-- visual map
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

-- command map
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

-- terminal map
function M.tmap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('t', key, cmd, opts)
end
function M.tnoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end

  map('t', key, cmd,  opts)
end

-- select map
function M.smap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('s', key, cmd, opts)
end
function M.snoremap(key, cmd, opts)
  if opts ~= nil then
    merge(opts, { noremap = true })
  else
    opts = {}
  end

  map('s', key, cmd,  opts)
end

return M
