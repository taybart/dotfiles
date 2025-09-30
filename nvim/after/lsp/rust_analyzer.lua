return {
  settings = {
    ['rust-analyzer'] = {
      checkonsave = {
        command = 'clippy',
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
