return {
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local gb = require('gruvbox')
      gb.setup({
        overrides = {
          SignColumn = { bg = gb.palette.dark0 },
        },
      })
      vim.opt.background = 'dark' -- or "light" for light mode
      -- vim.g.gruvbox_italic = 1
      -- vim.g.gruvbox_sign_column = 'bg0'
      vim.cmd('colorscheme gruvbox')
    end,
  },
  { 'stevearc/dressing.nvim', config = true },
  -- nice indicators for fF/tT
  { 'unblevable/quick-scope' },
  {
    'akinsho/nvim-bufferline.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          diagnostics = 'nvim_lsp',
          separator_style = 'slant',
          max_name_length = 30,
          show_close_icon = false,
          show_buffer_close_icons = false,
          right_mouse_command = '',
          middle_mouse_command = 'bdelete! %d',
          custom_filter = function(buf_number)
            return vim.bo[buf_number].filetype ~= 'qf'
          end,
        },
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        sections = {
          lualine_a = {},
          lualine_c = {
            { 'filename', file_status = true, path = 1 },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = {},
        },
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        exclude = {
          filetypes = { 'help', 'TelescopePrompt' },
        },
      })
    end,
  },
}
