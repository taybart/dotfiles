local M = {}

function M.merge(first, second)
  for k,v in pairs(second) do
    first[k] = v
  end
end


function M.has_neovim_v05()
  if vim.fn.has('nvim-0.5') == 1 then
    return true
  end
  return false
end

function M.is_root()
  local output = vim.fn.systemlist "id -u"
  return ((output[1] or "") == "0")
end

function M.is_darwin()
  local os_name = vim.loop.os_uname().sysname
  return os_name == 'Darwin'
  --[[ local output = vim.fn.systemlist "uname -s"
  return not not string.find(output[1] or "", "Darwin") ]]
end

----------------------
-------- Maps --------
----------------------
local map = vim.api.nvim_set_keymap
function M.nmap(key, cmd, opts)
  if opts == nil then
    opts = {}
  end
  map('n', key, cmd, opts)
end
function M.nnoremap(key, cmd, opts)
  if opts ~= nil then
    M.merge(opts, { noremap = true })
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
    M.merge(opts, { noremap = true })
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
    M.merge(opts, { noremap = true })
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
    M.merge(opts, { noremap = true })
  else
    opts = {}
  end

  map('c', key, cmd,  opts)
end

return M
