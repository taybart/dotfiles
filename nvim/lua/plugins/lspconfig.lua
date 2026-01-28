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
    init = function()
      -- Fix: https://github.com/neovim/neovim/issues/28058
      local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
      function vim.lsp.protocol.make_client_capabilities()
        local caps = make_client_capabilities()
        if caps.workspace then caps.workspace.didChangeWatchedFiles = nil end
        return caps
      end
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        -- tsserver_file_preferences = {
        --   -- TODO: this doesn't work
        --   quotePreference = 'single',
        -- },
        tsserver_format_options = {
          semicolons = 'remove',
        },
      },
    },
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
