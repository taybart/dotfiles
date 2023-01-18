local M = {}

function M.setup()
  require('snippets/go').setup()
  require('snippets/lua').setup()
  require('snippets/markdown').setup()

  local ls = require('luasnip')
  local i = ls.insert_node
  local f = ls.function_node
  local s = ls.s
  local fmt = require('luasnip.extras.fmt').fmt
  ls.add_snippets('all', {
    s(
      { trig = 'hr', name = 'Header' },
      fmt(
        [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
        {
          f(function()
            local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '*')
            return comment .. string.rep('*', 30 - #comment)
          end),
          f(function()
            return vim.bo.commentstring:gsub('%%s', '')
          end),
          i(1, 'HEADER'),
          i(0),
        }
      )
    ),
  })
end

return M
