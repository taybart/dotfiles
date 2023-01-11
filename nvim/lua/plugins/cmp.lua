return {
setup = function()
  vim.cmd([[
    hi CmpItemKind guifg=#928374
    hi CmpItemMenu guifg=#d5c4a1
    ]])
  local cmp = require('cmp')
  cmp.setup({
    preselect = cmp.PreselectMode.None,
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip' },
      -- { name = 'code_actions' },
      { name = 'path' },
      { name = 'buffer', keyword_length = 6 },
      { name = 'emoji' },
      { name = 'calc' },
      -- { name = 'neorg' },
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
  })
end,
}
