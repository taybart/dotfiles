return {
  'jose-elias-alvarez/null-ls.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  -- ft = { 'lua', 'sh', 'javascript', 'typescript', 'typescriptreact' },
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      sources = {
        -- git
        null_ls.builtins.code_actions.gitsigns,
        -- lua
        null_ls.builtins.formatting.stylua.with({
          extra_args = {
            '--config-path',
            vim.fn.expand('~/.dotfiles/nvim/stylua.toml'),
          },
        }),
        -- go
        null_ls.builtins.code_actions.gomodifytags,
        -- javascript
        null_ls.builtins.formatting.prettier.with({
          extra_args = { '--no-semi', '--single-quote' },
          disabled_filetypes = { 'json' },
        }),
        -- sh
        null_ls.builtins.code_actions.shellcheck,
        -- protobuf
        null_ls.builtins.formatting.buf,
      },
      root_dir = require('lspconfig/util').root_pattern(
        '.null-ls-root',
        'Makefile',
        '.git',
        'package.json'
      ),
    })
    -- always map ca for gitsigns
    require('utils/maps').mode_group('n', {
      { 'ca', vim.lsp.buf.code_action },
    }, { noremap = true, silent = true })
  end,
}
