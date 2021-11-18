local luasnip = require("luasnip")

return {
  setup = function()
    vim.cmd [[
    hi CmpItemKind guifg=#928374
    hi CmpItemMenu guifg=#d5c4a1
    ]]
    local cmp = require('cmp')
    local compare = require('cmp.config.compare')
    cmp.setup {
      preselect = cmp.PreselectMode.None,
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
      },
      sources = {
        { name = 'code_actions' },
        { name = 'buffer', keyword_length = 4 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'neorg' },
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          compare.length,
          compare.kind,
          compare.sort_text,
          compare.order,
        },
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            calc = '[calc]',
            path = '[path]',
            luasnip = "[snippet]",
            buffer = '[buffer]',
            nvim_lsp = '[lsp]',
            nvim_lua = '[lua]',
          })[entry.source.name]
          return vim_item
        end,
      },
      experimental = {
        ghost_text = true,
      },
    }
  end,
}
