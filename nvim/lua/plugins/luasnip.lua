return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  config = function()
    require('luasnip.loaders.from_lua').load({ paths = { '~/.config/nvim/lua/snippets' } })
    local ls = require('luasnip')
    require('utils/maps').group({ silent = true }, {
      {
        { 'i', 's' },
        '<c-j>',
        function()
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          else
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes('<c-j>', true, true, true),
              'n',
              true
            )
          end
        end,
      },
      {
        { 'i', 's' },
        '<c-k>',
        function()
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
      },
      {
        { 'i', 's' },
        '<c-p>',
        function()
          if ls.choice_active() then
            ls.change_choice(-1)
          end
        end,
      },
      {
        { 'i', 's' },
        '<c-n>',
        function()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
      },
    })
  end,
}
