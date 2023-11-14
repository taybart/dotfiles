return {
  'numToStr/Comment.nvim',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    ft = {
      'javascriptreact',
      'typescriptreact',
      'javascript',
      'typescript',
      'tsx',
      'css',
      'scss',
      'php',
      'html',
      'svelte',
      'vue',
      'astro',
      'handlebars',
      'glimmer',
      'graphql',
      'lua',
    },
  },
  config = function()
    require('Comment').setup({
      ignore = '^$',
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
