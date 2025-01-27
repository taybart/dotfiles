return {
  {
    'taybart/rest.nvim',
    -- dir = '~/dev/taybart/rest.nvim',
    config = true,
  },
  {
    'taybart/resurrect.nvim',
    -- dir = '~/dev/taybart/resurrect.nvim',
    config = true,
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
}
