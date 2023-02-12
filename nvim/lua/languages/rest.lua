-- local M = {}

-- local ts_utils = require('nvim-treesitter.ts_utils')
-- local ts_query = require('nvim-treesitter.query')
-- local parsers = require('nvim-treesitter.parsers')
-- local locals = require('nvim-treesitter.locals')

-- local maps = require('utils/maps')

-- local rest_cmd = '!rest -nc'
-- local surrogate_language = 'hcl'

-- local ft_to_parser = parsers.filetype_to_parsername
-- ft_to_parser.rest = surrogate_language

-- function M.exec_block_under_cursor()
--   local query = [[(block (identifier) @requests (#eq? @requests "request")) @block]]
--   local success, parsed_query = pcall(function()
--     return vim.treesitter.parse_query(surrogate_language, query)
--   end)
--   if not success then
--     error('ts query parse failure')
--     return nil
--   end

--   local parser = parsers.get_parser(0, surrogate_language)
--   local root = parser:parse()[1]:root()
--   local start_row, _, end_row, _ = root:range()
--   local block_num = -1
--   local did_execute = false
--   for match in ts_query.iter_prepared_matches(parsed_query, root, 0, start_row, end_row) do
--     locals.recurse_local_nodes(match, function(_, node)
--       if node:type() == 'block' then
--         block_num = block_num + 1
--         local c_row = unpack(vim.api.nvim_win_get_cursor(0)) - 1
--         local s_row, _, e_row, _ = ts_utils.get_node_range(node)
--         if c_row >= s_row and c_row <= e_row then
--           vim.cmd(rest_cmd .. ' -f % -b ' .. block_num)
--           did_execute = true
--           return
--         end
--       end
--     end)
--   end
--   if not did_execute then
--     print('no block under cursor')
--   end
-- end

-- require('utils').create_augroups({
--   rest_lsp = {
--     {
--       event = 'BufRead,BufNewFile',
--       pattern = '*.rest',
--       callback = function()
--         vim.opt.filetype = 'rest'
--       end,
--     },
--     {
--       event = 'FileType',
--       pattern = 'rest',
--       callback = function()
--         vim.api.nvim_create_user_command('ExecuteFile', M.execute_block_under_cursor, {})
--         vim.api.nvim_create_user_command('ExecuteBlock', M.execute_block, { nargs = '?' })

--         maps.mode_group('n', {
--           { '<c-e>', M.execute_block },
--           { '<c-t>', M.execute_file },
--         })
--       end,
--     },
--   },
-- })

-- function M.execute_file()
--   vim.cmd(rest_cmd .. [[ -f % ]])
-- end

-- function M.execute_block(args)
--   local label = args.fargs[1]
--   -- execute the label if given
--   if label ~= nil then
--     vim.cmd(rest_cmd .. [[ -f % -l ]] .. label)
--     return
--   end
--   M.exec_block_under_cursor()
-- end

-- return M
