return {
  -- Colorschemes
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
          SnacksPickerBufFlags = { fg = p.neutral_aqua },
          SnacksPickerDir = { fg = p.light0_soft },
        },
      })
      -- local h = require('tools/helpers')
      -- h.background('dark')
      vim.cmd.colorscheme('gruvbox')
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  -- Fix until OSC 11 is in nvim/tmux/ghostty
  -- {
  --   'f-person/auto-dark-mode.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     set_dark_mode = function()
  --       h.background('dark')
  --       vim.cmd.colorscheme('gruvbox')
  --       vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })
  --     end,
  --     set_light_mode = function()
  --       h.background('light')
  --       vim.cmd.colorscheme('catppuccin-latte')
  --       vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })
  --     end,
  --     update_interval = 3000,
  --     fallback = 'dark',
  --   },
  -- },

  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'foreground',
      enable_tailwind = true,
      exclude_filetypes = { 'lazy' },
    },
  },
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
