--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {
  items = {},
}

function source.fmt_items(input)
  local items = {}
  -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem
  for label, i in pairs(input) do
    local kind = require('blink.cmp.types').CompletionItemKind.Text
    local format = vim.lsp.protocol.InsertTextFormat.PlainText
    if i.is_snippet then
      kind = require('blink.cmp.types').CompletionItemKind.Snippet
      format = vim.lsp.protocol.InsertTextFormat.Snippet
    end
    local doc = nil
    if i.documentation then
      doc = {
        kind = 'markdown',
        value = i.documentation,
      }
    end
    table.insert(items, {
      label = label,
      kind = kind,
      documentation = doc,
      filterText = i.filter_text,
      sortText = i.sort_text,
      insertTextFormat = format,
      insertText = i.insert_text,
      cb = i.cb,
    })
  end
  return items
end

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  self.items = opts.items
  return self
end

-- (Optional) Enable the source in specific contexts only
function source:enabled()
  ---@diagnostic disable-next-line: undefined-field
  if self.opts.ft then return vim.tbl_contains(self.opts.ft, vim.bo.filetype) end
  return true
end

-- (Optional) Non-alphanumeric characters that trigger the source
function source:get_trigger_characters() return { '.' } end

function source:get_completions(ctx, callback)
  -- local items = add_items(items_test)

  callback({
    items = self.items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })

  -- cancel function
  return function() end
end

-- (Optional) Before accepting the item or showing documentation, blink.cmp will call this function
-- so you may avoid calculating expensive fields (e.g. documentation) for only when they're actually needed
-- Note only some fields may be resolved lazily. You may check the LSP capabilities for a complete list:
-- `textDocument.completion.completionItem.resolveSupport`
-- At the time of writing: 'documentation', 'detail', 'additionalTextEdits', 'command', 'data'
function source:resolve(item, callback)
  -- local source_item = source.items[item.label]

  item = vim.deepcopy(item)

  ---@diagnostic disable-next-line: undefined-field
  if item.cb then item.insertText = item.cb(item) end

  -- item.documentation = source_item.documentation
  -- if source_item.cb then item.insertText = source_item.cb(item) end

  callback(item)
end

-- (Optional) Called immediately after applying the item's textEdit/insertText
-- Only useful when you want to customize how items are accepted,
-- beyond what's possible with `textEdit` and `additionalTextEdits`
function source:execute(ctx, item, callback, default_implementation)
  -- When you provide an `execute` function, your source must handle the execution
  -- of the item itself, but you may use the default implementation at any time
  default_implementation()

  -- The callback _MUST_ be called once
  callback()
end

return source
