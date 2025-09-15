return {
  {
    'kndndrj/nvim-dbee',
    dependencies = { 'MunifTanjim/nui.nvim' },
    build = function()
      require('dbee').install()
    end,
    config = function()
      require('dbee').setup()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbee',
        callback = function()
          vim.opt.sidescrolloff = 8
          vim.keymap.set('n', '<c-l>', 'f│w', { noremap = true })
          vim.keymap.set('n', '<c-h>', 'F│b', { noremap = true })
        end,
      })
    end,
  },
}
