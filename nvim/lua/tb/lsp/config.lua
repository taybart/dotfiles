return {
  go = {
    cmd = {vim.fn.stdpath('data').."/lspinstall/go/gopls", "serve"},
    settings = {
      gopls = {
        buildFlags =  {"-tags="},
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  },
  lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'hs' }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
            [vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
          },
        },
      }
    }
  },
  java = {
    cmd = { vim.fn.stdpath('data').."/lspinstall/java/jdtls.sh" }
  },
}
