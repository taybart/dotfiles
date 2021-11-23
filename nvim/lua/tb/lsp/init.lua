local M = {}


local lspconfig = require('lspconfig')

local u = require('tb/utils/maps')

require('tb/lsp/go')
require('tb/lsp/lua')
require('tb/lsp/ts')
require('tb/lsp/matlab')

-- Set keymap if attached
local on_attach = function(client)
  u.mode_map_group('n', {
    {'gD', ':lua vim.lsp.buf.declaration()<CR>'},
    {'gd', ':lua vim.lsp.buf.definition()<CR>'},
    {'gi', ':lua vim.lsp.buf.implementation()<CR>'},
    {'K', ':lua vim.lsp.buf.hover()<CR>'},
    {'[d', ':lua vim.lsp.diagnostic.goto_next()<CR>'},
    {']d', ':lua vim.lsp.diagnostic.goto_prev()<CR>'},
    {'E', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
    {'ca', ':lua vim.lsp.buf.code_action()<CR>'},
  }, { noremap=true, silent=true })

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

-- LSP Setup
local function setup()
  local lsp_configs = require('tb/lsp/config')

  for lsp, lsp_config in pairs(lsp_configs) do
    local config = vim.tbl_deep_extend('force', make_base_config(), lsp_config)
    lspconfig[lsp].setup(config)
  end
end

function M.update_config(lang, update)
  local config = make_base_config()
  config = vim.tbl_deep_extend('force', config, update)
  lspconfig[lang].setup(config)
  vim.cmd("bufdo e")
end

setup()

-- LSP looks
vim.fn.sign_define("LspDiagnosticsSignError", {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "GruvboxAqua"})

vim.cmd('command! -nargs=? Rename lua require("tb/lsp").rename(<f-args>)')
function M.rename(new_name)
  if not new_name then
    new_name = vim.fn.input('to -> ')
  end

  if vim.lsp.buf.server_ready() then
    local position_params = vim.lsp.util.make_position_params()
    position_params.newName = new_name
    vim.lsp.buf_request(0, 'textDocument/rename', position_params)
  else
    local orig = vim.fn.expand('<cword>')
    local lookahead = require ('nvim-treesitter.configs').get_module("textobjects.select").lookahead
    local bufnr, to = require('nvim-treesitter.textobjects.shared').textobject_at_point('@function.outer', nil, nil, { lookahead = lookahead })

    if to then
      local r = {}
      local lines = vim.api.nvim_buf_get_lines(0, to[1], to[3], true)
      for _, line in pairs(lines) do
        table.insert(r, vim.fn.substitute(line, orig, new_name, 'g'))
      end
      vim.api.nvim_buf_set_lines(bufnr, to[1], to[3], true, r)
    end
  end
end

return M
