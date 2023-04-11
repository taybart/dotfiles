local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

local snippets = {

  s(
    'fc',
    fmt(
      [=[
const {}: FC = () => {{
  return <>{}</>
}}
]=],
      {
        i(1, 'App'),
        i(2),
      }
    )
  ),

  ------------------------------------------------------ Snippets go here
}

local autosnippets = {}

return snippets, autosnippets
