return {
  settings = {
    gopls = {
      buildFlags = { '-tags=' },
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
