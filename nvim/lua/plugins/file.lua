return {
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'stevearc/aerial.nvim',
    dependencies = { 'folke/snacks.nvim' },
    keys = {
      { '<F8>', '<cmd>AerialToggle<cr>', noremap = true },
      { '<leader>j', function() require('aerial').snacks_picker() end },
    },
    opts = {},
  },
  {
    'rmagatti/goto-preview',
    event = 'BufEnter',
    opts = {
      default_mappings = true,
      height = 25,
      width = 105,
      post_open_hook = function(buf, win)
        -- necessary as per https://github.com/rmagatti/goto-preview/issues/64#issuecomment-1159069253
        vim.api.nvim_set_option_value('winhighlight', 'Normal:', { win = win })
        -- https://github.com/rmagatti/goto-preview/issues/112#issuecomment-1878942159
        local orig_state = vim.api.nvim_get_option_value('modifiable', { buf = buf })
        vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
        vim.api.nvim_create_autocmd({ 'WinLeave' }, {
          buffer = buf,
          callback = function()
            vim.api.nvim_win_close(win, false)
            vim.api.nvim_set_option_value('modifiable', orig_state, { buf = buf })
            return true
          end,
        })
      end,
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      -- format_on_save = format_hunks,
      formatters = {
        prettier = {
          prepend_args = { '--no-semi', '--single-quote' },
        },
        stylua = {
          -- stylua: ignore
          prepend_args = {
            '--column-width', '100',
            '--indent-width', '2',
            '--quote-style', 'AutoPreferSingle',
            '--collapse-simple-statement', 'Always',
          },
        },
      },
      format_on_save = { lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        go = { 'goimports', timeout_ms = 3000 }, -- 3s becaue big projects take forever
        javascript = { 'biome', 'prettier', stop_after_first = true },
        typescript = { 'biome', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        css = { 'prettier' },
        html = { 'prettier' },
        rest = { 'hcl', 'injected' },
      },
    },
  },
  { 'stevearc/quicker.nvim', ft = 'qf', opts = {} },
  {
    'taybart/midnight.nvim',
    dev = true,
    -- not just ft = 'midnight': it also handles midnight in .rest files (comments,
    -- linting heredocs) and registers the parser for nvim-treesitter. Its LSP
    -- (`midnight lsp`) lints and formats .mn files (conform falls back to it)
    lazy = false,
    opts = {
      -- local grammar checkout if present (else github); `:TSInstall! midnight` after grammar changes
      treesitter = {
        path = vim.fn.isdirectory(vim.fn.expand('~/dev/taybart/midnight/tree-sitter-midnight')) == 1
            and '~/dev/taybart/midnight/tree-sitter-midnight'
          or nil,
      },
    },
  },
}
