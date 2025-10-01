return {
  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      --@diagnostic disable-next-line: inject-field
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').group({ noremap = true, silent = true }, {
        {
          'n',
          { '<c-f><left>', ':TmuxNavigateLeft<cr>' },
          { '<c-f><down>', ':TmuxNavigateDown<cr>' },
          { '<c-f><up>', ':TmuxNavigateUp<cr>' },
          { '<c-f><right>', ':TmuxNavigateRight<cr>' },
        },
        {
          't',
          { '<c-f><left>', '<c-\\><c-n>:TmuxNavigateLeft<cr>' },
          { '<c-f><down>', '<c-\\><c-n>:TmuxNavigateDown<cr>' },
          { '<c-f><up>', '<c-\\><c-n>:TmuxNavigateUp<cr>' },
          { '<c-f><right>', '<c-\\><c-n>:TmuxNavigateRight<cr>' },
        },
      })
    end,
  },

  --[==================[
  --===  Probation  ===
  --]==================]
  {
    'rmagatti/goto-preview',
    dependencies = { 'rmagatti/logger.nvim' },
    event = 'BufEnter',
    opts = {
      default_mappings = true,
      height = 25,
      width = 105,
      post_open_hook = function(_, win)
        -- necessary as per https://github.com/rmagatti/goto-preview/issues/64#issuecomment-1159069253
        vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:')
      end,
    },
  },
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/.notes',
        },
      },
    },
  },
}
