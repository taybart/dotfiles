return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim',       config = true },
    { 'folke/neodev.nvim',       ft = 'lua',                            config = true },
    { 'williamboman/mason.nvim', opts = { ui = { border = 'single' } }, cmd = 'Mason' },
  },
  config = function()
    require('languages').setup()
  end,
}
