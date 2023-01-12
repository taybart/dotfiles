return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', config = true },
    { 'folke/neodev.nvim', ft = 'lua', config = true },
  },
  config = function()
    require('lsp').setup()
  end,
}