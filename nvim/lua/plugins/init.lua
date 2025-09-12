return {
  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').group({ noremap = true, silent = true }, {
        {
          'n',
          { '<c-f><left>',  ':TmuxNavigateLeft<cr>' },
          { '<c-f><down>',  ':TmuxNavigateDown<cr>' },
          { '<c-f><up>',    ':TmuxNavigateUp<cr>' },
          { '<c-f><right>', ':TmuxNavigateRight<cr>' },
        },
        {
          't',
          { '<c-f><left>',  '<c-\\><c-n>:TmuxNavigateLeft<cr>' },
          { '<c-f><down>',  '<c-\\><c-n>:TmuxNavigateDown<cr>' },
          { '<c-f><up>',    '<c-\\><c-n>:TmuxNavigateUp<cr>' },
          { '<c-f><right>', '<c-\\><c-n>:TmuxNavigateRight<cr>' },
        },
      })
    end,
  },

  --[==================[
  --===  Probation  ===
  --]==================]
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

  {
    'rmagatti/goto-preview',
    dependencies = { 'rmagatti/logger.nvim' },
    event = 'BufEnter',
    config = {
      default_mappings = true,
      post_open_hook = function(_, win)
        vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:')
      end,
    }, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  },

  -- {
  --   'rest-nvim/rest.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     opts = function(_, opts)
  --       opts.ensure_installed = opts.ensure_installed or {}
  --       table.insert(opts.ensure_installed, 'http')
  --     end,
  --   },
  -- },
}
