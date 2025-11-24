----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

---@diagnostic disable-next-line: inject-field
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

-- LSP looks
local x = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = { [x.ERROR] = '󰅙', [x.WARN] = '', [x.INFO] = '', [x.HINT] = '󰌵' },
  },
})

return M
