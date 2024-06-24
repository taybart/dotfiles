local ts = {}

function ts.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!bun run ' .. file_name)
end

require('utils/augroup').create({
  ts_lsp = {
    {
      event = 'FileType',
      pattern = 'typescript',
      callback = function()
        vim.api.nvim_create_user_command('Run', ts.run, { nargs = '?' })
      end,
    },
  },
})

return ts
