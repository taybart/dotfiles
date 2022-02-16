local ts_utils = require('nvim-treesitter.ts_utils')
local ts_query = require('nvim-treesitter.query')
local parsers = require('nvim-treesitter.parsers')
local locals = require('nvim-treesitter.locals')

local M = {}

local function intersects(row, col, sRow, sCol, eRow, eCol)
  if sRow > row or eRow < row then
    return false
  end
  if sRow == row and sCol > col then
    return false
  end
  if eRow == row and eCol < col then
    return false
  end
  return true
end

local function intersect_nodes(nodes, row, col)
  local found = {}
  for idx = 1, #nodes do
    local node = nodes[idx]
    local sRow = node.dim.s.r
    local sCol = node.dim.s.c
    local eRow = node.dim.e.r
    local eCol = node.dim.e.c

    if intersects(row, col, sRow, sCol, eRow, eCol) then
      table.insert(found, node)
    end
  end

  return found
end

local function count_parents(node)
  local count = 0
  local n = node.declaring_node
  while n ~= nil do
    n = n:parent()
    count = count + 1
  end
  return count
end

local function sort_nodes(nodes)
  table.sort(nodes, function(a, b)
    return count_parents(a) < count_parents(b)
  end)
  return nodes
end

M.get_all_nodes = function(query, lang, bufnr, pos_row)
  bufnr = bufnr or 0
  -- todo a huge number
  pos_row = pos_row or 30000
  local success, parsed_query = pcall(function()
    return vim.treesitter.parse_query(lang, query)
  end)
  if not success then
    return nil
  end

  local parser = parsers.get_parser(bufnr, lang)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  local results = {}
  for match in ts_query.iter_prepared_matches(parsed_query, root, bufnr, start_row, end_row) do
    local sRow, sCol, eRow, eCol
    local declaration_node
    local type = ''
    local name = ''
    local op = ''
    locals.recurse_local_nodes(match, function(_, node, path)
      -- local idx = string.find(path, ".", 1, true)
      local idx = string.find(path, '.[^.]*$') -- find last .
      op = string.sub(path, idx + 1, #path)
      type = string.sub(path, 1, idx - 1)

      --
      -- may not handle complex node
      if op == 'name' then
        -- ulog("node name " .. name)
        name = ts_utils.get_node_text(node, bufnr)[1]
      elseif op == 'declaration' or op == 'clause' then
        declaration_node = node
        sRow, sCol, eRow, eCol = node:range()
        sRow = sRow + 1
        eRow = eRow + 1
        sCol = sCol + 1
        eCol = eCol + 1
      end
    end)
    if declaration_node ~= nil then
      table.insert(results, {
        declaring_node = declaration_node,
        dim = { s = { r = sRow, c = sCol }, e = { r = eRow, c = eCol } },
        name = name,
        operator = op,
        type = type,
      })
    end
  end
  return results
end

M.nodes_at_cursor = function(query)
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'ft')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local nodes = M.get_all_nodes(query, ft, bufnr, row)
  if nodes == nil then
    print('Unable to find any nodes.  Is your query correct?')
    return nil
  end

  nodes = sort_nodes(intersect_nodes(nodes, row, col))
  if nodes == nil or #nodes == 0 then
    print('Unable to find any nodes at pos. ' .. tostring(row) .. ':' .. tostring(col))
    return nil
  end

  return nodes
end

return M
