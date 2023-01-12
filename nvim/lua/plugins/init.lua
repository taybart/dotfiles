return {
  { 'williamboman/mason.nvim', config = true },

  -- rest.vim
  -- { 'taybart/rest.vim' },

  -- b64.nvim
  { 'taybart/b64.nvim' },

  { -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
  { 'tweekmonster/startuptime.vim', cmd = { 'StartupTime' } },
}
