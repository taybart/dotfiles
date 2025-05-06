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

function M.ft_cmd(ft, opts)
  return {
    event = 'FileType',
    pattern = ft,
    callback = function()
      if type(opts.run_cmd) == 'string' then
        local bang = '!'
        if opts.run_no_bang then
          bang = ''
        end
        vim.api.nvim_create_user_command('Run', bang .. opts.run_cmd, { nargs = '*' })
      end
      if type(opts.run_cmd) == 'function' then
        vim.api.nvim_create_user_command('Run', opts.run_cmd, { nargs = '*' })
      end
      if type(opts.commands) == 'table' then
        for _, cmd in ipairs(opts.commands) do
          vim.api.nvim_create_user_command(cmd.name, cmd.cmd, cmd.opts or { nargs = '*' })
        end
      end
      if opts.callback ~= nil and type(opts.callback) == 'function' then
        opts.callback()
      end
    end,
  }
end

return M
