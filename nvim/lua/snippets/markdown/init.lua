---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
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
}, {}
