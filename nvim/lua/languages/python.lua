local au = require('utils/augroup')
au.create({
  python_lsp = {
    au.ft_cmd('python', { run_cmd = 'python %' }),
  },
})
