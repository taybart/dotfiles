return function(title, options, callback, preview)
  Snacks.picker.pick({
    title = title,
    items = options,
    format = 'text',
    -- preview = 'text',
    confirm = function(picker, item)
      picker:close()
      callback(item)
    end,
    preview = function(ctx)
      if ctx.item then
        if preview then
          vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, preview(ctx))
        else
          local item = vim.inspect(ctx.item)
          print(item)
          vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, vim.split(item, '\n'))
        end
        return true
      end
    end,
  })
end
-- return function(title, options, callback)
--   local pickers = require('telescope.pickers')
--   local finders = require('telescope.finders')
--   local actions = require('telescope.actions')
--   local config = require('telescope.config').values
--   local action_state = require('telescope.actions.state')
--   pickers
--     .new({}, {
--       prompt_title = title,
--       attach_mappings = function(prompt_bufnr)
--         actions.select_default:replace(function()
--           actions.close(prompt_bufnr)
--           local selection = action_state.get_selected_entry()
--           callback(selection[1])
--         end)
--         return true
--       end,
--       finder = finders.new_table({
--         results = options,
--       }),
--       sorter = config.generic_sorter({}),
--     })
--     :find()
-- end
