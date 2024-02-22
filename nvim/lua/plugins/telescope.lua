local function edit_config()
  require('telescope.builtin').find_files({
    search_dirs = { '~/.dotfiles/nvim/lua' },
  })
end

local function search_cword()
  local word = vim.fn.expand('<cword>')
  require('telescope.builtin').grep_string({ search = word })
end

local function search_selection()
  local reg_cache = vim.fn.getreg(0)
  -- Reselect the visual mode text, cut to reg b
  vim.cmd('normal! gv"0y')
  require('telescope.builtin').grep_string({ search = vim.fn.getreg(0) })
  vim.fn.setreg(0, reg_cache)
end

local function multiopen(prompt_bufnr, method)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
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

return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-live-grep-args.nvim' },
    { 'nvim-telescope/telescope-github.nvim' },
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local transform_mod = require('telescope.actions.mt').transform_mod
    local actions = require('telescope.actions')
    local lga_actions = require('telescope-live-grep-args.actions')

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

    require('utils/maps').group({ noremap = true }, {
      {
        'n',
        -- Live grep
        { '<c-s>', telescope.extensions.live_grep_args.live_grep_args },
        -- Search under cursor
        { 'g<c-s>', search_cword },
        -- Find files
        {
          '<c-p>',
          function()
            builtin.find_files({ follow = true })
          end,
        },
        -- Find help tags
        { '<c-h>', builtin.help_tags },
        -- Find open buffers
        { '<c-b>', builtin.buffers },
        { '<leader>of', builtin.oldfiles },

        { '<leader>ev', edit_config },
      },
      {
        'v',
        -- Search using selected text
        { '<c-s>', search_selection },
      },
    })

    telescope.setup({
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
          '--follow',
        },
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-v>'] = stopinsert(custom_actions.multi_selection_open_vertical),
            ['<c-s>'] = stopinsert(custom_actions.multi_selection_open_horizontal),
            ['<cr>'] = stopinsert(custom_actions.multi_selection_open),
          },
          n = {
            ['<c-v>'] = custom_actions.multi_selection_open_vertical,
            ['<c-s>'] = custom_actions.multi_selection_open_horizontal,
            ['<cr>'] = custom_actions.multi_selection_open,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        live_grep = {
          mappings = {
            i = {
              ['<C-s>'] = actions.to_fuzzy_refine,
            },
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = { -- extend mappings
            i = {
              ['<c-s>'] = actions.to_fuzzy_refine,
              ['<c-k>'] = lga_actions.quote_prompt(),
              ['<c-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        },
      },
    })
    telescope.load_extension('live_grep_args')
  end,
}
