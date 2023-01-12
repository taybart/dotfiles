return {
  { 'gruvbox-community/gruvbox' },
  -- nice indicators for fF/tT
  { 'unblevable/quick-scope' },
  {
    'akinsho/nvim-bufferline.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
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
        },
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('utils').reload_module('lualine')
      require('lualine').setup({
        sections = {
          lualine_b = { 'b:gitsigns_status' },
          lualine_c = {
            { 'filename', file_status = true, path = 1 },
          },
        },
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        filetype_exclude = { 'help', 'TelescopePrompt' },
      })
    end,
  },
}
