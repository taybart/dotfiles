--[[
rust-analyzer.toml
[rustfmt]
overrideCommand = ["dx", "fmt", "--all-code", "-f", "-"]
]]

return {
  settings = {
    ['rust-analyzer'] = {
      checkonsave = {
        command = 'clippy',
      },
      cargo = {
        buildScripts = {
          enable = false,
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
