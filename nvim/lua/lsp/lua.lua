local M = {}

require('utils').create_augroups({
  lua_lsp = {
    { 'FileType', 'lua', 'command! Run luafile %' },
  },
})

return M
