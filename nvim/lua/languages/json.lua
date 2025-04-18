local au = require('utils/augroup')
au.create({
  json_lsp = {
    au.ft_cmd('json', {
      commands = {
        { name = 'Expand', cmd = '.!jq' },
        { name = 'Compact', cmd = '%!jq -c .' },
      },
    }),
  },
})
