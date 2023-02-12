local M = {}

local checked_character = 'x'

local checked_checkbox = '%[' .. checked_character .. '%]'
local unchecked_checkbox = '%[ %]'

local line_contains_an_unchecked_checkbox = function(line)
  return string.find(line, unchecked_checkbox)
end

local checkbox = {
  check = function(line)
    return line:gsub(unchecked_checkbox, checked_checkbox)
  end,
  uncheck = function(line)
    return line:gsub(checked_checkbox, unchecked_checkbox)
  end,
}

-- opdavies/toggle-checkbox.nvim
M.toggle = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor[1] - 1
  local current_line = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, false)[1] or ''

  -- If the line contains a checked checkbox then uncheck it.
  -- Otherwise, if it contains an unchecked checkbox, check it.
  local new_line = ''
  if line_contains_an_unchecked_checkbox(current_line) then
    new_line = checkbox.check(current_line)
  else
    new_line = checkbox.uncheck(current_line)
  end

  vim.api.nvim_buf_set_lines(0, start_line, start_line + 1, false, { new_line })
  vim.api.nvim_win_set_cursor(0, cursor)
end

require('utils/augroup').create({
  markdown_lsp = {
    {
      event = 'FileType',
      pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>td', function()
          print('')
          M.toggle()
        end)
      end,
    },
  },
})

return M
