-- procfile
local au = require('utils/augroup')

vim.filetype.add({ filename = { ['Procfile'] = 'procfile' } })
au.create({
  procfile = {
    au.ft_cmd('procfile', {
      callback = function()
        vim.bo.commentstring = '# %s'
        vim.cmd([[
            highlight ProcfileCmd guibg=Red ctermbg=2
            " syntax match ProcfileCmd "\vclient:"
            syntax match ProcfileCmd "\v\w\+"
          ]])
      end,
    }),
  },
})
