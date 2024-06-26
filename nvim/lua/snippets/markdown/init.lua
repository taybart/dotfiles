---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local

local function time()
  return vim.fn.strftime('%H:%M')
end

return {
  s(
    'td',
    fmt([[- [ ] {}]], {
      i(1),
    })
  ),
  s(
    'tdd',
    fmt([[- [x] {}]], {
      i(1),
    })
  ),
  s(
    'dip',
    fmt([[- {} {}]], {
      f(time),
      i(1),
    })
  ),
  s(
    'now',
    fmt([[{}]], {
      f(time),
    })
  ),
}, {}
