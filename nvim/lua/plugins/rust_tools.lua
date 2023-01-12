return {
  'simrat39/rust-tools.nvim',
  ft = 'rust',
  opts = {
    tools = {
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = true,
        show_parameter_hints = false,
        parameter_hints_prefix = '',
        other_hints_prefix = '',
      },
    },

    server = {
      on_attach = require('lsp').on_attach,
      settings = {
        ['rust-analyzer'] = {
          -- enable clippy on save
          checkonsave = {
            command = 'clippy',
          },
        },
      },
    },
  },
}
