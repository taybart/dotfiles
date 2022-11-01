local M = {}

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local transform_mod = require('telescope.actions.mt').transform_mod
local action_state = require('telescope.actions.state')

-- local function open_in_tree()
--   local entry = action_state.get_selected_entry()[1]
--   vim.cmd('Neotree reveal_file=' .. entry)

--   local m = vim.fn.mode()
--   if m == 'i' then
--     vim.cmd('stopinsert')
--   end
-- end

function M.edit_config()
  builtin.find_files({
    search_dirs = { '~/.dotfiles/nvim/lua' },
  })
end

function M.search_cword()
  local word = vim.fn.expand('<cword>')
  builtin.grep_string({ search = word })
end

function M.search_selection()
  local reg_cache = vim.fn.getreg(0)
  -- Reselect the visual mode text, cut to reg b
  vim.cmd('normal! gv"0y')
  builtin.grep_string({ search = vim.fn.getreg(0) })
  vim.fn.setreg(0, reg_cache)
end

local function multiopen(prompt_bufnr, method)
  local cmd_map = {
    vertical = 'vsplit',
    horizontal = 'split',
    default = 'edit',
  }
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if #multi_selection > 1 then
    require('telescope.pickers').on_close_prompt(prompt_bufnr)
    pcall(vim.api.nvim_set_current_win, picker.original_win_id)

    for i, entry in ipairs(multi_selection) do
      -- opinionated use-case
      local cmd = i == 1 and 'edit' or cmd_map[method]
      vim.cmd(string.format('%s %s', cmd, entry.value))
    end
  else
    actions['select_' .. method](prompt_bufnr)
  end
end

local custom_actions = transform_mod({
  multi_selection_open_vertical = function(prompt_bufnr)
    multiopen(prompt_bufnr, 'vertical')
  end,
  multi_selection_open_horizontal = function(prompt_bufnr)
    multiopen(prompt_bufnr, 'horizontal')
  end,
  multi_selection_open = function(prompt_bufnr)
    multiopen(prompt_bufnr, 'default')
  end,
})

local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function()
      callback(prompt_bufnr)
    end)
  end
end

function M.configure()
  require('telescope').setup({
    defaults = {
      prompt_prefix = '   ',
      -- selection_caret = '  ',
      selection_caret = '❯ ',
      sorting_strategy = 'ascending',
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          -- preview_width = 0.55,
          -- results_width = 0.8,
        },
      },
      border = {},
      winblend = 0,
      color_devicons = true,
      use_less = true,
      path_display = { 'truncate' },
      file_ignore_patterns = {
        'node_modules',
        '.git',
        'yarn.lock',
        'package-lock.json',
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      },
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          -- ['<c-s>'] = open_in_tree,
          ['<c-v>'] = stopinsert(custom_actions.multi_selection_open_vertical),
          ['<c-s>'] = stopinsert(custom_actions.multi_selection_open_horizontal),
          ['<cr>'] = stopinsert(custom_actions.multi_selection_open),
        },
        n = {
          -- ['<c-s>'] = open_in_tree,
          ['<c-v>'] = custom_actions.multi_selection_open_vertical,
          ['<c-s>'] = custom_actions.multi_selection_open_horizontal,
          ['<cr>'] = custom_actions.multi_selection_open,
        },
      },
    },
    pickers = {
      find_files = { hidden = true },
    },
  })
end

return M
