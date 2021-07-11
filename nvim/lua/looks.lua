----------------------------------
------------- Looks --------------
----------------------------------

-- special global for checking if we are taking notes
vim.g.goyo_mode = 0

-- require('github-theme').setup {}

vim.g.gruvbox_italic = 1
vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd 'colorscheme melange'
vim.cmd 'colorscheme gruvbox'

require('colorizer').setup()

-- lighter status line
vim.g.airline_theme='papercolor'


require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
}


function toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    return
  end

  local re = vim.regex('tagbar\\|NvimTree')
  if re:match_str(vim.bo.ft) then
    vim.opt.nonumber=true
    return
  end

  if relon then
    vim.opt.relativenumber=true
  else
    vim.opt.number=true
  end
end

-- vim.cmd[[
--   au BufEnter,FocusGained,InsertLeave * lua require('looks').toggle_relnum(true)
--   au BufLeave,FocusLost,InsertEnter * lua require('looks').toggle_relnum(false)
-- ]]

vim.cmd[[
" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White

" Underline the offending code
hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
]]

return {
  toggle_num = toggle_num,
}
