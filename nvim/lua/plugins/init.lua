return {
  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').mode_group('n', {
        { '<c-f><left>', ':TmuxNavigateLeft<cr>' },
        { '<c-f><down>', ':TmuxNavigateDown<cr>' },
        { '<c-f><up>', ':TmuxNavigateUp<cr>' },
        { '<c-f><right>', ':TmuxNavigateRight<cr>' },
      }, { noremap = true, silent = true })
    end,
  },

  { 'zbirenbaum/copilot.lua', config = true },

  --[==================[
  -- Probation
  --]==================]

  {
    'tzachar/local-highlight.nvim',
    config = true,
  },

  {
    'OXY2DEV/markview.nvim',
    config = true,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      -- -- Toggle previous & next buffers stored within Harpoon list
      -- vim.keymap.set('n', '<c-s-p>', function()
      --   harpoon:list():prev()
      -- end)
      -- vim.keymap.set('n', '<c-s-n>', function()
      --   harpoon:list():next()
      -- end)
      vim.keymap.set('n', '<c-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- -- basic telescope configuration
      -- local conf = require('telescope.config').values
      -- local function toggle_telescope(harpoon_files)
      --   local file_paths = {}
      --   for _, item in ipairs(harpoon_files.items) do
      --     table.insert(file_paths, item.value)
      --   end

      --   local make_finder = function()
      --     local paths = {}
      --     for _, item in ipairs(harpoon_files.items) do
      --       table.insert(paths, item.value)
      --     end

      --     return require('telescope.finders').new_table({
      --       results = paths,
      --     })
      --   end

      --   require('telescope.pickers')
      --     .new({}, {
      --       prompt_title = 'Harpoon',
      --       finder = require('telescope.finders').new_table({
      --         results = file_paths,
      --       }),
      --       previewer = conf.file_previewer({}),
      --       sorter = conf.generic_sorter({}),
      --       attach_mappings = function(prompt_buffer_number, map)
      --         -- Delete selected entry from the list
      --         map('i', '<C-d>', function()
      --           local state = require('telescope.actions.state')
      --           local selected_entry = state.get_selected_entry()
      --           local current_picker = state.get_current_picker(prompt_buffer_number)

      --           harpoon:list():remove_at(selected_entry.index)
      --           print(vim.inspect(harpoon:list().items))
      --           current_picker:refresh(make_finder())
      --         end)
      --         return true
      --       end,
      --     })
      --     :find()
      -- end

      -- vim.keymap.set('n', '<C-e>', function()
      --   toggle_telescope(harpoon:list())
      -- end, { desc = 'Open harpoon window' })
    end,
  },
}
