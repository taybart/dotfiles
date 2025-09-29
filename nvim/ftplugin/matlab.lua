local matlab = {}

local cmds = require('utils/commands')

cmds.set_run(matlab.run)

local function strip_whitespace(tbl)
  local ret = {}
  for index, entry in pairs(tbl) do
    if entry ~= '' then
      local sub = entry:gsub('%s+', '')
      table.insert(ret, { content = sub, index = index })
    end
  end
  return ret
end

function matlab.run()
  if not vim.g.calc_nvim_namespace then
    vim.g.calc_nvim_namespace = vim.api.nvim_create_namespace('calc_nvim')
  end
  local job = 'octave ' .. vim.fn.expand('%')
  vim.fn.jobstart(job, {
    on_stdout = function(_, data)
      data = require('utils/job').handle_data(data)
      if not data then
        return
      end
      -- Get file contents
      local lines = strip_whitespace(vim.api.nvim_buf_get_lines(0, 0, -1, true))
      data = strip_whitespace(data)
      print('lines', vim.inspect(lines))
      print('data', vim.inspect(data))
      -- clear virtual
      vim.api.nvim_buf_clear_namespace(0, vim.g.calc_nvim_namespace, 0, -1)
      for _, j in ipairs(data) do
        -- if ans set virtual text
        if j.content:match('^ans') then
          print(lines[1].index - 1, lines[1].contents)
          -- vim.api.nvim_buf_set_virtual_text(0,
          -- vim.g.calc_nvim_namespace, lines[1].index-1, {{j, 'Comment'}}, {})
          -- table.remove(lines, 1)
        end
      end
    end,
  })
end

return matlab
