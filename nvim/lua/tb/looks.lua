----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

vim.opt.background = 'dark' -- or "light" for light mode
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = "bg0"
vim.cmd('colorscheme gruvbox')
-- vim.cmd('colorscheme highlite')
-- nice markdown highlighting
vim.g.markdown_fenced_languages = {
  'html',
  'python',
  'sh',
  'bash=sh',
  'shell=sh',
  'go',
  'javascript',
  'js=javascript',
  'typescript',
  'ts=typescript',
  'py=python',
}

function M.toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    vim.opt.number=false
    return
  end

  local re = vim.regex('tagbar\\|NvimTree\\|vista\\|packer\\|nnn')
  if re:match_str(vim.bo.ft) then
    vim.opt.number=false
    return
  end

  vim.opt.number=true
  vim.opt.relativenumber=relon
end

return M
