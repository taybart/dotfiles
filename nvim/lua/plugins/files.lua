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
              -- TODO: only if floating
              -- vim.keymap.set('n', '<esc>', '<cmd>wq<cr>', {})
            end,
          },
        },
      })
    end,
  },
  {
    'mikavilpas/yazi.nvim',
    dependencies = { 'folke/snacks.nvim', lazy = true },
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
}
