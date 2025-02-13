---@diagnostic disable: undefined-global
---@diagnostic disable-next-line: unused-local
return {
  s(
    'html',
    fmt(
      [[
    <!DOCTYPE html>
    <html>
      <head>
        <title>index</title>
      </head>
      <body>
        <h1>{}</h1>
      </body>
    </html>
    ]],
      {

        i(1),
      }
    )
  ),
}, {}
