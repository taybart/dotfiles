return {
  'lewis6991/gitsigns.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 0,
    },
    on_attach = function()
      local gs = require('gitsigns')
      vim.keymap.set('n', '<leader>gp', gs.preview_hunk)
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.nav_hunk('next') end)
        return '<ignore>'
      end, { expr = true })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.nav_hunk('prev') end)
        return '<ignore>'
      end, { expr = true })
    end,
  },
}
