return {
  s({ trig = 'locals' }, fmt([[locals {{ {} }}]], { i(1) })),
  s(
    { trig = 'request' },
    fmt(
      [[request "{}" {{
  url = "{}"
  method = "{}"
  body = {{{}}}
}}]],
      {
        i(1, 'test'),
        i(2, 'http://localhost:18080'),
        c(3, { t('GET'), t('POST'), t('PUT'), t('PATCH'), t('DELETE'), t('HEAD'), t('OPTIONS') }),
        i(4, ''),
      }
    )
  ),
  s(
    { trig = 'expect' },
    fmt(
      [[ expect {{
      status = {}
      body = {{{}}}
    }} ]],
      { i(1, '200'), i(2, '') }
    )
  ),
  s({ trig = 'basic_auth' }, fmt([[ basic_auth =  "{}:{}" ]], { i(1, 'user'), i(2, 'password') })),
  s(
    { trig = 'post_hook' },
    fmt(
      [[post_hook = <<LUA
  local body = json.decode(rest.res.body)
  inspect.print(body)
  {}
LUA]],
      { i(1, '') }
    )
  ),

  s(
    { trig = 'request_full' },
    fmt(
      [[request "{}" {{
  url = "{}"
  method = "{}"
  basic_auth = "username:password"
  bearer_token = "token"
  headers = {{}}
  cookies = {{}}
  query = {{}}
  body = {{}}
  post_hook = <<LUA
  LUA
}}]],
      {
        i(1, 'test'),
        i(2),
        c(3, { t('GET'), t('POST'), t('PUT'), t('PATCH'), t('DELETE'), t('HEAD'), t('OPTIONS') }),
      }
    )
  ),
  s(
    { trig = 'server' },
    fmt(
      [[server {{
  address = "{}"
  response {{
    status = {}
    body = {{{}}}
  }}
}}]],
      {
        i(1),
        i(2, '200'),
        i(3),
      }
    )
  ),
}
