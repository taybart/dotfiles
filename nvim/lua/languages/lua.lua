local au = require('utils/augroup')
au.create({
  lua_lsp = {
    au.ft_cmd('lua', { run_cmd = 'luafile %', run_no_bang = true }),
  },
})
