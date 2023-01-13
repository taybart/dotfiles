local M = {}
function M.setup()
  local ls = require('luasnip')

  local i = ls.insert_node
  local f = ls.function_node
  local s = ls.s
  local fmt = require('luasnip.extras.fmt').fmt

  ls.add_snippets('lua', {
    s(
      'req',
      fmt([[local {} = require('{}')]], {
        f(function(name)
          local sp = vim.split(name[1][1], '.', true)
          return sp[#sp] or ''
        end, { 1 }),
        i(1),
      })
    ),
  })
end

return M
