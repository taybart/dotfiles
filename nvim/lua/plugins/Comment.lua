return {
  'numToStr/Comment.nvim',
  event = 'InsertEnter',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
  },
  config = function()
    require('Comment').setup({
      ignore = '^$',
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
