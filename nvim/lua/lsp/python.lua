require('utils/augroup').create({
  python_lsp = {
    {
      event = 'FileType',
      pattern = 'python',
      callback = function()
        vim.api.nvim_create_user_command('Run', '!python %', { nargs = '?' })
      end,
    },
  },
})
