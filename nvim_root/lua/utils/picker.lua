local M = {}

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local config = require('telescope.config').values
local action_state = require('telescope.actions.state')

function M.pick(title, options, callback)
  pickers.new({}, {
    prompt_title = title,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        callback(selection[1])
      end)
      return true
    end,
    finder = finders.new_table({
      results = options,
    }),
    sorter = config.generic_sorter({}),
  }):find()
end

return M
