require('utils/augroup').create({
  sh_lsp = {
    {
      event = 'FileType',
      pattern = 'sh',
      callback = function()
        local cmd = vim.api.nvim_create_user_command
        cmd('Run', ':!chmod +x ./% && ./%', {})
      end,
    },
  },
})
