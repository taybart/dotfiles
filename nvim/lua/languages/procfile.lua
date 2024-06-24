-- procfile
vim.filetype.add({ filename = { ['Procfile'] = 'procfile' } })
require('utils/augroup').create({
  procfile = {
    {
      event = 'FileType',
      pattern = 'procfile',
      callback = function()
        vim.bo.commentstring = '# %s'
        vim.cmd([[
            highlight ProcfileCmd guibg=Red ctermbg=2
            " syntax match ProcfileCmd "\vclient:"
            syntax match ProcfileCmd "\v\w\+"
          ]])
      end,
    },
  },
})
