return {
  {
    'taybart/rest.nvim',
    dev = true,
    dependencies = { 'taybart/code-actions.nvim' },
    opts = {},
  },
  {
    'taybart/resurrect.nvim',
    dev = true,
    dependencies = { 'kkharji/sqlite.lua' },
    opts = { quiet = true },
  },
  {
    'taybart/serve.nvim',
    dev = true,
    opts = {
      -- logs = { level = 'debug' }
    },
  },
  {
    'taybart/b64.nvim',
    dev = true,
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
