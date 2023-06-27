return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-emoji' },
    { 'zbirenbaum/copilot-cmp', config = true },
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
        -- ['<C-y>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }),
        ['<C-j>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
      },
      sources = {
        -- { name = 'luasnip' },
        { name = 'copilot' },
        -- Other Sources
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'luasnip' },
        -- { name = 'copilot' },
        -- { name = 'path' },
        -- { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'buffer', keyword_length = 6 },
        { name = 'emoji' },
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })
  end,
}
