return {
  setup = function()
    require('neorg').setup({
      -- Tell Neorg what modules to load
      load = {
        ['core.defaults'] = {}, -- Load all the default modules
        ['core.norg.concealer'] = {}, -- Allows for use of icons
        ['core.norg.completion'] = {
          config = { engine = 'nvim-cmp' },
        },
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              notes = "~/.neorg_notes"
            }
          }
        },
        ["core.keybinds"] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = "<Leader>o" -- This is the default if unspecified
        }
      },
    },
    --[[
    hook = function()
      -- Require the user callbacks module, which allows us to tap into the core of Neorg
      local neorg_callbacks = require('neorg.callbacks')
      neorg_callbacks.on_event('core.keybinds.events.enable_keybinds',
      function(_, keybinds)
        keybinds.map_event_to_mode('norg', {
          n = { -- Bind keys in normal mode
          -- Keys for managing TODO items and setting their states
          { 'gtd', 'core.norg.qol.todo_items.todo.task_done' },
          { 'gtu', 'core.norg.qol.todo_items.todo.task_undone' },
          { 'gtp', 'core.norg.qol.todo_items.todo.task_pending' },
          { '<C-Space>', 'core.norg.qol.todo_items.todo.task_cycle' }
        },
      }, { silent = true, noremap = true })
    end)
  end
  ]]--
})
  end
}
