return {
  {
    'stevearc/aerial.nvim',
    keys = {
      {
        '<F8>',
        '<cmd>AerialToggle<cr>',
        { desc = 'Toggle aerial', noremap = true },
      },
    },
    opts = {},
  },
  {
    'rmagatti/goto-preview',
    dependencies = { 'rmagatti/logger.nvim' },
    event = 'BufEnter',
    opts = {
      default_mappings = true,
      height = 25,
      width = 105,
      post_open_hook = function(_, win)
        -- necessary as per https://github.com/rmagatti/goto-preview/issues/64#issuecomment-1159069253
        vim.api.nvim_set_option_value('winhighlight', 'Normal:', { win = win })
      end,
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
