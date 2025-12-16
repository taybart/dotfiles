-- Idiot proofing
local cmds = require('utils/commands')
cmds.add({
  { 'W',  'w' },
  { 'Q',  'q' },
  { 'WQ', 'wq' },
  { 'Wq', 'wq' },
})

if vim.fn.executable('unix-timestamp') and false then
  cmds.range('Date', 'unix-timestamp -u %s', { cli = true })
elseif vim.fn.has('mac') then
  -- cmds.one('Date', '<line1>,<line2>!xargs -I {} date -r {}', { range = true })
  cmds.range('Date', 'date -r %s', { cli = true, print = true })
else
  -- cmds.one('Date', '<line1>,<line2>!xargs -I {} date -d @{}', { range = true })
  cmds.range('Date', 'date -d @%s', { cli = true })
end
cmds.one('CopyPath', "let @+ = expand('%')")

local function gen_github_url(include_line, branch)
  local job = require('utils/job')
  local buf_name = vim.api.nvim_buf_get_name(0)
  -- if [No Name] open the main page
  local blob_tree = (buf_name == '') and '/tree/' or '/blob/'

  if branch == nil then branch = job.run('git', { 'branch', '--show-current' }) end

  local url = job.run('git', { 'config', '--get', 'remote.origin.url' })
      .. blob_tree
      .. branch
      .. buf_name:gsub(job.run('git', { 'rev-parse', '--show-toplevel' }):gsub('%p', '%%%1'), '')

  if include_line then url = url .. '#L' .. vim.api.nvim_win_get_cursor(0)[1] end
  return url
end

cmds.one('GH', function() require('utils/job').open({ gen_github_url() }) end)

local function github_line(args)
  local branch = args.fargs[1]
  require('utils/job').open({ gen_github_url(true, branch) })
end
cmds.one('GHL', github_line, { nargs = '?' })
