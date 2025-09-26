local function filter(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end
return {
  -- https://github.com/typescript-language-server/typescript-language-server/issues/216
  handlers = {
    ['textDocument/definition'] = function(err, result, method, ...)
      if vim.islist(result) then
        if #result > 1 then
          local filtered = filter(result, filterReactDTS)
          return vim.lsp.handlers['textDocument/definition'](err, filtered, method, ...)
        end
      end
      vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
    end,
  },
}
