local M = {}

-- LSP Setup
function M.setup()
  -- language specific stuff
  require('languages/arduino')
  require('languages/apex')
  require('languages/go')
  require('languages/json')
  require('languages/lua')
  require('languages/markdown')
  require('languages/matlab')
  require('languages/procfile')
  require('languages/python')
  require('languages/rest')
  require('languages/rust')
  require('languages/sh')
  require('languages/typescript')

  require('lspconfig.ui.windows').default_options.border = 'single'

  -- add borders to docs
  local border = {
    { '🭽', 'FloatBorder' },
    { '▔', 'FloatBorder' },
    { '🭾', 'FloatBorder' },
    { '▕', 'FloatBorder' },
    { '🭿', 'FloatBorder' },
    { '▁', 'FloatBorder' },
    { '🭼', 'FloatBorder' },
    { '▏', 'FloatBorder' },
  }
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- lsp configs
  local lspconfig = require('lspconfig')
  local configs = require('languages/lspconfig')
  for lsp, lsp_config in pairs(configs) do
    local config = vim.tbl_deep_extend('force', M.make_base_config(), lsp_config)
    lspconfig[lsp].setup(config)
  end
end

-- Set keymap if attached
M.on_attach = function()
  require('utils/augroup').create({
    lsp = {
      -- {
      --   event = 'LspAttach',
      --   pattern = '*',
      --   callback = function()
      --     vim.lsp.inlay_hint.enable(true)
      --   end,
      -- },
      {
        event = 'BufWritePre',
        pattern = '*',
        callback = function()
          vim.lsp.buf.format()
        end,
      },
    },
  })

  local telescope = require('telescope.builtin')
  require('utils/maps').mode_group('n', {
    -- these have been mapped into default
    { 'gi', vim.lsp.buf.implementation },
    { 'gr', telescope.lsp_references },
    { 'gD', telescope.lsp_type_definitions },
    { 'gd', telescope.lsp_definitions },
    { 'gi', telescope.lsp_implementations },
    -- {
    --   '[d',
    --   function()
    --     vim.diagnostic.jump({ count = 1 })
    --   end,
    -- },
    -- {
    --   ']d',
    --   function()
    --     vim.diagnostic.jump({ count = -1 })
    --   end,
    -- },
    { 'K', vim.lsp.buf.hover },
    { 'E', vim.diagnostic.open_float },
    { 'ca', vim.lsp.buf.code_action },
    { '<leader>rn', vim.lsp.buf.rename },
  }, { noremap = true, silent = true })

  local command = vim.api.nvim_create_user_command

  command('Format', function()
    vim.lsp.buf.format()
  end, {})
  command('Issues', vim.diagnostic.setqflist, {})
  command('Rename', function(args)
    local new_name = args.fargs[1]
    local old_name = vim.fn.expand('<cword>')
    if not new_name then
      new_name = vim.fn.input({ prompt = old_name .. ' to -> ' })
      if not new_name or new_name == '' then
        return
      end
    end

    local position_params = vim.lsp.util.make_position_params(0, 'utf-8')
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
