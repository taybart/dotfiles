---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
return {
  s(
    { trig = 'hr', name = 'Header' },
    fmt(
      [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
      {
        f(function()
          local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '*')
          return comment .. string.rep('*', 30 - #comment)
        end),
        f(function()
          return vim.bo.commentstring:gsub('%%s', '')
        end),
        i(1, 'HEADER'),
        i(0),
      }
    )
  ),
}, {}
