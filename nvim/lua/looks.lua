----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

vim.o.background = "dark" -- or "light" for light mode
vim.cmd 'colorscheme gruvbox'

---- Tree Sitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
}

-- inline colors
require('colorizer').setup()

-- lighter status line
vim.g.airline_theme='papercolor'


function M.toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    return
  end

  local re = vim.regex('tagbar\\|NvimTree\\|vista')
  if re:match_str(vim.bo.ft) then
    vim.opt.number=false
    return
  end

  vim.opt.number=true
  vim.opt.relativenumber=relon
end

return M
