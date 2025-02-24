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
  { 'vim-scripts/vis' },

  -- { 'zbirenbaum/copilot.lua', config = true },

  { 'OXY2DEV/markview.nvim', config = true },

  --[==================[
  -- Probation
  --]==================]

  {
    'stevearc/conform.nvim',
    opts = {},
  },
  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<cr>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<cr>', { buffer = bufnr })
        end,
      })
      vim.keymap.set('n', '<F8>', '<cmd>AerialToggle<cr>', { noremap = true })
    end,
  },

      vim.cmd([[highlight llama_hl_hint guifg=#ff772f ctermfg=202]])
      -- vim.cmd([[hi link llama_hl_hint Comment ]])
    end,
  },

  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>f',
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
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },

  -- {
  --   'olimorris/codecompanion.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = 'copilot',
  --       },
  --       inline = {
  --         adapter = 'copilot',
  --       },
  --     },
  --   },
  -- },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local h = require('harpoon')
      h:setup()

      -- vim.keymap.set('n', '<c-e>', function()
      --   h.ui:toggle_quick_menu(h:list())
      -- end)
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table({ results = file_paths }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      require('utils/maps').mode_group('n', {
        {
          '<leader>a',
          function()
            h:list():add()
          end,
        },
        {
          '<C-e>',
          function()
            toggle_telescope(h:list())
          end,
        },
      }, {})
    end,
  },
}
