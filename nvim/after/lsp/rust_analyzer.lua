return {
  settings = {
    ['rust-analyzer'] = {
      checkonsave = {
        command = 'clippy',
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
        ignore = {
          leptos_macro = {
            'server',
            'component',
          },
        },
      },
    },
  },
}
