return {
  'jose-elias-alvarez/null-ls.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  ft = { 'lua', 'sh', 'javascript', 'typescript', 'typescriptreact' },
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      sources = {
        -- lua
        null_ls.builtins.formatting.stylua.with({
          extra_args = {
            '--config-path',
            vim.fn.expand('~/.dotfiles/nvim/stylua.toml'),
          },
        }),
        -- javascript
        null_ls.builtins.formatting.prettier.with({
          extra_args = { '--no-semi', '--single-quote' },
        }),
        -- sh
        null_ls.builtins.code_actions.shellcheck,
        -- python
        -- null_ls.builtins.formatting.black,
        -- null_ls.builtins.diagnostics.mypy,
      },
      root_dir = require('lspconfig/util').root_pattern(
        '.null-ls-root',
        'Makefile',
        '.git',
        'package.json'
      ),
    })
  end,
}
