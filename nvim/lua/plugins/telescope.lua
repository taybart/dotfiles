local M = {}

local builtin = require('telescope.builtin')

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
    },
    pickers = {
      find_files = { hidden = true },
    },
  })
  -- telescope.load_extension('fzf')
end

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

return M
