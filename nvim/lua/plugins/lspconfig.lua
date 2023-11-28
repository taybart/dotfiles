return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', config = true },
    { 'folke/neodev.nvim', ft = 'lua', config = true },
    { 'williamboman/mason.nvim', opts = { ui = { border = 'single' } } },
  },
  config = function()
    require('languages').setup()
  end,
}
