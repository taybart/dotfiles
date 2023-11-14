require('utils/augroup').create({
  json_lsp = {
    {
      event = 'FileType',
      pattern = 'json',
      callback = function()
        local command = vim.api.nvim_create_user_command
        command('Expand', '.!jq', {})
        command('Compact', '%!jq -c .', {})
      end,
    },
  },
})
