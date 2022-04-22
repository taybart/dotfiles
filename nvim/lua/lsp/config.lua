local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local lcutil = require('lspconfig/util')

return {
  clangd = {},
  gopls = {
    root_dir = lcutil.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
      gopls = {
        buildFlags = { '-tags=' },
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
  rust_analyzer = {},
  tsserver = {},
  svelte = {},
  pylsp = {},
  sumneko_lua = require('lua-dev').setup({
    lspconfig = {
      cmd = { vim.fn.stdpath('data') .. '/lua-language-server/bin/lua-language-server' },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          telemetry = {
            enable = false,
          },
          diagnostics = {
            globals = { 'vim', 'hs' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            --{

            --   ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
            --   [vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
            -- },
          },
        },
      },
    },
  }),
}
