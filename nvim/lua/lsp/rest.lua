local M = {}

local maps = require('utils/maps')

local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
ft_to_parser.rest = 'hcl'

local function get_requests()
  local query = [[(block id: (identifier) @requests (#eq? @requests "request"))]]
  local ns = require('vim.treesitter.query').set_query('rest', 'rest_requests', query)
  if ns == nil then
    error('struct not found')
  end
  print(vim.inspect(ns))
end

-- vim.cmd([[
-- augroup rest_ft
-- au BufNewFile,BufRead *.rest set ft=rest
-- augroup end
-- ]])

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
        maps.mode_group('n', {
          { '<c-e>', ':!rest -nc -f %<cr>' },
        })

        vim.api.nvim_create_user_command('ExecuteBlock', M.execute_block, { nargs = '?' })
      end,
    },
  },
})

function M.execute_block()
  get_requests()
end

return M
