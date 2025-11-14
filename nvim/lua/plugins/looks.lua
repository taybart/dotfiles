local h = require('utils/helpers')
return {
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local gb = require('gruvbox')
      local p = gb.palette
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
      h.background('dark')
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
    event = 'VeryLazy',
    opts = {
      set_dark_mode = function()
        h.background('dark')
        vim.cmd.colorscheme('gruvbox')
        vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })
      end,
      set_light_mode = function()
        h.background('light')
        vim.cmd.colorscheme('catppuccin-latte')
        vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })
      end,
      update_interval = 3000,
      fallback = 'dark',
    },
  },
  {
    'folke/snacks.nvim',
    priority = 100,
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
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'foreground',
      enable_tailwind = true,
      exclude_filetypes = {
        'lazy',
      },
    },
  },
  { 'stevearc/quicker.nvim', ft = 'qf', opts = {} },

  -- nice indicators for fF/tT
  { 'unblevable/quick-scope' },
  {
    'OXY2DEV/markview.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    opts = {
      experimental = { check_rtp_message = false },
    },
    keys = { { '<leader>m', '<cmd>Markview toggle<cr>', ft = 'markdown' } },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
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
