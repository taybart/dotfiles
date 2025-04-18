local ts = {}

local au = require('utils/augroup')

function ts.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!bun run ' .. file_name)
end

au.create({
  ts_lsp = {
    au.ft_cmd('typescript', { run_cmd = ts.run }),
  },
})

return ts
