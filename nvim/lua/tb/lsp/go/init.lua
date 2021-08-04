local go = {}

_GO_NVIM_CFG = {
  goimport = 'gofumports', -- if set to 'gopls' will use gopls format
  gofmt = 'gofumpt', -- if set to gopls will use gopls format
  max_line_line = 120,
  tag_transform = false,
  test_dir = '',
  comment_placeholder = '   ',
  verbose = false,
  log_path = vim.fn.expand("$HOME") .. "/tmp/gonvim.log",
  lsp_cfg = false, -- true: apply go.nvim non-default gopls setup
  lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = nil, -- provides a on_attach function to gopls, will use go.nvim on_attach if nil
  lsp_diag_hdlr = true, -- hook lsp diag handler
  dap_debug = false,
  dap_debug_gui = false,
  dap_vt = true, -- false, true and 'all frames'
  gopls_cmd = nil --- you can provide gopls path and cmd if it not in PATH, e.g. cmd = {  "/home/ray/.local/nvim/data/lspinstall/go/gopls" }
}


function go.setup()

  vim.cmd([[command! -nargs=* GoAddTag lua require("tb/lsp/go").add(<f-args>)]])

  -- TODO add fuzzy finder from history list with no arguments
  vim.cmd('command! -nargs=* GoTags lua require("tb/lsp/go").set_build_tags(<f-args>)')
end

function go.set_build_tags (tags)
  local go_config = require('tb/lsp/config').go

  go_config.settings.gopls.buildFlags = {"-tags="..tags}

  require('tb/lsp').reload("go", go_config)
end
return go
