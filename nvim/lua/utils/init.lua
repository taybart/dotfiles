local M = {
  create_augroups = require('utils/augroup').create_augroups,
}
local job = require('utils/job')

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
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/lua/plugins/init.lua | PackerCompile')
  M.reload_module('utils')
  M.reload_module('keymaps')
  M.reload_module('looks')
  M.reload_module('lsp')
  M.reload_module('init')
end

local function gen_github_url(include_line)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local url = job.run('git', { 'config', '--get', 'remote.origin.url' })
    .. '/blob/'
    .. job.run('git', { 'branch', '--show-current' })
    .. buf_name:gsub(job.run('git', { 'rev-parse', '--show-toplevel' }):gsub('%p', '%%%1'), '')

  if include_line then
    url = url .. '#L' .. vim.api.nvim_win_get_cursor(0)[1]
  end
end

vim.api.nvim_create_user_command('GH', function()
  job.open({ gen_github_url() })
end, {
  desc = 'Open file in GitHub',
})

vim.api.nvim_create_user_command('GHL', function()
  job.open({ gen_github_url(true) })
end, {
  desc = 'Open file in GitHub including line',
})

return M
