local rust = {}

function rust.run(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo run ' .. file_name)
end

function rust.test(args)
  local file_name = args.fargs[1]
  if file_name == '' or file_name == nil then
    file_name = '.'
  end
  vim.api.nvim_command('!cargo test ' .. file_name)
end

local au = require('utils/augroup')
au.create({
  rust_lsp = {
    au.ft_cmd('rust', {
      run_cmd = rust.run,
      commands = {
        { name = 'Test', cmd = rust.test,     opts = { nargs = '?' } },
        { name = 'Rsx',  cmd = '!leptosfmt %' },
      },
      -- needed because for some reason, rustaceanvim doesn't use lspconfig
      callback = function()
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*.rs',
          callback = function()
            vim.lsp.buf.format()
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
          { 'K',  vim.lsp.buf.hover },
          { 'E',  vim.diagnostic.open_float },
          { 'ca', vim.lsp.buf.code_action },
        }, { noremap = true, silent = true })
      end,
    }),
  },
})

return rust
