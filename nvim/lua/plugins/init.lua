return {
  { 'williamboman/mason.nvim', config = true },

  -- rest.vim
  -- { 'taybart/rest.vim' },

  -- b64.nvim
  {
    'taybart/b64.nvim',
    config = function()
      -- base64
      require('utils/maps').mode_group('v', {
        {
          '<leader>bd',
          function()
            require('b64').decode()
          end,
        },
        {
          '<leader>be',
          function()
            require('b64').encode()
          end,
        },
      }, { noremap = true, silent = true })
    end,
  },

  { -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,

    config = function()
      require('utils/maps').mode_group('n', {
        { '<C-f><Left>', ':TmuxNavigateLeft<cr>' },
        { '<C-f><Down>', ':TmuxNavigateDown<cr>' },
        { '<C-f><Up>', ':TmuxNavigateUp<cr>' },
        { '<C-f><Right>', ':TmuxNavigateRight<cr>' },
        -- { '<;>', ':TmuxNavigatePrevious<cr>' },
      }, { noremap = true, silent = true })
    end,
  },

  { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
  { 'tweekmonster/startuptime.vim', cmd = { 'StartupTime' } },
}
