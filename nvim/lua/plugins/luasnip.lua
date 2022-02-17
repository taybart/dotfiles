local ls = require('luasnip')

ls.config.set_config({
  -- history = false,
  -- updateevents = 'TextChanged,TextChangedI',
})

local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
-- local f = ls.function_node

local str = function(text)
  return t({ text })
end

local ts_locals = require('nvim-treesitter.locals')
local ts_utils = require('nvim-treesitter.ts_utils')

local get_node_text = vim.treesitter.get_node_text

vim.treesitter.set_query(
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

  local query = vim.treesitter.get_query('go', 'LuaSnip_ReturnTypes')
  local result = ''
  for _, node in query:iter_captures(function_node, 0) do
    if node:type() == 'parameter_list' then
      local count = node:named_child_count()
      for j = 0, count - 1 do
        print(get_zero_value(get_node_text(node:named_child(j), 0)))
        result = result .. get_zero_value(get_node_text(node:named_child(j), 0))
        if j ~= count - 1 then
          result = result .. ', '
        end
      end
    elseif node:type() == 'type_identifier' then
      result = get_zero_value(get_node_text(node, 0))
    end
  end
  return str(result)
end

local s = ls.s
local fmt = require('luasnip.extras.fmt').fmt
ls.snippets = {
  go = {
    s('main', fmt('package main\nfunc main(){{\n\t{}\n}}', { i(0) })),
    s('ife', fmt('if err != nil {{\n\treturn {}\n}}\n', { d(1, go_ret_vals, {}) })),
  },
}

require('utils/maps').group({ silent = true }, {
  { 'i', '<c-e>', "<cmd>lua require('luasnip').jump(1)<CR>" },
  { 's', '<c-e>', "<cmd>lua require('luasnip').jump(1)<CR>" },
})
