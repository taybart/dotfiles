local lspinstall = require('lspinstall')
local lspconfig = require('lspconfig')
local lsp_configs = require('lsp/config')


-- Set keymap if attached
local on_attach = function(client, bufnr)
  -- require'lsp_signature'.on_attach()
  -- require'completion'.on_attach()

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

local function make_base_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {"documentation", "detail", "additionalTextEdits"}
  }

  return {capabilities = capabilities, on_attach = on_attach, test = "asdf" }
end

local function merge_config(first, second)
  for k, v in pairs(second) do first[k] = v end
end



-- LSP Setup
local function setup()

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

-- LSP signs
vim.fn.sign_define("LspDiagnosticsSignError", {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "GruvboxAqua"})


------------------------------------
------------ nvim compe ------------
------------------------------------
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'disable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

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
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
