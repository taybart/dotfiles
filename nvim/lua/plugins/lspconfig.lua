return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', config = true },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'williamboman/mason.nvim', opts = { ui = { border = 'single' } }, cmd = 'Mason' },
  },
  ft = {
    'arduino',
    'go',
    'json',
    'lua',
    'markdown',
    'matlab',
    'python',
    'rest',
    'rust',
    'sh',
  },
  config = function()
    require('languages').setup()
  end,
}
