----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

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

vim.cmd([[
hi! link TelescopePromptBorder GruvboxBg4
hi! link TelescopeResultsBorder GruvboxBg4
hi! link TelescopePreviewBorder GruvboxBg4
]])

-- LSP looks
vim.fn.sign_define('DiagnosticSignError', { text = '✗', texthl = 'GruvboxRed' })
vim.fn.sign_define('DiagnosticSignWarning', { text = '', texthl = 'GruvboxYellow' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'GruvboxBlue' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'GruvboxAqua' })

-- fix neo-tree preview color issue
vim.cmd('hi NormalFloat guibg=GruvBoxBg1')
vim.cmd('hi FloatBorder guibg=GruvBoxBg1')

function M.toggle_num(rel_on)
  if vim.bo.ft == '' then
    return
  end

  local re = vim.regex('tagbar\\|NvimTree\\|vista\\|packer')
  if re ~= nil then
    if re:match_str(vim.bo.ft) then
      vim.opt.number = false
      return
    end
  end

  vim.opt.number = true
  vim.opt.relativenumber = rel_on
end

return M
