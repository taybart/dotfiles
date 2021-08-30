local M = {}


local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')

local u = require('tb/utils/maps')



require('tb/lsp/go')
require('tb/lsp/lua')

-- Set keymap if attached
-- local on_attach = function(client, bufnr)
local on_attach = function(client)
  u.mode_map_group('n', { noremap=true, silent=true }, {
    {'gD', ':lua vim.lsp.buf.declaration()<CR>'},
    {'gd', ':lua vim.lsp.buf.definition()<CR>'},
    {'gi', ':lua vim.lsp.buf.implementation()<CR>'},
    {'K', ':lua vim.lsp.buf.hover()<CR>'},
    {'[d', ':lua vim.lsp.diagnostic.goto_next()<CR>'},
    {']d', ':lua vim.lsp.diagnostic.goto_prev()<CR>'},
    {'E', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
  })

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    u.nnoremap('ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', { silent=true })
  elseif client.resolved_capabilities.document_range_formatting then
    u.nnoremap('ff', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', { silent=true })
  end

  vim.cmd([[
  command! Format lua vim.lsp.buf.formatting()
  " autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  " autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
  ]])
end

local function make_base_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return {capabilities = capabilities, on_attach = on_attach }
end

local function merge_config(first, second)
  for k, v in pairs(second) do first[k] = v end
end



-- LSP Setup
local function setup()

  local lsp_configs = require('tb/lsp/config')

  lspinstall.setup()

  local servers = lspinstall.installed_servers()
  for _, server in pairs(servers) do
    local config = make_base_config()
    if lsp_configs[server] ~= nil then
      require('tb/utils').merge(config, lsp_configs[server])
    end
    lspconfig[server].setup(config)
  end
end

setup()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

function M.reload(lang, lang_config)
  lspinstall.setup()

  local config = make_base_config()
  if lang_config ~= nil then
    merge_config(config, lang_config)
  end

  lspconfig[lang].setup(config)
end
-- LSP looks
vim.fn.sign_define("LspDiagnosticsSignError", {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "GruvboxAqua"})

vim.cmd('command! -nargs=? Rename lua require("tb/lsp").rename(<f-args>)')
function M.rename(new_name)
  local position_params = vim.lsp.util.make_position_params()

  if not new_name then
    new_name = vim.fn.input('to -> ')
  end

  position_params.newName = new_name
  vim.lsp.buf_request(0, 'textDocument/rename', position_params)
end
return M
