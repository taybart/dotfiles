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

-- switch themes when background changes
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    if vim.o.background == 'light' then
      vim.cmd.colorscheme('catppuccin-latte')
    elseif vim.o.background == 'dark' then
      vim.cmd.colorscheme('gruvbox')
    end
    -- re-set up lualine, for whatever reason when i don't set background
    -- to support automatic colorscheme switching all of the colors are
    -- messed up with it
    require('lualine').setup({
      sections = {
        lualine_a = {},
        lualine_c = {
          { 'filename', file_status = true, path = 1 },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'g:serving_status', 'g:has_resurrect_sessions' },
      },
    })
  end,
})
-- LSP looks
local x = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = { [x.ERROR] = '󰅙', [x.WARN] = '', [x.INFO] = '', [x.HINT] = '󰌵' },
  },
})

return M
