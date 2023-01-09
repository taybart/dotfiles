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
      require('lsp/arduino').get_board(),
    },
  },
  clangd = {
    -- remove "proto" for now since i use protobuf more
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
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
  rust_analyzer = {},
  astro = {},
  tsserver = {
    -- https://github.com/typescript-language-server/typescript-language-server/issues/216
    handlers = {
      ['textDocument/definition'] = function(err, result, method, ...)
        if vim.tbl_islist(result) then
          if #result > 1 then
            local filtered = filter(result, filterReactDTS)
            return vim.lsp.handlers['textDocument/definition'](err, filtered, method, ...)
          end
        end
        vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
      end,
    },
  },
  svelte = {},
  pylsp = {},
  terraformls = {},
  ocamllsp = {},
  sumneko_lua = {
    settings = {
      Lua = {
        telemetry = {
          enable = false,
        },
        diagnostics = {
          globals = { 'hs', 'utf8' },
        },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file('', true),
          {

            ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
            [vim.fn.expand('$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations')] = true,
          },
        },
      },
    },
  },
}
