local M = {}

function M.one(name, cmd, opts)
  vim.api.nvim_create_user_command(name, cmd, opts or {})
end

function M.add(opts)
  -- TODO: also make this work for { name = "", ... }
  for _, opt in pairs(opts) do
    local name, cmd = opt[1], opt[2]
    if type(cmd) == 'table' then
      vim.api.nvim_create_user_command(name, cmd.cmd, cmd.opts or { nargs = '*' })
    else
      vim.api.nvim_create_user_command(name, cmd, { nargs = '*' })
    end
  end
end

function M.set_run(opts)
  if type(opts) == 'function' then
    vim.api.nvim_create_user_command('Run', opts, { nargs = '*' })
    return
  end
  if type(opts.cmd) == 'string' then
    local bang = '!'
    if opts.no_bang then
      bang = ''
    end
    vim.api.nvim_create_user_command('Run', bang .. opts.cmd, { nargs = '*' })
  end
  if type(opts.cmd) == 'function' then
    vim.api.nvim_create_user_command('Run', opts.cmd, { nargs = '*' })
  end
end

function M.ft(ft, opts)
  return {
    event = 'FileType',
    pattern = ft,
    callback = function()
      if opts.run_cmd ~= nil then
        M.run_cmd({ cmd = opts.run_cmd, run_no_bang = opts.run_no_bang })
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
