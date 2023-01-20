return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', config = true },
    { 'folke/neodev.nvim', ft = 'lua', config = true },
    { 'williamboman/mason.nvim', config = true },
  },
  config = function()
    require('lsp').setup()
  end,
}
