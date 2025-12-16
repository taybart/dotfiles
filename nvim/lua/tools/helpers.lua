local M = {}

function M.background(value)
  vim.api.nvim_set_option_value('background', value, {})
end

return M
