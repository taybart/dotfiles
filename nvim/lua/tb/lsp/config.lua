return {
  go = {
    cmd = {"gopls", "serve"},
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
          globals = { 'vim' }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      }
    }
  },
  java = {
    cmd = { vim.fn.stdpath('data').."/lspinstall/java/jdtls.sh" }
  },
}
