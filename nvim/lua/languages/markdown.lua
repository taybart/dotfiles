-- opdavies/toggle-checkbox.nvim
local function toggle()
  local checked = '%[x%]'
  local unchecked = '%[ %]'

  local cursor = vim.api.nvim_win_get_cursor(0)
  local start = cursor[1] - 1
  local current = vim.api.nvim_buf_get_lines(0, start, start + 1, false)[1]
  if not current then
    return
  end

  local update = ''
  -- line contains an unchecked box
  if string.find(current, unchecked) then
    update = current:gsub(unchecked, checked)
  else -- line contains an checked box
    update = current:gsub(checked, unchecked)
  end

  vim.api.nvim_buf_set_lines(0, start, start + 1, false, { update })
  vim.api.nvim_win_set_cursor(0, cursor)
end

require('utils/augroup').create({
  markdown_lsp = {
    {
      event = 'FileType',
      pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>td', function()
          toggle()
        end)
      end,
    },
  },
})
