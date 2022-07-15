local M = {}

local ts_utils = require('nvim-treesitter.ts_utils')
local ts_query = require('nvim-treesitter.query')
local parsers = require('nvim-treesitter.parsers')
local locals = require('nvim-treesitter.locals')

local maps = require('utils/maps')

local rest_cmd = '!rest -nc'
local surrogate_language = 'hcl'

local ft_to_parser = parsers.filetype_to_parsername
ft_to_parser.rest = surrogate_language

local function exec_block_under_cursor()
  local query = [[(block (identifier) @requests (#eq? @requests "request")) @block]]
  local success, parsed_query = pcall(function()
    return vim.treesitter.parse_query(surrogate_language, query)
  end)
  if not success then
    error('ts query parse failure')
    return nil
  end

  local parser = parsers.get_parser(0, surrogate_language)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  local block_num = -1
  local did_execute = false
  for match in ts_query.iter_prepared_matches(parsed_query, root, 0, start_row, end_row) do
    locals.recurse_local_nodes(match, function(_, node)
      if node:type() == 'block' then
        block_num = block_num + 1
        local c_row = unpack(vim.api.nvim_win_get_cursor(0)) - 1
        local s_row, _, e_row, _ = ts_utils.get_node_range(node)
        if c_row >= s_row and c_row <= e_row then
          vim.cmd(rest_cmd .. ' -f % -b ' .. block_num)
          did_execute = true
          return
        end
      end
    end)
  end
  if not did_execute then
    print('no block under cursor')
  end
end

function M.popup_rest()
  local Popup = require('nui.popup')
  local event = require('nui.utils.autocmd').event

  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
    },
    position = '50%',
    size = {
      width = '80%',
      height = '60%',
    },
    buf_options = {
      buflisted = false,
    },
  })

  -- mount/open the component
  popup:mount()

  popup:on({ event.BufWinLeave }, function()
    vim.schedule(function()
      vim.cmd('bd')
      popup:unmount()
    end)
  end, { once = true })
  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    vim.cmd('bd')
    popup:unmount()
  end)

  vim.cmd('e client.rest')
  -- set content
  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { 'Hello World' })
end
vim.api.nvim_create_user_command('OpenRestClient', M.popup_rest, {})

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
        vim.api.nvim_create_user_command('ExecuteFile', M.execute_file, {})
        vim.api.nvim_create_user_command('ExecuteBlock', M.execute_block, { nargs = '?' })

        maps.mode_group('n', {
          { '<c-e>', ':ExecuteBlock<cr>' },
          -- { '<c-E>', ':ExecuteFile<cr>' },
        })
      end,
    },
  },
})

function M.execute_file()
  vim.cmd(rest_cmd .. [[ -f % ]])
end
function M.execute_block(args)
  local label = args.fargs[1]
  -- execute the label if given
  if label ~= '' then
    vim.cmd(rest_cmd .. [[ -f % -l ]] .. label)
    return
  end
  exec_block_under_cursor()
end

return M
