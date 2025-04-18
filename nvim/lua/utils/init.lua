local M = {}

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

local function gen_github_url(include_line, branch)
  local buf_name = vim.api.nvim_buf_get_name(0)
  -- if [No Name] open the main page
  local blob_tree = (buf_name == '') and '/tree/' or '/blob/'

  if branch == nil then
    branch = job.run('git', { 'branch', '--show-current' })
  end

  local url = job.run('git', { 'config', '--get', 'remote.origin.url' })
    .. blob_tree
    .. branch
    .. buf_name:gsub(job.run('git', { 'rev-parse', '--show-toplevel' }):gsub('%p', '%%%1'), '')

  if include_line then
    url = url .. '#L' .. vim.api.nvim_win_get_cursor(0)[1]
  end
  return url
end

vim.api.nvim_create_user_command('GH', function()
  job.open({ gen_github_url() })
end, {
  desc = 'Open file in GitHub',
})

vim.api.nvim_create_user_command('GHL', function(args)
  local branch = args.fargs[1]
  job.open({ gen_github_url(true, branch) })
end, {
  desc = 'Open file in GitHub including line',
  nargs = '?',
})

return M
