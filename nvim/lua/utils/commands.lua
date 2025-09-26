local M = {}

function M.add(opts)
  if type(opts.cmds) == 'table' then
    for _, cmd in ipairs(opts.cmds) do
      vim.api.nvim_create_user_command(cmd.name, cmd.cmd, cmd.opts or { nargs = '*' })
    end
  end
end

function M.set_run(opts)
  if type(opts.cmd) == 'string' then
    local bang = '!'
    if opts.run_no_bang then
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
