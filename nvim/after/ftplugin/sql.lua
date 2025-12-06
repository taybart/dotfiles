-- Get the statement node under the cursor
local function get_stmt_ts_node()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- 0-based for treesitter

  local ok, parser = pcall(vim.treesitter.get_parser, buf, 'sql')
  if not ok or not parser then return nil end

  local root = parser:parse()[1]:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  while node do
    if node:type() == 'statement' then return node end
    node = node:parent()
  end

  return nil
end

-- Get text of the statement under cursor
local function get_stmt_under_cursor()
  local node = get_stmt_ts_node()
  if not node then return nil end
  local stmt = vim.treesitter.get_node_text(node, 0)
  return stmt:gsub('\n', ' '):gsub('%s+', ' ') .. ';'
end

-- Highlight the statement under cursor
local function highlight()
  local buf = vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace('sql_statement_hl')

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local node = get_stmt_ts_node()
  if not node then return end

  local srow, scol = node:start()
  local erow, ecol = node:end_()

  vim.api.nvim_buf_set_extmark(buf, ns, srow, scol, {
    end_row = erow,
    end_col = ecol,
    hl_group = 'CursorLine',
    priority = 100,
  })
end

vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('SqlHighlight', { clear = true }),
  callback = highlight,
})

local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ''
-- extract URL: -- DB url  or  /* DB url */
-- TODO: add env(PASSWORD) check and resolution
local db_uri = first_line:match('^%-%-%s*DB%s+(%S+)') or first_line:match('^/%*%s*DB%s+(%S+)')
if db_uri then
  vim.keymap.set('v', '<leader>g', function(opts)
    local range = ''
    if opts.line1 and opts.line2 then range = opts.line1 .. ',' .. opts.line2 end
    vim.cmd(range .. 'DB ' .. db_uri .. ' ' .. table.concat(opts.fargs, ' '))
  end, { noremap = true, buffer = true })

  -- vim.keymap.set(
  --   'n',
  --   '<leader>g',
  --   function() vim.cmd('DB ' .. db_uri .. '< ') end,
  --   { noremap = true, buffer = true }
  -- )

  -- swp: save window position? its a plug keymap, not sure which one though
  vim.keymap.del('n', '<space>swp')
  vim.keymap.set('n', '<leader>s', function()
    local stmt = get_stmt_under_cursor()
    if not stmt then return end
    vim.notify(stmt)
    vim.cmd('DB ' .. db_uri .. ' ' .. stmt)
  end, { noremap = true, buffer = true })
end
