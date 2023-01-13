return {
  'L3MON4D3/LuaSnip',
  config = function()
    local ls = require('luasnip')
    require('snippets').setup()
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
