local sumneko_root_path = vim.fn.stdpath('data')..'/lua-language-server'
local sumneko_os = ''

if vim.fn.has("mac") == 1 then
  sumneko_os = 'macOS'
elseif vim.fn.has("unix") == 1 then
  sumneko_os = 'Linux'
else
  print('Unsupported system for sumneko')
end
local sumneko_binary = sumneko_root_path..'/bin/'..sumneko_os..'/lua-language-server'

return {
  ccls = {},
  gopls = {
    cmd = {'gopls'};
    settings = {
      gopls = {
        buildFlags =  {"-tags="},
        analyses = {
          unusedparams = true,
          -- fieldalignment = true,
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
      cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
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
