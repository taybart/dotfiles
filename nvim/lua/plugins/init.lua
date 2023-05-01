return {
  {
    -- 'taybart/rest.nvim',
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

  {
    'eandrju/cellular-automaton.nvim',
    cmd = { 'CellularAutomaton', 'Rain' },
    config = function()
      vim.api.nvim_create_user_command('Rain', 'CellularAutomaton make_it_rain', {})
    end,
  },

  --[==================[
  -- Probation
  --]==================]
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_keymap(
        'i',
        '<c-j>',
        'copilot#Accept("<CR>")',
        { silent = true, expr = true }
      )
    end,
  },

  { 'pest-parser/pest.vim', ft = 'pest' },

  {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    cmd = { 'MindOpenMain', 'MindOpenProject', 'MindOpenSmartProject' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  {
    'jiaoshijie/undotree',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    keys = {
      {
        '<leader>u',
        function()
          require('undotree').toggle()
        end,
        { noremap = true, silent = true },
      },
    },
  },

  {
    'ziontee113/SnippetGenie',
    config = function()
      local genie = require('SnippetGenie')

      genie.setup({
        regex = [[-\+ Snippets go here]],
        snippets_directory = vim.fn.expand('~/.config/nvim/lua/snippets/'),
        file_name = 'generated',
      })

      vim.keymap.set('x', '<CR>', function()
        print('start snippet')
        genie.create_new_snippet_or_add_placeholder()
        vim.cmd('norm! ')
      end, {})

      vim.keymap.set('n', '<CR>', function()
        genie.finalize_snippet()
      end, {})
    end,
  },
}
