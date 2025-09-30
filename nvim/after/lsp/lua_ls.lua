return {
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
      diagnostics = {
        globals = { 'vim', 'hs', 'utf8' },
        disable = { 'missing-fields' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        -- library = {
        --   vim.env.VIMRUNTIME,
        --   '${3rd}/luv/library',
        --   -- vim.api.nvim_get_runtime_file('', true),
        --   -- '/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/',
        --   -- vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations'),
        -- },
      },
    },
  },
}
