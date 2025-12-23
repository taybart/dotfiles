return function(lines, opts)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'acwrite', { buf = buf })

  -- Calculate window size
  local width = 50
  local height = #lines + 2

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = 'rounded',
    title = opts.title or '',
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = buf,
    callback = function()
      -- TODO: this should not be on bufwritepre, we should be writing to scratch,
      -- this would be on bufclose? i think
      opts.cb(
        vim.api.nvim_buf_get_lines(buf, 0, -1, false),
        { buf = buf, win = win, close = function() vim.api.nvim_win_close(win, true) end }
      )
      vim.api.nvim_win_close(win, true)
    end,
  })

  -- Handle cancel (Escape)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Escape>', '', {
    noremap = true,
    callback = function() vim.api.nvim_win_close(win, true) end,
  })
end
