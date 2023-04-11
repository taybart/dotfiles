---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
return {
  s(
    'useState',
    fmt([[const [{}, {}] = useState({})]], {
      i(1, 'state'),
      f(function(name)
        return 'set' .. name[1][1]:gsub('^%l', string.upper)
      end, { 1 }),
      i(2),
    })
  ),
}, {}
