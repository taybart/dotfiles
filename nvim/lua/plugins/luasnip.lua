return {
  'L3MON4D3/LuaSnip',
  config = function()
    require('snippets').setup()
    require('utils/maps').group({ silent = true }, {
      {
        'i',
        '<c-e>',
        function()
          require('luasnip').jump(1)
        end,
      },
      {
        's',
        '<c-e>',
        function()
          require('luasnip').jump(1)
        end,
      },
    })
  end,
}
