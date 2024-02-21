return {
  'L3MON4D3/LuaSnip',
  event = 'VeryLazy',
  dependencies = { 'rafamadriz/friendly-snippets' },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').load({ paths = { '~/.config/nvim/lua/snippets' } })
    local ls = require('luasnip')
    require('utils/maps').group({ silent = true }, {
      {
        'i',
        '<c-e>',
        function()
          ls.jump(1)
        end,
      },
      {
        's',
        '<c-e>',
        function()
          ls.jump(1)
        end,
      },
    })
  end,
}
