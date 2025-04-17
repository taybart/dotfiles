return {
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local gb = require('gruvbox')
      local p = gb.palette
      vim.o.background = 'dark'
      gb.setup({
        overrides = {
          SignColumn = { bg = p.dark0 },
          DiagnosticSignError = { fg = p.neutral_red, bg = p.dark0 },
          DiagnosticSignWarn = { fg = p.neutral_yellow, bg = p.dark0 },
          DiagnosticSignInfo = { fg = p.neutral_blue, bg = p.dark0 },
          DiagnosticSignHing = { fg = p.neutral_aqua, bg = p.dark0 },
          CursorLineNr = { fg = p.neutral_yellow, bg = p.dark0 },
        },
      })
      vim.cmd.colorscheme('gruvbox')
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd.colorscheme('gruvbox')
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd.colorscheme('catppuccin-latte')
      end,
      update_interval = 3000,
      fallback = 'dark',
    },
  },
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'foreground',
      enable_tailwind = true,
    },
  },
  { 'stevearc/quicker.nvim', ft = 'qf', opts = {} },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      local s = require('snacks')
      s.setup({
        bigfile = { enabled = true },
        indent = {
          enabled = true,
          animate = {
            enabled = false,
            duration = {
              step = 10,
              total = 200,
            },
          },
        },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        picker = {
          enabled = true,
          win = {
            input = {
              keys = {
                ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              },
            },
          },
        },
        quickfile = { enabled = true },
      })
      vim.api.nvim_create_user_command('Notifications', s.notifier.show_history, {})
    end,
  },

  -- nice indicators for fF/tT
  { 'unblevable/quick-scope' },
  {
    'OXY2DEV/markview.nvim',
    config = function()
      require('markview').setup({})
      require('utils/augroup').create({
        markview_ = {
          {
            event = 'FileType',
            pattern = 'markdown',
            callback = function()
              vim.keymap.set('n', '<leader>m', '<cmd>Markview toggle<cr>')
            end,
          },
        },
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- moved to lua/looks.lua because of stupid colorscheme bs
    opts = {
      sections = {
        lualine_a = {},
        lualine_c = {
          { 'filename', file_status = true, path = 1 },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'g:serving_status', 'g:has_resurrect_sessions' },
      },
    },
  },
}
