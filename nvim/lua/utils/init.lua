local M = {}

function M.is_root()
  local output = vim.fn.systemlist('id -u')
  return ((output[1] or '') == '0')
end

function M.reload_module(name)
  for k in pairs(package.loaded) do
    if k:match('^' .. name) then
      package.loaded[k] = nil
    end
  end
  require(name)
end

function M.reload_vim()
  -- M.reload_module('plugins')
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/lua/plugins/init.lua | PackerCompile')
  M.reload_module('utils')
  M.reload_module('keymaps')
  M.reload_module('looks')
  M.reload_module('lsp')
  M.reload_module('init')
end

-- https://github.com/norcalli/nvim_utils
function M.create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
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
  if type(vim.g.nvim_tree_auto_width) == 'string' then
    local as_number = tonumber(vim.g.nvim_tree_auto_width:sub(0, -2))
    width = math.floor(vim.o.columns * (as_number / 100))
  end
  vim.api.nvim_win_set_width(require('nvim-tree.view').get_winnr(), width)
end

function M.to_string(tbl)
  if 'nil' == type(tbl) then
    return tostring(nil)
  elseif 'table' == type(tbl) then
    return M.table_print(tbl)
  elseif 'string' == type(tbl) then
    return tbl
  else
    return tostring(tbl)
  end
end

vim.cmd([[
command! GH lua require('utils').open_file_in_github()
]])
function M.open_file_in_github()
  local opener = ''
  if vim.fn.has('mac') == 1 then
    opener = 'open'
  elseif vim.fn.has('unix') then
    opener = 'xdg-open'
  else
    print('unknown os')
    return
  end

  local run_job = require('utils/job')

  local buf_name = vim.api.nvim_buf_get_name(0)
  local url = run_job('git', { 'config', '--get', 'remote.origin.url' })
    .. '/blob/'
    .. run_job('git', { 'branch', '--show-current' })
    .. buf_name:gsub(run_job('git', { 'rev-parse', '--show-toplevel' }), '')

  run_job(opener, { url })
end

return M
