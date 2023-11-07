require('utils/augroup').create({
  sh_lsp = {
    {
      event = 'FileType',
      pattern = 'sh',
      callback = function()
        vim.api.nvim_create_user_command('Run', ':!./%', {})
      end,
    },
  },
})
