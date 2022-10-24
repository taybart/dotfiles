local rust = {}

function rust.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo run ' .. file_name)
end

require('utils').create_augroups({
  rust_lsp = {
    {
      event = 'FileType',
      pattern = 'rust',
      callback = function()
        vim.api.nvim_create_user_command('Run', rust.run, { nargs = '?' })
      end,
    },
  },
})

return rust
