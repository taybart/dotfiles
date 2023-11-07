return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim',       config = true, tag = 'legacy' },
    { 'folke/neodev.nvim',       ft = 'lua',    config = true },
    { 'williamboman/mason.nvim', config = true },
  },
  config = function()
    require('languages').setup()
  end,
}
