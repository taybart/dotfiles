return {
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<cmd>Oil --float<cr>', { desc = 'Open parent directory' })
      require('utils/augroup').create({
        oil = {
          {
            event = 'FileType',
            pattern = 'oil',
            callback = function()
              vim.keymap.set('n', 'q', '<cmd>wq<cr>', {})
              vim.keymap.set('n', '<esc>', '<cmd>wq<cr>', {})
            end,
          },
        },
      })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      close_if_last_window = true,
      enable_diagnostics = false,
      enable_git_status = false,
      hijack_netrw_behavior = 'open_default',
      window = {
        mappings = {
          ['<esc>'] = 'close_window',
        },
      },
      default_component_configs = {
        icon = {
          default = '',
        },
      },
    },
    keys = {
      {
        '<Leader>o',
        ':Neotree reveal toggle position=left<cr>',
        { noremap = true, silent = true },
      },
      {
        '<Leader>f',
        ':Neotree toggle reveal position=float<cr>',
        { noremap = true, silent = true },
      },
    },
  },
}
