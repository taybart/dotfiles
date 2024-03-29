return {
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
    { '<Leader>o', ':Neotree reveal toggle position=left<cr>', { noremap = true, silent = true } },
    {
      '<Leader>f',
      ':Neotree toggle reveal position=float<cr>',
      { noremap = true, silent = true },
    },
  },
}
