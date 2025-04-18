local au = require('utils/augroup')
au.create({
  sh_lsp = {
    au.ft_cmd('sh', { run_cmd = 'chmod +x ./% && ./% %@' }),
  },
})
