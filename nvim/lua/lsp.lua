local M = {}

-- LSP Setup
function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    pattern = '*',
    callback = function()
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function()
          local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/formatting' })

          if #clients > 0 then
            vim.lsp.buf.format()
          end
        end,
      })

      local telescope = require('telescope.builtin')
      require('utils/maps').mode_group('n', {
        -- these have been mapped into default
        { 'gi', vim.lsp.buf.implementation },
        { 'gr', telescope.lsp_references },
        { 'gD', telescope.lsp_type_definitions },
        { 'gd', telescope.lsp_definitions },
        { 'gi', telescope.lsp_implementations },
        { 'K', vim.lsp.buf.hover },
        { 'E', vim.diagnostic.open_float },
        { 'ca', vim.lsp.buf.code_action },
        { '<leader>rn', vim.lsp.buf.rename },
      }, { noremap = true, silent = true })

      require('utils/commands').add({
        { 'Format', vim.lsp.buf.format },
        { 'Issues', vim.diagnostic.setqflist },
        {
          'Rename',
          {
            cmd = function(args)
              ---@diagnostic disable-next-line: undefined-field
              local new_name = args.fargs[1]
              local old_name = vim.fn.expand('<cword>')
              if not new_name then
                new_name = vim.fn.input({ prompt = old_name .. ' to -> ', default = old_name })
                if not new_name or new_name == '' then
                  return
                end
              end

              local position_params = vim.lsp.util.make_position_params(0, 'utf-8')
              ---@diagnostic disable-next-line: inject-field
              position_params.newName = new_name
              vim.lsp.buf_request(0, 'textDocument/rename', position_params)
            end,
            opts = { nargs = '?' },
          },
        },
      })
    end,
  })

  -- lsp configs
  local lsps = {
    'astro',
    'clangd',
    -- 'denols',
    'gopls',
    'html',
    'lua_ls',
    'marksman',
    'ruff',
    'rust_analyzer',
    'ts_ls',
  }
  for _, lsp in ipairs(lsps) do
    vim.lsp.enable(lsp)
  end
end

function M.update_config(lang, update)
  vim.lsp.config(lang, vim.tbl_deep_extend('force', M.make_base_config(), update))
  vim.cmd('bufdo e')
end

return M
