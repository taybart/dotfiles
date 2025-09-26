local cmds = require('utils/commands')

local function run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!bun run ' .. file_name)
end

cmds.set_run(run)
