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
  local cursor_node = vim.treesitter.get_node()
  if cursor_node == nil then return '' end
  -- TODO: keep up to date on locals, since its a very unpolished package
  local scope = require('nvim-treesitter-locals/locals').get_scope_tree(cursor_node, 0)

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

  -- get return types
  local query = vim.treesitter.query.parse(
    'go',
    [[
[
(function_declaration result: (_) @id)
(method_declaration result: (_) @id)
(func_literal result: (_) @id)
]
]]
  )
  if not query then
    error('could not parse ts query for getting go return types')
    return ''
  end
  local result = ''
  for _, node in query:iter_captures(function_node, 0) do
    if node:type() == 'parameter_list' then
      local count = node:named_child_count()
      for j = 0, count - 1 do
        local child = node:named_child(j)
        if child then
          result = result .. get_zero_value(vim.treesitter.get_node_text(child, 0))
          if j ~= count - 1 then result = result .. ', ' end
        end
      end
    elseif node:type() == 'type_identifier' then
      result = get_zero_value(vim.treesitter.get_node_text(node, 0))
    end
  end
  return result
end

local function ife()
  return ([[if err != nil {
  return %s
}
$0]]):format(go_ret_vals())
end
local snippets = {
  ['ife'] = {
    filter_text = 'ife',
    is_snippet = true,
    cb = ife,
    documentation = '# Foo\n\nBar',
  },
}

return {
  new = function(opts)
    local source = require('tools/blink_source')
    opts.ft = { 'go' }
    opts.items = source.fmt_items(snippets)
    return source.new(opts)
  end,
}
