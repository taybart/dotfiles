return {
  {
    'taybart/b64.nvim',
    -- dir = '~/dev/taybart/rest.nvim',
    config = function()
      require('utils/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },

  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').mode_group('n', {
        { '<c-f><left>', ':TmuxNavigateLeft<cr>' },
        { '<c-f><down>', ':TmuxNavigateDown<cr>' },
        { '<c-f><up>', ':TmuxNavigateUp<cr>' },
        { '<c-f><right>', ':TmuxNavigateRight<cr>' },
      }, { noremap = true, silent = true })
    end,
  },

  --[==================[
  -- Probation
  --]==================]
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })
    end,
  },
}
