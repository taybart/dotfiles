local M = {}

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
  -- M.reload_module('tb/plugins')
  vim.cmd('source '..vim.fn.stdpath('config')..'/lua/tb/plugins.lua | PackerCompile')
  M.reload_module('tb/utils')
  M.reload_module('tb/keymaps')
  M.reload_module('tb/looks')
  M.reload_module('tb/lsp')
  M.reload_module('init')
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

-- function M.create_vim_function(name, package, method)
--   print("function! "..name.."()\n  lua require('"..package.."')."..method.."()\nendfunction")
--   vim.cmd("function! "..name.."()\n lua require('"..package.."')."..method.."()\nendfunction")
-- end

function M.sync_nvim_tree_width()
  local width = vim.g.nvim_tree_auto_width
  if type(vim.g.nvim_tree_auto_width) == "string" then
    local as_number = tonumber(vim.g.nvim_tree_auto_width:sub(0, -2))
    width = math.floor(vim.o.columns * (as_number / 100))
  end
  vim.api.nvim_win_set_width(require('nvim-tree.view').get_winnr(), width)
end

function M.to_string(tbl)
    if "nil" == type(tbl) then return tostring(nil)
    elseif "table" == type(tbl) then return M.table_print(tbl)
    elseif  "string" == type(tbl) then return tbl
    else return tostring(tbl)
    end
end

return M
