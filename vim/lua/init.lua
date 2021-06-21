-- Tree Sitter
require('nvim-treesitter.configs').setup {
ensure_installed = "maintained",
highlight = { enable = true },
}

-- LSP Install
require('lspinstall').setup() -- important

local function setup_servers()
  require('lspinstall').setup()
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    require('lspconfig')[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- LSP
vim.fn.sign_define("LspDiagnosticsSignError",
    {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = "", texthl = "GruvboxAqua"})

-- Set keymap if attached
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', ':lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', ':lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'E', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)


  vim.cmd([[
  command! Format lua vim.lsp.buf.formatting()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  autocmd BufWritePre *.go lua go_organize_imports_sync(1000)
  " autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  ]])
end

local nvim_lsp = require('lspconfig')

nvim_lsp.gopls.setup{
on_attach = on_attach,
cmd = {"gopls", "serve"},
settings = {
  gopls = {
    buildFlags =  {"-tags=kyc_e,oprah"},
    analyses = { unusedparams = true },
    staticcheck = true,
    },
  },
}

local servers = { "tsserver", "typescript" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

function go_organize_imports_sync(timeoutms)
  local context = {source = {organizeImports = true}}
  vim.validate {context = {context, 't', true}}

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = 'textDocument/codeAction'
  local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)

  -- imports is indexed with clientid so we cannot rely on index always is 1
  if (resp ~= nil) then
    for _, v in next, resp, nil do
      local result = v.result
      if result and result[1] then
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
      end
    end
  end
  -- Always do formating
  vim.lsp.buf.formatting()
end
