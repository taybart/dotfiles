-- ==============================
-- =========== Plugins ==========
-- ==============================

-- ensure packer is installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

vim.cmd('autocmd BufWritePost plugins.lua source <afile> | PackerCompile')

return require('packer').startup(function()
  local use = require('packer').use
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  ---------------------------------
  ---------- Probation ------------
  ---------------------------------
  use { 'tweekmonster/startuptime.vim', opt = true, cmd = {'StartupTime'} }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('tb/utils').reload_module('lualine')
      require('lualine').setup{
          sections = {
            lualine_c = {
              {
                'filename',
                 -- displays file status (readonly status, modified status)
                file_status = true,
                 -- 0 = just filename, 1 = relative path, 2 = absolute path
                path = 1
              }
            }
          }
      }
    end,
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function ()
      require("bufferline").setup{
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          max_name_length = 30,
          show_close_icon = false,
          right_mouse_command = nil,
          middle_mouse_command = "bdelete! %d",
          name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
            return vim.fn.fnamemodify(buf.name, ':t:r')
            -- -- remove extension from markdown files for example
            -- if buf.name:match('%.md') then
            --   return vim.fn.fnamemodify(buf.name, ':t:r')
            -- end
          end,
        }
      }
    end
  }

  -- treesitter commentstring
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- fix lsp colors
  use 'folke/lsp-colors.nvim'

  -- replace tagbar, don't really need it
  use { 'liuchengxu/vista.vim' }

  -- cool treesitter debugger
  use { 'nvim-treesitter/playground', opt = true, cmd = 'TSPlaygroundToggle' }

  -- neorg
  use {
    "vhyrro/neorg",
    ft = "norg",
    config = function()
        require('neorg').setup {
            -- Tell Neorg what modules to load
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.norg.concealer"] = {}, -- Allows for use of icons
            },
            hook = function()
              -- Require the user callbacks module, which allows us to tap into the core of Neorg
              local neorg_callbacks = require('neorg.callbacks')
              neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
                keybinds.map_event_to_mode("norg", {
                  n = { -- Bind keys in normal mode
                  -- Keys for managing TODO items and setting their states
                  { "gtd", "core.norg.qol.todo_items.todo.task_done" },
                  { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
                  { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
                  { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" }

                },
              }, { silent = true, noremap = true })

            end)
          end
        }
      end,
      requires = "nvim-lua/plenary.nvim"
    }

  ---------------------------------
  --------- Productivity ----------
  ---------------------------------

  ----------
  -- find --
  ----------
  use {
    'nvim-telescope/telescope.nvim',
    branch = 'async_v2',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim' }}
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }
  vim.g.nvim_tree_auto_close = 1
  vim.g.nvim_tree_hide_dotfiles = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_highlight_opened_files = 1
  vim.g.nvim_tree_auto_resize = 0
  vim.g.nvim_tree_width = '30%'
  vim.g.nvim_tree_window_picker_exclude = {
    filetype = { 'packer', 'vista' },
  }

  use { 'dyng/ctrlsf.vim' }

  ----------
  -- edit --
  ----------
  -- lsp
  use { 'neovim/nvim-lspconfig' }
  use { 'kabouzeid/nvim-lspinstall' }
  use { 'hrsh7th/nvim-compe' }

  -- comments
  use { 'tpope/vim-commentary' }
  -- surround
  use { 'tpope/vim-surround' }
  -- repeat extra stuff
  use { 'tpope/vim-repeat' }
  -- additional subsitutions
  use { 'tpope/vim-abolish' }
  -- git
  use { 'tpope/vim-fugitive', opt = true, cmd = { 'Git' } }

  -- rest.vim
  use { 'taybart/rest.vim' }
  -- b64.nvim
  use { 'taybart/b64.nvim' }

  -- useful lua functions
  use { 'nvim-lua/plenary.nvim', branch = 'async_jobs_v2' }

  -- required with tmux
  use { 'christoomey/vim-tmux-navigator' }
  vim.g.tmux_navigator_no_mappings = 1

  -- nice indicators for fF/tT
  use { 'unblevable/quick-scope' }

  -- git gutter type thing
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function ()

      vim.cmd[[
      command! ShowHunk lua require"gitsigns".preview_hunk()
      command! ResetHunk lua require"gitsigns".reset_hunk()
      command! StageHunk lua require"gitsigns".stage_hunk()
      ]]

      -- should not need this much config, revisit later
      require('gitsigns').setup{
        current_line_blame = true,
        current_line_blame_delay = 0,
        keymaps = {
          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

          -- ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          -- ['v <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          -- ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          -- ['n <leader>ghR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
          ['n <leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          -- ['n <leader>ghb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

          -- Text objects
          ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
          ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
        },
      }
    end
  }

  -----------------------------
  --------- Looks -------------
  -----------------------------

  -- syntax highlighting with treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = ':TSUpdate'
  }

  -- bash escape coloring TODO lazy load this on cmd "FixShellColors"
  -- use { 'chrisbra/Colorizer' {opt=true}}
  use { 'norcalli/nvim-colorizer.lua' }

  -- goyo
  use { 'junegunn/goyo.vim' }
  -- special global for checking if we are taking notes
  vim.g.goyo_mode = 0

  -- colorscheme
  use { 'gruvbox-community/gruvbox' }
  vim.g.gruvbox_italic = 1
  vim.g.gruvbox_sign_column = "bg0"

  -----------------------------
  --------- Extras ------------
  -----------------------------


end)
