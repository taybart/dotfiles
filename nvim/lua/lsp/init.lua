local M = {}

-- LSP Setup
function M.setup()
  -- language specific stuff
  require('lsp/go')
  require('lsp/lua')
  require('lsp/python')
  require('lsp/matlab')
  require('lsp/arduino')
  require('lsp/rest')
  require('lsp/rust')

  -- lsp configs
  local lspconfig = require('lspconfig')
  local configs = require('lsp/config')
  for lsp, lsp_config in pairs(configs) do
    local config = vim.tbl_deep_extend('force', M.make_base_config(), lsp_config)
    lspconfig[lsp].setup(config)
  end
end

-- Set keymap if attached
M.on_attach = function()
  require('utils/maps').mode_group('n', {
    { 'gD', vim.lsp.buf.type_definition },
    { 'gd', vim.lsp.buf.definition },
    { 'gi', vim.lsp.buf.implementation },
    { 'gr', vim.lsp.buf.references },
    { '[d', vim.diagnostic.goto_next },
    { ']d', vim.diagnostic.goto_prev },
    { 'K', vim.lsp.buf.hover },
    { 'E', vim.diagnostic.open_float },
    { 'ca', vim.lsp.buf.code_action },
  }, { noremap = true, silent = true })

  vim.api.nvim_create_augroup('lsp', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'lsp',
    pattern = '*',
    callback = function()
      if vim.bo.filetype ~= 'go' then
        vim.lsp.buf.format()
      end
    end,
  })
  vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, {})
  vim.api.nvim_create_user_command('Issues', vim.diagnostic.setqflist, {})
  vim.api.nvim_create_user_command('Rename', function(args)
    local new_name = args.fargs[1]
    if not new_name then
      new_name = vim.fn.input({ prompt = 'to -> ' })
    end

    local position_params = vim.lsp.util.make_position_params(nil, 'utf-8')
    position_params.newName = new_name
    vim.lsp.buf_request(0, 'textDocument/rename', position_params)
  end, {
    nargs = '?',
  })
end

function M.make_base_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  return { capabilities = capabilities, on_attach = M.on_attach }
end

function M.update_config(lang, update)
  local lspconfig = require('lspconfig')
  lspconfig[lang].setup(vim.tbl_deep_extend('force', M.make_base_config(), update))
  vim.cmd('bufdo e')
end

return M
