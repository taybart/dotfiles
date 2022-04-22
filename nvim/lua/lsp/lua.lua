local M = {}

require('utils').create_augroups({
  lua_lsp = {
    {
      event = 'FileType',
      pattern = 'lua',
      callback = function()
        vim.api.nvim_create_user_command('Run', 'luafile %', {})
      end,
    },
  },
})

return M
