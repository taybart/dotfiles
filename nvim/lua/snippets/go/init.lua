local ls = require('luasnip')
local s = ls.s
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

local ts_locals = require('nvim-treesitter.locals')
local ts_utils = require('nvim-treesitter.ts_utils')

local get_node_text = vim.treesitter.get_node_text

vim.treesitter.query.set(
  'go',
  'LuaSnip_ReturnTypes',
  [[
[
(function_declaration result: (_) @id)
(method_declaration result: (_) @id)
(func_literal result: (_) @id)
]
]]
)

local function get_zero_value(text)
  if text:find('^int') or text:find('^uint') or text == 'byte' or text == 'rune' then
    return '0'
  elseif text:find('^%[]') then
    return 'nil'
  elseif text == 'error' then
    return 'err'
  elseif text == 'bool' then
    return 'false'
  elseif text == 'string' then
    return '""'
  elseif text:find('^%*') then -- pointer
    return 'nil'
  else
    return text .. '{}'
  end
end

local function go_ret_vals()
  local cursor_node = ts_utils.get_node_at_cursor()
  local scope = ts_locals.get_scope_tree(cursor_node, 0)

  local function_node
  for _, v in ipairs(scope) do
    if
      v:type() == 'function_declaration'
      or v:type() == 'method_declaration'
      or v:type() == 'func_literal'
    then
      function_node = v
      break
    end
  end

  local query = vim.treesitter.query.get('go', 'LuaSnip_ReturnTypes')
  local result = ''
  for _, node in query:iter_captures(function_node, 0) do
    if node:type() == 'parameter_list' then
      local count = node:named_child_count()
      for j = 0, count - 1 do
        result = result .. get_zero_value(get_node_text(node:named_child(j), 0))
        if j ~= count - 1 then
          result = result .. ', '
        end
      end
    elseif node:type() == 'type_identifier' then
      result = get_zero_value(get_node_text(node, 0))
    end
  end
  return result
end

local snippets = {
  s(
    { trig = 'dbg', name = 'print var', dscr = 'Print a variable' },
    fmt([[fmt.Printf("%+v\n",{})]], {
      i(1, 'value'),
    })
  ),
  s(
    { trig = 'dbgs', name = 'debug format string', dscr = 'Add debug format string' },
    fmt('%+v\n', {})
  ),
  s(
    { trig = 'ife', name = 'if error', dscr = 'check err' },
    fmt(
      [[if err != nil {{
  return {}{}
}}
      ]],
      { f(go_ret_vals), i(0) }
    )
  ),
  s(
    'sb',
    fmt(
      [[func main(){{
          if err := run(); err != nil {{
            fmt.Println(err)
            os.Exit(1)
          }}
        }}
        func run() error {{
          {}
        }}]],
      { i(0) }
    )
  ),
}

local autosnippets = {}

return snippets, autosnippets
