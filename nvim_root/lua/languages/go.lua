local go = { }

local job = require('utils/job')

function go.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!go run ' .. file_name)
end

function go.test(args)
  local file_name = args.fargs[1]
  if file_name == '' then
    file_name = '.'
  end
  vim.api.nvim_command('!LOG_PLAIN=true go test -count=1 -v ' .. file_name)
end

require('utils/augroup').create({
  go_lsp = {
    {
      event = 'BufWritePre',
      pattern = '*.go',
      callback = go.organize_imports,
    },
    {
      event = 'FileType',
      pattern = 'gomod',
      callback = function()
        vim.bo.commentstring = '// %s'
      end,
    },
    {
      event = 'FileType',
      pattern = 'go',
      callback = function()
        local command = vim.api.nvim_create_user_command
        command('Run', go.run, { nargs = '?' })
        command('Test', go.test, { nargs = '?' })
        command('Tidy', '!go mod tidy', { nargs = '?' })
      end,
    },
  },
})

return go
