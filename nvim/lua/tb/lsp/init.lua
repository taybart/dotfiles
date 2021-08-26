local M = {}

local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')

local u = require('tb/utils/maps')



require('tb/lsp/go').setup()

-- Set keymap if attached
-- local on_attach = function(client, bufnr)
local on_attach = function(client)
  local opts = { noremap=true, silent=true }
  u.nmap('gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
  u.nmap('gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  u.nmap('gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
  u.nmap('K', ':lua vim.lsp.buf.hover()<CR>', opts)
  u.nmap('[d', ':lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  u.nmap(']d', ':lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  u.nmap('E', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    u.nmap("ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    u.nmap("ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  vim.cmd([[
  command! Format lua vim.lsp.buf.formatting()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
  autocmd BufWritePre *.go lua require('tb/lsp').go_organize_imports_sync()
  " autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
  ]])
end

local function make_base_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {"documentation", "detail", "additionalTextEdits"}
  }

  -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return {capabilities = capabilities, on_attach = on_attach, test = "asdf" }
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
      merge_config(config, lsp_configs[server])
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

function M.go_organize_imports_sync()
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 500)
  if (result ~= nil) then
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
    vim.lsp.buf.formatting()
  end
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

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
    -- return require('cmp').mapping.complete()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end


u.imap("<Tab>", "v:lua.tab_complete()", {expr = true})
u.smap("<Tab>", "v:lua.tab_complete()", {expr = true})
u.imap("<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
u.smap("<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
u.inoremap("<CR>", 'compe#confirm("<CR>")', {silent=true, expr=true})

return M
