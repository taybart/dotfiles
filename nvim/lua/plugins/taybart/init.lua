return {
  {
    'taybart/rest.nvim',
    dependencies = { 'taybart/code-actions.nvim' },
    -- dir = '~/dev/taybart/rest.nvim',
    -- dependencies = { dir = '~/dev/taybart/code-actions.nvim' },
    config = true,
  },
  {
    'taybart/resurrect.nvim',
    event = 'VeryLazy',
    -- dir = '~/dev/taybart/resurrect.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = { quiet = true },
  },
  {
    'taybart/serve.nvim',
    -- dir = '~/dev/taybart/serve.nvim',
    opts = {},
  },
  {
    'taybart/b64.nvim',
    -- dir = '~/dev/taybart/b64.nvim',
    config = function()
      require('utils/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },
  {
    'taybart/vis',
    -- dir = '~/dev/taybart/vis',
  },
  {
    'taybart/inline.nvim',
    -- dir = '~/dev/taybart/inline.nvim',
    dependencies = {
      'folke/snacks.nvim',
      'taybart/code-actions.nvim',
      'kkharji/sqlite.lua',
    },
    opts = {
      signcolumn = { enabled = false },
      virtual_text = { enabled = true, icon = '📝' },
    },
  },
  require('plugins/taybart/code-actions'),
}
