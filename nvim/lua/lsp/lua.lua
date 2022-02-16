local M = {}

require('utils').create_augroups({
  lua_lsp = {
    { 'FileType', 'lua', 'command! Run luafile %' },
    { 'BufWritePre', '*.lua', 'lua require("lsp/lua").on_save()' },
  },
})

function M.on_save()
  require('utils/job').run_job('stylua', {
    '--config-path',
    vim.fn.expand('~/.dotfiles/nvim/stylua.toml'),
    vim.fn.expand('%'),
  })
  vim.cmd('bufdo e')
end

return M
