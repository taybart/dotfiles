local ls = require('luasnip')
local s = ls.s
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

local snippets = {
  s(
    { trig = 'read', name = 'read_file', dscr = 'Read file to string' },
    fmt([[let data = std::fs::read_to_string("{}").expect("Unable to read file");]], {
      i(1, 'path'),
    })
  ),
}

local autosnippets = {}

return snippets, autosnippets
