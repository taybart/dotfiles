return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
      {
        'mason-org/mason.nvim',
        opts = { ui = { border = 'single' } },
        cmd = 'Mason',
      },
    },
    -- init = function()
    -- Fix: https://github.com/neovim/neovim/issues/28058
    -- local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
    -- function vim.lsp.protocol.make_client_capabilities()
    --   local caps = make_client_capabilities()
    --   caps.workspace.didChangeWatchedFiles.dynamicRegistration = false
    --   if caps.workspace then caps.workspace.didChangeWatchedFiles = nil end
    --   return caps
    -- end
    -- end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
