local M = {}

-- local function edit()
--   local header = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
--   local columns = vim.split(header, '%s', { trimempty = true })
--   -- get current line
--   local line = vim.api.nvim_get_current_line()
--   vim.notify(line)
-- end
--
local function edit_row_in_popup(lines, row_index, table_name, primary_key)
  -- Edit a row from dadbod output in a floating window

  -- Parse the output
  local columns, rows = M.parse_dadbod_output(lines)

  if #rows < row_index then
    vim.notify('Row ' .. row_index .. ' not found', vim.log.levels.ERROR)
    return
  end

  local row = rows[row_index]
  local original = vim.deepcopy(row)

  -- Create edit buffer content
  local edit_lines = {}
  for _, col in ipairs(columns) do
    local value = row[col] or ''
    table.insert(edit_lines, string.format('%s: %s', col, value))
  end

  -- Helper to parse edited buffer back into row
  local function parse_edited_buffer(_lines)
    -- local edited_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local edited_row = vim.deepcopy(row)

    for _, line in ipairs(_lines) do
      local col, value = line:match('^([^:]+):%s*(.*)$')
      if col and value then
        col = col:match('^%s*(.-)%s*$') -- trim
        edited_row[col] = value
      end
    end

    return edited_row
  end
  require('tools/popup')(edit_lines, {
    title = 'Edit Row ' .. row_index .. ' ' .. table_name,
    cb = function(_lines, opts)
      local edited_row = parse_edited_buffer(_lines)
      local sql = M.generate_update_statement(table_name, edited_row, primary_key, original)

      if sql then
        -- Insert SQL into previous buffer
        local prev_buf = vim.fn.bufnr('#')
        if prev_buf > 0 then
          vim.api.nvim_buf_set_lines(prev_buf, -1, -1, false, { '', sql })
          vim.notify('SQL generated: ' .. sql, vim.log.levels.INFO)
        end
      else
        vim.notify('No changes made', vim.log.levels.WARN)
      end

      opts.close()
    end,
  })
end

local function edit()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- Edit first data row (row 1)
  edit_row_in_popup(lines, 1, 'your_table', 'id')
end
vim.keymap.set('n', '<c-e>', edit, { noremap = true })

function M.parse_dadbod_output(lines)
  -- Parse vim-dadbod fixed-width output
  if #lines < 3 then error('Need at least header, separator, and data rows') end

  -- Get header and column names
  local header = lines[1]
  local columns = vim.split(header, '%s', { trimempty = true })

  -- Get separator line to find column positions
  local separator = lines[2]

  -- Find where each dash sequence starts and ends
  local col_positions = {}
  local i = 1
  while i <= #separator do
    if separator:sub(i, i) == '-' then
      local start = i
      while i <= #separator and separator:sub(i, i) == '-' do
        i = i + 1
      end
      local finish = i - 1
      table.insert(col_positions, { start = start, finish = finish })
    else
      i = i + 1
    end
  end

  -- Parse data rows (start from line 3)
  local rows = {}
  for row_idx = 3, #lines do
    local line = lines[row_idx]
    if line:match('%S') then -- Skip empty lines
      local row = {}
      for col_idx, col_pos in ipairs(col_positions) do
        local value = ''
        if col_pos.start <= #line then
          value = line:sub(col_pos.start, math.min(col_pos.finish, #line))
        end
        -- Trim whitespace
        value = value:match('^%s*(.-)%s*$') or ''
        row[columns[col_idx]] = value
      end
      table.insert(rows, row)
    end
  end

  return columns, rows
end

function M.generate_update_statement(table_name, row, primary_key, original_row)
  -- Generate UPDATE statement from edited row
  local updates = {}

  for key, new_value in pairs(row) do
    if key ~= primary_key then
      local orig_value = original_row[key] or ''
      if new_value ~= orig_value then
        -- Escape single quotes
        local escaped = new_value:gsub("'", "''")
        table.insert(updates, string.format("%s = '%s'", key, escaped))
      end
    end
  end

  if #updates == 0 then
    return nil -- No changes
  end

  local pk_value = row[primary_key]
  local sql = string.format(
    'UPDATE %s SET %s WHERE %s = %s;',
    table_name,
    table.concat(updates, ', '),
    primary_key,
    pk_value
  )
  return sql
end
