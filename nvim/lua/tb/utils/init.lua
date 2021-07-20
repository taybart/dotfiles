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

function M.reload_module(name)
 for k in pairs(package.loaded) do
   if k:match("^"..name) then
     package.loaded[k] = nil
   end
 end
  require(name)
end


function M.reload_vim()
  -- local reload_module = require('plenary.reload').reload_module

  -- reload_module("plugins", false)
  -- require('plugins')


  -- reload_module("looks", false)
  -- require('looks')

  M.reload_module("tb/keymaps")

  -- reload_module("autocmds", false)
  -- require('autocmds')

  M.reload_lsp()
end

function M.reload_lsp()
  M.reload_module('tb/lsp')
end


-- https://github.com/norcalli/nvim_utils
function M.create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

return M
