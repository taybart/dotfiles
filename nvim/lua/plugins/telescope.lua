local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function()
      callback(prompt_bufnr)
    end)
  end
end
local function multiopen(prompt_bufnr, _method)
  local method = _method or 'default'
  local cmd_map = { vertical = 'vsplit', horizontal = 'split', default = 'edit' }

  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')

  local picker = action_state.get_current_picker(prompt_bufnr)

  local multi_selection = picker:get_multi_selection()
  if #multi_selection > 1 then
    pickers.on_close_prompt(prompt_bufnr)
    pcall(vim.api.nvim_set_current_win, picker.original_win_id)

    for i, entry in ipairs(multi_selection) do
      local cmd = i == 1 and 'edit' or cmd_map[method]
      vim.cmd(('%s %s'):format(cmd, entry.value))
    end
  else
    actions['select_' .. method](prompt_bufnr)
  end
end

local keys = {
  grep = function()
    require('telescope.builtin').live_grep()
  end,
  grep_cword = function()
    require('telescope.builtin').grep_string({
      search = vim.fn.expand('<cword>'),
    })
  end,
  files = function()
    require('telescope.builtin').find_files({ follow = true })
  end,
  help = function()
    require('telescope.builtin').help_tags()
  end,
  buffers = function()
    require('telescope.builtin').buffers()
  end,
  old_files = function()
    require('telescope.builtin').oldfiles()
  end,
  edit_config = function()
    require('telescope.builtin').find_files({
      search_dirs = { '~/.dotfiles/nvim' },
    })
  end,
}

return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  keys = {
    { '<c-s>',      keys.grep },
    { 'g<c-s>',     keys.grep_cword },
    { '<c-p>',      keys.files },
    { '<c-h>',      keys.help },
    { '<c-b>',      keys.buffers },
    { '<leader>of', keys.old_files },
    { '<leader>ev', keys.edit_config },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '👉 ',
        sorting_strategy = 'ascending',
        layout_config = { horizontal = { prompt_position = 'top' } },
        path_display = { 'truncate' },
        file_ignore_patterns = {
          'node_modules',
          '%.git',
          'yarn.lock',
          'package-lock.json',
          'target/',
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--follow',
        },
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<cr>'] = stopinsert(multiopen),
          },
          n = {
            ['<cr>'] = multiopen,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          mappings = { i = { ['<C-s>'] = actions.to_fuzzy_refine } },
        },
        live_grep = {
          mappings = { i = { ['<C-s>'] = actions.to_fuzzy_refine } },
        },
      },
    })
  end,
}
