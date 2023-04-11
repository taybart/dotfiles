---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
return {
  s(
    'req',
    fmt([[local {} = require('{}')]], {
      f(function(name)
        local sp = vim.split(name[1][1], '.', { plain = true })
        return sp[#sp] or ''
      end, { 1 }),
      i(1),
    })
  ),
  s(
    'func',
    fmt('local function {}({})\nend', {
      i(1),
      i(2),
    })
  ),
}, {}
