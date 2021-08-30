return {
  setup = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      cmp.setup {
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'nvim_lua' },
          { name = 'calc' },
          { name = 'neorg' },
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
          ['<s-tab>'] = cmp.mapping.select_previous_item,
          ['<tab>'] = function(fallback)
            local check_back_space = function()
              local col = vim.fn.col('.') - 1
              return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
            end
            local t = function(str)
              return vim.api.nvim_replace_termcodes(str, true, true, true)
            end
            if vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(t('<C-n>'), 'n')
            elseif check_back_space() then
              vim.fn.feedkeys(t('<Tab>'), 'n')
            else
              fallback()
            end
          end,
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              calc = '[Calc]',
              path = '[Path]',
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
            })[entry.source.name]
            return vim_item
          end,
        },
      }
  end,
}
