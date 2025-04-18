local rust = {}

function rust.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo run ' .. file_name)
end

function rust.test(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo test ' .. file_name)
end

local au = require('utils/augroup')
au.create({
  rust_lsp = {
    au.ft_cmd('rust', {
      run_cmd = rust.run,
      commands = {
        { name = 'Test', cmd = rust.test, opts = { nargs = '?' } },
        { name = 'Rsx', cmd = '!leptosfmt %' },
      },
    }),
  },
})

return rust
