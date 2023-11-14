return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
  },
  event = 'InsertEnter',
  config = function()
    vim.cmd([[
    hi CmpItemKind guifg=#928374
    hi CmpItemMenu guifg=#d5c4a1
    ]])
    local cmp = require('cmp')
    cmp.setup({
      preselect = cmp.PreselectMode.None,
      mapping = {
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }),
        ['<C-j>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
      },
      sources = {
        { name = 'luasnip' },
        -- Other Sources
        { name = 'path' },
        { name = 'buffer', keyword_length = 6 },
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })
    -- cmp.setup.cmdline({ '/', '?' }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'buffer' },
    --   },
    -- })
  end,
}
