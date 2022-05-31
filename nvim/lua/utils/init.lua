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

function M.create_augroups(definitions)
  for group_name, autocmd in pairs(definitions) do
    -- print(group_name, autocmd[1])
    vim.api.nvim_create_augroup(group_name, {})
    for _, au in ipairs(autocmd) do
      -- print(vim.inspect(au))
      vim.api.nvim_create_autocmd(au.event, {
        group = group_name,
        pattern = au.pattern,
        callback = au.callback,
      })
    end
  end
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

vim.api.nvim_create_user_command('GH', function()
  local opener = ''
  if vim.fn.has('mac') == 1 then
    opener = 'open'
  elseif vim.fn.has('unix') then
    opener = 'xdg-open'
  else
    print('unknown os')
    return
  end

  local job = require('utils/job')

  local buf_name = vim.api.nvim_buf_get_name(0)
  local url = job.run('git', { 'config', '--get', 'remote.origin.url' })
    .. '/blob/'
    .. job.run('git', { 'branch', '--show-current' })
    .. buf_name:gsub(job.run('git', { 'rev-parse', '--show-toplevel' }):gsub('%p', '%%%1'), '')

  job.run(opener, { url })
end, {
  desc = 'Open file in GitHub',
})

return M
