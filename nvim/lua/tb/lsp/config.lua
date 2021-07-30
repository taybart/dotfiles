return {
  go = {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        buildFlags =  {"-tags=auth,kyc,oprah"},
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  lua = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
  },
  java = {
    cmd = { vim.fn.stdpath('data').."/lspinstall/java/jdtls.sh" }
  },
}
