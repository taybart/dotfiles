local M = {}

-- LSP Setup
function M.setup()
  -- language specific stuff
  require('languages/arduino')
  require('languages/go')
  require('languages/lua')
  require('languages/markdown')
  require('languages/matlab')
  require('languages/python')
  require('languages/rest')
  require('languages/rust')

  -- langs = {'go', 'lua', 'python', 'matlab'}

  -- lsp configs
  local lspconfig = require('lspconfig')
  local configs = require('languages/config')
  for lsp, lsp_config in pairs(configs) do
    local config = vim.tbl_deep_extend('force', M.make_base_config(), lsp_config)
    lspconfig[lsp].setup(config)
  end
end

-- Set keymap if attached
M.on_attach = function()
  require('utils/augroup').create({
    lsp = {
      {
        event = 'BufWritePre',
        pattern = '*',
        callback = function()
          vim.lsp.buf.format()
        end,
      },
    },
  })

  require('utils/maps').mode_group('n', {
    -- { 'gd', vim.lsp.buf.definition },
    -- { 'gr', vim.lsp.buf.references },
    -- { 'gD', vim.lsp.buf.type_definition },
    { 'gi', vim.lsp.buf.implementation },
    { 'gr', require('telescope.builtin').lsp_references },
    { 'gD', require('telescope.builtin').lsp_type_definitions },
    { 'gd', require('telescope.builtin').lsp_definitions },
    { 'gi', require('telescope.builtin').lsp_implementations },
    { '[d', vim.diagnostic.goto_next },
    { ']d', vim.diagnostic.goto_prev },
    { 'K', vim.lsp.buf.hover },
    { 'E', vim.diagnostic.open_float },
    { 'ca', vim.lsp.buf.code_action },
  }, { noremap = true, silent = true })

  local command = vim.api.nvim_create_user_command

  command('Format', function()
    vim.lsp.buf.format()
  end, {})
  command('Issues', vim.diagnostic.setqflist, {})
  command('Rename', function(args)
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
