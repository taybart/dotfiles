local M = {}

local ts_utils = require('nvim-treesitter.ts_utils')
local ts_query = require('nvim-treesitter.query')
local parsers = require('nvim-treesitter.parsers')
local locals = require('nvim-treesitter.locals')

local maps = require('utils/maps')

local ft_to_parser = parsers.filetype_to_parsername
ft_to_parser.rest = 'hcl'

local function get_requests()
  local query = [[(block (identifier) @requests (#eq? @requests "request")) @block]]
  local success, parsed_query = pcall(function()
    return vim.treesitter.parse_query('hcl', query)
  end)
  if not success then
    error('ts query parse failure')
    return nil
  end

  local parser = parsers.get_parser(0, 'hcl')
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  local block_num = -1
  for match in ts_query.iter_prepared_matches(parsed_query, root, 0, start_row, end_row) do
    locals.recurse_local_nodes(match, function(_, node)
      if node:type() == 'block' then
        block_num = block_num + 1
        local c_row = unpack(vim.api.nvim_win_get_cursor(0)) - 1
        local s_row, _, e_row, _ = ts_utils.get_node_range(node)
        -- print(node:type(), s_row, e_row, c_row)
        if c_row >= s_row and c_row <= e_row then
          print('exec block ' .. block_num)
          vim.cmd('!rest -nc -f % -b ' .. block_num)
          return
        end
      end
    end)
  end

  print('error: no block under cursor')
end

require('utils').create_augroups({
  rest_lsp = {
    {
      event = 'BufRead,BufNewFile',
      pattern = '*.rest',
      callback = function()
        vim.opt.filetype = 'rest'
      end,
    },
    {
      event = 'FileType',
      pattern = 'rest',
      callback = function()
        vim.api.nvim_create_user_command('ExecuteBlock', M.execute_block, { nargs = '?' })

        maps.mode_group('n', {
          { '<c-E>', ':!rest -nc -f %<cr>' },
          { '<c-e>', ':ExecuteBlock<cr>' },
        })
      end,
    },
  },
})

function M.execute_block()
  get_requests()
end

return M
