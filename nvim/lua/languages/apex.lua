require('utils/augroup').create({
  apex_lsp = {
    {
      event = 'BufRead',
      pattern = '*.cls',
      callback = function()
        vim.opt.filetype = 'apex'
      end,
    },
  },
})
