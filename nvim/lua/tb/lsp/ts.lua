
require('tb/utils').create_augroups({
  ts_lsp = {
    { 'BufWritePre', '*.js,*.jsx,*.ts,*.tsx', 'lua vim.lsp.buf.formatting_sync()' },
  },
})
