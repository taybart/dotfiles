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
local nvim_lsp = require('lspconfig')
local nvim_command = vim.api.nvim_command

-- Set keymap if attached
local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '[d', ':lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', ']d', ':lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'E', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true })
  -- command! Format lua vim.lsp.buf.formatting()


  vim.cmd([[
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  autocmd BufWritePre *.go lua go_organize_imports_sync(1000)
  ]])
end

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

vim.fn.sign_define("LspDiagnosticsSignError",
    {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = "", texthl = "GruvboxAqua"})


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
