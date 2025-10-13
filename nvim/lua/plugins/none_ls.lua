return {
  'nvimtools/none-ls.nvim',

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
        -- javascript
        -- null_ls.builtins.formatting.prettier.with({
        --   extra_args = { '--no-semi', '--single-quote' },
        --   disabled_filetypes = { 'json' },
        -- }),
        -- go
        null_ls.builtins.code_actions.gomodifytags,
        -- sql
        null_ls.builtins.diagnostics.sqruff,
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
      { 'E',  vim.diagnostic.open_float },
    }, { noremap = true, silent = true })
  end,
}
-- return {
--   'nvimtools/none-ls.nvim',
--   event = 'VeryLazy',
--   dependencies = {
--     { 'nvim-lua/plenary.nvim' },
--   },
--   -- ft = { 'lua', 'sh', 'javascript', 'typescript', 'typescriptreact' },
--   config = function()
--     local null_ls = require('null-ls')
--     null_ls.setup({
--       sources = {
--         -- django html
--         null_ls.builtins.formatting.djhtml,
--         -- git
--         null_ls.builtins.code_actions.gitsigns,
--         -- lua
--         null_ls.builtins.formatting.stylua.with({
--           extra_args = {
--             '--config-path',
--             vim.fn.expand('~/.dotfiles/nvim/stylua.toml'),
--           },
--         }),
--         -- go
--         null_ls.builtins.code_actions.gomodifytags,
--         -- javascript
--         null_ls.builtins.formatting.prettier.with({
--           extra_args = { '--no-semi', '--single-quote' },
--           disabled_filetypes = { 'json' },
--         }),
--         -- protobuf
--         null_ls.builtins.formatting.buf,
--         -- python
--         -- null_ls.builtins.diagnostics.ruff,
--         -- null_ls.builtins.formatting.ruff,
--         -- null_ls.builtins.diagnostics.sqlfluff.with({
--         --   extra_args = { '--dialect', 'sqlite' }, -- change to your dialect
--         -- }),
--         null_ls.builtins.diagnostics.sqruff,
--       },
--       root_dir = require('lspconfig/util').root_pattern(
--         '.null-ls-root',
--         'Makefile',
--         '.git',
--         'package.json'
--       ),
--     })
--     -- always map ca for gitsigns
--     require('utils/maps').mode_group('n', {
--       { 'ca', vim.lsp.buf.code_action },
--       { 'E', vim.diagnostic.open_float },
--     }, { noremap = true, silent = true })

--     vim.api.nvim_create_user_command('Format', function()
--       vim.lsp.buf.format()
--     end, {})
--   end,
-- }
