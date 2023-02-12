local M = {}

function M.setup()
  local ls = require('luasnip')

  local i = ls.insert_node
  local s = ls.s
  local fmt = require('luasnip.extras.fmt').fmt

  ls.add_snippets('markdown', {
    s(
      'td',
      fmt([[- [ ] {}]], {
        i(1),
      })
    ),
    s(
      'tdd',
      fmt([[- [x] {}]], {
        i(1),
      })
    ),
  })
end

return M
