----------------------------------
------------- Looks --------------
----------------------------------

local M = {}
---- Tree Sitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
}


-- special global for checking if we are taking notes
vim.g.goyo_mode = 0

vim.g.gruvbox_italic = 1

vim.o.background = "dark" -- or "light" for light mode
vim.cmd 'colorscheme gruvbox'

require('colorizer').setup()

-- lighter status line
vim.g.airline_theme='papercolor'

function M.toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    return
  end

  local re = vim.regex('tagbar\\|NvimTree')
  if re:match_str(vim.bo.ft) then
    vim.opt.number=false
    return
  end

  vim.opt.number=true
  vim.opt.relativenumber=relon
end

vim.cmd[[
  au BufEnter,FocusGained,InsertLeave * lua require('looks').toggle_num(true)
  au BufLeave,FocusLost,InsertEnter * lua require('looks').toggle_num(false)
]]


return M
