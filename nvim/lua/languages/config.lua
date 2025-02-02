local lcutil = require('lspconfig/util')

local function filter(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end

return {
  arduino_language_server = {
    cmd = {
      vim.fn.expand('$GOPATH/bin/arduino-language-server'),
      '-cli-config',
      vim.fn.expand('$HOME/.arduinoIDE/arduino-cli.yaml'),
      '-cli',
      'arduino-cli',
      '-fqbn',
      require('languages/arduino').get_board(),
    },
  },
  astro = {},
  buf_ls = {},
  clangd = {
    -- remove "proto" for now since i use protobuf more
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  },
  denols = {
    root_dir = lcutil.root_pattern('deno.json', 'deno.jsonc'),
  },
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
  gleam = {},
  html = {
    opts = {
      settings = {
        html = {
          format = {
            templating = true,
            wrapLineLength = 120,
            wrapAttributes = 'auto',
          },
          hover = {
            documentation = true,
            references = true,
          },
        },
      },
    },
  },
  htmx = {},
  lua_ls = {
    settings = {
      Lua = {
        telemetry = {
          enable = false,
        },
        diagnostics = {
          globals = { 'vim', 'hs', 'utf8' },
          disable = { 'missing-fields' },
        },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file('', true),
          library = {
            ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
            [vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
          },
        },
      },
    },
  },
  ocamllsp = {},
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = {
  --           enabled = false,
  --           ignore = { 'E261', 'W391' },
  --           maxLineLength = 100,
  --         },
  --       },
  --     },
  --   },
  -- },
  ruff = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
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
  },
  svelte = {},
  terraformls = {},
  ts_ls = {
    -- https://github.com/typescript-language-server/typescript-language-server/issues/216
    handlers = {
      ['textDocument/definition'] = function(err, result, method, ...)
        if vim.islist(result) then
          if #result > 1 then
            local filtered = filter(result, filterReactDTS)
            return vim.lsp.handlers['textDocument/definition'](err, filtered, method, ...)
          end
        end
        vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
      end,
    },
  },
  zls = {},
}
