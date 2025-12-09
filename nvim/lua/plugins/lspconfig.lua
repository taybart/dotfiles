return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim',       config = true },
      { 'williamboman/mason.nvim', opts = { ui = { border = 'single' } }, cmd = 'Mason' },
    },
    config = function() require('lsp').setup() end,
  },
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        tsserver_file_preferences = {
          -- TODO: this doesn't work
          quotePreference = 'single',
        },
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
