local luasnip = require("luasnip")
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

return {
  setup = function()
    local cmp = require('cmp')
    local compare = require('cmp.config.compare')
    cmp.setup {
      sources = {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        -- { name = 'nvim_lua' },
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
      preselect = cmp.PreselectMode.None,
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ['<s-tab>'] = cmp.mapping(function(fallback)
          if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-p>"), "n")
          elseif luasnip.jumpable(-1) then
            vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
          else
            fallback()
          end
        end, {'i', 's'}),
        ['<tab>'] = cmp.mapping(function(fallback)
          if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t('<C-n>'), 'n')
          elseif luasnip.expand_or_jumpable() then
            vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
          elseif check_back_space() then
            vim.fn.feedkeys(t('<Tab>'), 'n')
          else
            fallback()
          end
        end, {'i', 's'}),
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
    }
  end,
}
