local M = {}

-- LSP Setup
function M.setup()
  -- language specific stuff
  require('languages/go')
  require('languages/json')
  require('languages/lua')
  require('languages/python')
  require('languages/rest')
  require('languages/sh')

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


  local telescope = require('telescope.builtin')
  require('utils/maps').mode_group('n', {
    { 'gi', vim.lsp.buf.implementation },
    { '[d', vim.diagnostic.goto_next },
    { ']d', vim.diagnostic.goto_prev },
    { 'E', vim.diagnostic.open_float },
  }, { noremap = true, silent = true })
end

return M
