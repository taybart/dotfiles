-- Idiot proofing
local cmds = require('utils/commands')
cmds.add({
  { 'W',  'w' },
  { 'Q',  'q' },
  { 'WQ', 'wq' },
  { 'Wq', 'wq' },
})

cmds.one('CopyPath', "let @+ = expand('%')")

if vim.fn.executable('unix-timestamp') then
  cmds.range('Date', 'unix-timestamp -u %s', { cli = true })
elseif vim.fn.has('mac') then
  cmds.range('Date', 'date -r %s', { cli = true, print = true })
else
  cmds.range('Date', 'date -d @%s', { cli = true })
end

-- local function gen_github_url(include_line, branch)
local function gen_github_url(opts)
  local job = require('utils/job')
  local buf_name = vim.api.nvim_buf_get_name(0)
  -- if [No Name] open the main page
  local blob_tree = (buf_name == '') and '/tree/' or '/blob/'

  if opts.branch == nil then opts.branch = job.run('git', { 'branch', '--show-current' }) end

  local url = job.run('git', { 'config', '--get', 'remote.origin.url' })
      .. blob_tree
      .. opts.branch
      .. buf_name:gsub(job.run('git', { 'rev-parse', '--show-toplevel' }):gsub('%p', '%%%1'), '')

  if opts.include_line then url = url .. '#L' .. vim.api.nvim_win_get_cursor(0)[1] end
  return url
end

cmds.add({
  { 'GH', function() require('utils/job').open({ gen_github_url() }) end },
  {
    'GHL',
    {
      cmd = function(args)
        local branch = args.fargs[1]
        require('utils/job').open({ gen_github_url({ include_line = true, branch = branch }) })
      end,
      opts = { nargs = '?' },
    },
  },
})
