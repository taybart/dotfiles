return {
  {
    -- dir = 'taybart/rest.nvim',
    dir = '~/dev/taybart/rest.nvim',
    config = true,
  },
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

  { 'zbirenbaum/copilot.lua', config = true },
  -- {
  --   'github/copilot.vim',
  --   init = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.api.nvim_set_keymap(
  --       'i',
  --       '<c-j>',
  --       'copilot#Accept("<CR>")',
  --       { silent = true, expr = true }
  --     )
  --   end,
  -- },

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
