local M = {}

-- alias for when this module is already in a file and we want a short alias
function M.one(name, cmd, opts) vim.api.nvim_create_user_command(name, cmd, opts or {}) end

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
    if opts.no_bang then bang = '' end
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
      if opts.callback ~= nil and type(opts.callback) == 'function' then opts.callback() end
    end,
  }
end

function M.range(lhs, _rhs, opts)
  local function get_selected_text()
    -- Get visual selection marks
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]
    local start_col = vim.fn.getpos("'<")[3]
    local end_col = vim.fn.getpos("'>")[3]

    -- Get the selected text
    local lines = vim.fn.getline(start_line, end_line)

    local selected = ''
    if #lines == 1 then
      selected = string.sub(lines[1], start_col, end_col)
    else
      lines[1] = string.sub(lines[1], start_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
      ---@diagnostic disable-next-line: param-type-mismatch
      selected = table.concat(lines, '\n')
    end
    return selected
  end

  -- Execute the CLI tool and capture output
  local rhs = function()
    local text = get_selected_text()
    _rhs(text)
  end
  if opts.cli then
    rhs = function()
      local text = get_selected_text()
      local res = vim.fn.system(_rhs:format(text))
      if opts.print then
        vim.print(res)
      else
        vim.notify(res, vim.log.levels.INFO)
      end
    end
  end
  vim.api.nvim_create_user_command(lhs, rhs, { range = true })
end

-- generate a user command with completions
function M.user_command(command_name, cmds)
  local function complete(arg_lead)
    local commands = {}
    for name in pairs(cmds) do
      if name ~= 'default' then table.insert(commands, name) end
    end
    vim.print(commands)

    local pattern = arg_lead:gsub(
      '(.)',
      function(c) return string.format('%s[^%s]*', c:lower(), c:lower()) end
    )
    -- Case-insensitive fuzzy matching
    local matches = {}
    for _, command in ipairs(commands) do
      if string.find(command:lower(), pattern) then table.insert(matches, command) end
    end
    return matches
  end
  vim.api.nvim_create_user_command(command_name, function(opts)
    local args = vim.split(opts.args, '%s+', { trimempty = true })
    -- Default
    if #args == 0 then
      cmds['default'](opts)
      return
    end

    local command = args[1]
    table.remove(args, 1) -- Remove command
    if type(cmds[command]) == 'function' then
      cmds[command](opts)
    elseif cmds[command].basic then
      cmds[command].cb(args)
    else
      cmds[command].cb(opts)
    end
  end, {
    nargs = '*',
    bang = true,
    complete = complete,
  })
end

return M
