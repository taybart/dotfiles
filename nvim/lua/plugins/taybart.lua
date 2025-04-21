return {
  {
    'taybart/rest.nvim',
    -- dir = '~/dev/taybart/rest.nvim',
    config = true,
  },
  {
    'taybart/resurrect.nvim',
    -- dir = '~/dev/taybart/resurrect.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = { quiet = true },
  },
  {
    'taybart/serve.nvim',
    opts = {},
    -- dir = '~/dev/taybart/serve.nvim',
    -- opts = { logs = { level = 'debug', no_color = true } },
  },
  {
    'taybart/b64.nvim',
    -- dir = '~/dev/taybart/rest.nvim',
    config = function()
      require('utils/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },
  {
    'taybart/inline.nvim',
    -- dir = '~/dev/taybart/inline.nvim',
    -- dependencies = { 'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua' },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    -- event = 'VeryLazy',
    config = function()
      local il = require('inline').setup({
        keymaps = { enabled = false },
        signcolumn = { enabled = false },
        virtual_text = { icon = '📰' },
        popup = { width = 20, height = 4 },
      })
      vim.keymap.set('n', '<leader>N', function()
        il.notes.show(false)
      end)
      vim.api.nvim_create_user_command('EditFileNote', function()
        il.notes.show(true, true)
      end, {})
      vim.api.nvim_create_user_command('AddNote', il.notes.add, {})
      vim.api.nvim_create_user_command('ShowNote', il.notes.show, {})
    end,
  },
  {
    'taybart/vis',
    -- dir = '~/dev/taybart/vis',
  },
}
