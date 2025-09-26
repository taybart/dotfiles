local function run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo run ' .. file_name)
end

local function test(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo test ' .. file_name)
end

local cmds = require('utils/commands')
cmds.set_run({ cmd = run })
cmds.add({
  cmds = {
    { name = 'Test', cmd = test,          opts = { nargs = '?' } },
    { name = 'Rsx',  cmd = '!leptosfmt %' },
  }
})
