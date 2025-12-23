return {
  {
    'taybart/rest.nvim',
    dependencies = { 'taybart/code-actions.nvim' },
    -- dir = '~/dev/taybart/rest.nvim',
    -- dependencies = { dir = '~/dev/taybart/code-actions.nvim' },
    opts = {},
  },
  {
    -- 'taybart/resurrect.nvim',
    dir = '~/dev/taybart/resurrect.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = { quiet = true },
  },
  {
    'taybart/serve.nvim',
    build = 'make all',
    opts = {},
    -- dir = '~/dev/taybart/serve.nvim',
    -- opts = { logs = { level = 'debug' } },
  },
  {
    'taybart/b64.nvim',
    -- dir = '~/dev/taybart/b64.nvim',
    config = function()
      require('tools/maps').mode_group('v', {
        { '<leader>bd', require('b64').decode },
        { '<leader>be', require('b64').encode },
      }, { noremap = true, silent = true })
    end,
  },
  {
    -- add visual -> :B for selected region only ops,
    -- forked to remove :S and cecutil
    'taybart/vis',
    -- dir = '~/dev/taybart/vis',
  },
  require('plugins/taybart/code-actions'),
}
