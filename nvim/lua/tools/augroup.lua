local M = {}

function M.create(definitions)
  for group_name, autocmd in pairs(definitions) do
    if group_name ~= nil then
      vim.api.nvim_create_augroup(group_name, {})
      for _, au in ipairs(autocmd) do
        vim.api.nvim_create_autocmd(au.event, {
          group = group_name,
          pattern = au.pattern,
          callback = au.callback,
          command = au.command,
        })
      end
    end
  end
end

return M
