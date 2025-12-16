return function(opts)
  local prompt = opts.prompt or '? [y/N]'

  if opts.default == nil then
    opts.default = false
  end

  -- Get dimensions
  local width = #prompt + 4 -- Add some padding
  local height = 3

  -- Calculate position (center of screen)
  local lines = vim.o.lines
  local columns = vim.o.columns
  local row = math.floor((lines - height) / 2)
  local col = math.floor((columns - width) / 2)

  -- Create the buffer for our floating window
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    string.rep(' ', width), -- Empty padding line
    '  ' .. prompt, -- Prompt with padding
    string.rep(' ', width), -- Empty padding line
  })
  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Confirm ',
    title_pos = 'center',
  })

  -- Set up keymaps
  local maps = { ['y'] = true, ['n'] = true, ['<esc>'] = false, ['<enter>'] = opts.default }
  for k, v in pairs(maps) do
    vim.keymap.set('n', k, function()
      vim.api.nvim_win_close(win, true)
      if opts.callback then
        opts.callback(v)
      end
    end, { noremap = true, silent = true, buffer = buf })
  end

  -- Return focus to the window
  vim.api.nvim_set_current_win(win)
end
