require('utils/augroup').create({
  sh_lsp = {
    {
      event = 'FileType',
      pattern = 'sh',
      callback = function()
        local command = vim.api.nvim_create_user_command
        command('Run', ':!./%%<cr>', {})
      end,
    },
  },
})
