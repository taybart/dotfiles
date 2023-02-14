local extension_path = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension'
return {
  'simrat39/rust-tools.nvim',
  ft = 'rust',
  config = function()
    require('rust-tools').setup({
      tools = {
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = true,
          show_parameter_hints = false,
          parameter_hints_prefix = '',
          other_hints_prefix = '',
        },
        hover_actions = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = require('languages').on_attach,
        settings = {
          ['rust-analyzer'] = {
            -- enable clippy on save
            checkonsave = {
              command = 'clippy',
            },
          },
        },
      },
      -- https://github.com/LunarVim/LunarVim/issues/2894#issuecomment-1236420149
      -- https://github.com/simrat39/rust-tools.nvim/issues/302
      -- https://github.com/simrat39/rust-tools.nvim/discussions/303
      dap = {
        -- type = 'executable',
        adapter = require('rust-tools.dap').get_codelldb_adapter(
          extension_path .. '/adapter/codelldb',
          extension_path .. '/lldb/lib/liblldb.dylib'
        ),
      },
    })
  end,
}
