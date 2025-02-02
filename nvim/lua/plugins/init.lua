return {
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

  --[==================[
  -- Probation
  --]==================]

  {
    -- 'taybart/inline.nvim',
    dir = '~/dev/taybart/inline.nvim',
    -- dependencies = { 'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    -- event = 'VeryLazy',
    config = function()
      local il = require('inline').setup({
        keymaps = { enabled = false },
        signcolumn = { enabled = false },
        virtual_text = { icon = '📰' },
        popup = { width = 20, height = 4 },
      })
      vim.keymap.set('n', '<leader>N', function()
        il.notes.show(false)
      end)
      vim.api.nvim_create_user_command('EditFileNote', function()
        il.notes.show(true, true)
      end, {})
      vim.api.nvim_create_user_command('AddNote', il.notes.add, {})
      vim.api.nvim_create_user_command('ShowNote', il.notes.show, {})
    end,
  },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>-',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    },
  },

  {
    'atiladefreitas/dooing',
    -- enabled = false,
    opts = {
      quick_keys = false,
      window = {
        position = 'top-right',
      },
      keymaps = {
        toggle_window = false,
      },
    },
  },

  {
    'OXY2DEV/markview.nvim',
    config = true,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      -- -- Toggle previous & next buffers stored within Harpoon list
      -- vim.keymap.set('n', '<c-s-p>', function()
      --   harpoon:list():prev()
      -- end)
      -- vim.keymap.set('n', '<c-s-n>', function()
      --   harpoon:list():next()
      -- end)
      vim.keymap.set('n', '<c-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
    end,
  },
}
