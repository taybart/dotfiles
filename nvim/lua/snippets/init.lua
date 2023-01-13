local M = {}

function M.setup()
  require('snippets/go').setup()
  require('snippets/lua').setup()
  require('snippets/markdown').setup()

  -- local ls = require('luasnip')
  -- local i = ls.insert_node
  -- local f = ls.function_node
  -- local s = ls.s
  -- local fmt = require('luasnip.extras.fmt').fmt
  -- ls.add_snippets('all', {
  --   s(
  --     -- TODO: should make a title comment
  --     'title',
  --     fmt([[{}{}{}]], {
  --       f(function()
  --         -- TODO: get comment string
  --         return ''
  --       end),
  --       i(2), -- TODO: function to surround input and break if too long
  --       f(function()
  --         -- TODO: get comment string
  --         return ''
  --       end),
  --     })
  --   ),
  -- })
end

return M
