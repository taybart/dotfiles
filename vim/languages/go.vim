lua <<EOF
require'lspconfig'.gopls.setup{
cmd = {"gopls", "serve"},
settings = {
  gopls = {
    buildFlags =  {"-tags=auth,oprah"},
    analyses = { unusedparams = true },
    staticcheck = true,
    },
  },
}

function go_organize_imports_sync(timeoutms)
  local context = {source = {organizeImports = true}}
  vim.validate {context = {context, 't', true}}

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = 'textDocument/codeAction'
  local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)

  -- imports is indexed with clientid so we cannot rely on index always is 1
  for _, v in next, resp, nil do
    local result = v.result
    if result and result[1] then
      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
  -- Always do formating
  vim.lsp.buf.formatting()
end
EOF

au FileType go nmap gtj :CocCommand go.tags.add json<cr>
au FileType go nmap gty :CocCommand go.tags.add yaml<cr>
au FileType go nmap gtx :CocCommand go.tags.clear<cr>
" au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>r :!go run %<cr>


augroup language_autocmd
  au!
  autocmd BufEnter * lua require'completion'.on_attach()
  autocmd BufWritePre *.go lua go_organize_imports_sync(1000)
  " autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
  au BufRead,BufNewFile *.tmpl setfiletype gohtmltmpl
  " au FileType * autocmd BufWritePre <buffer> StripWhitespace
augroup END

