return {
  {
    'mikavilpas/yazi.nvim',
    dependencies = { 'folke/snacks.nvim', lazy = false, priority = 1000, opts = {} },
    keys = {
      {
        '<leader>f',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
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
    lazy = false,
    init = function() vim.g.loaded_netrwPlugin = 1 end,
  },
}
