return {
  gopls = {
    cmd = {'gopls'};
    settings = {
      gopls = {
        buildFlags =  {"-tags="},
        analyses = {
          unusedparams = true,
          -- shadow = true,
        },
        staticcheck = true,
      },
    },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
  },
  tsserver = {
    -- have to set every one for some reason
    cmd = { "typescript-language-server", "--stdio" },
  },
  sumneko_lua = require("lua-dev").setup({
    lspconfig = {
    cmd = {'lua-language-server'};
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'hs' }
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.stdpath('config')..'/lua'] = true,
              [vim.fn.stdpath('config')..'/lua/vim/lsp'] = true,
              ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
              [vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
            },
          },
        }
    }
    }
  }),
}
