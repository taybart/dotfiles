-- functional snippets package

local function header()
  local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '*')
  return ('%s%s \n\t${0:HEADER}\n%s%s'):format(
    comment,
    string.rep('*', 30 - #comment),
    comment,
    string.rep('*', 30 - #comment)
  )
end
local snippets = {
  ['hr'] = {
    filter_text = 'hr',
    is_snippet = true,
    cb = header,
    documentation = 'add header comment',
  },
}

return {
  new = function(opts)
    local source = require('utils/blink_source')
    opts.items = source.fmt_items(snippets)
    return source.new(opts)
  end,
}
