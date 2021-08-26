-- ==============================
-- =========== Plugins ==========
-- ==============================

-- ensure packer is installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

return require('packer').startup(function()
  local use = require('packer').use
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  ---------------------------------
  ---------- Probation ------------
  ---------------------------------
  use { "lukas-reineke/indent-blankline.nvim" }

  use { 'tweekmonster/startuptime.vim', opt = true, cmd = {'StartupTime'} }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('tb/utils').reload_module('lualine')
      require('lualine').setup{
          sections = {
            lualine_b = { "b:gitsigns_status" },
            lualine_c = {
              { 'filename', file_status = true, path = 1 },
              -- { "diagnostics", sources = { "nvim_lsp" } },
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
        }
      }
    end
  }

  -- treesitter commentstring
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- fix lsp colors
  use { 'folke/lsp-colors.nvim' }

  -- cool treesitter debugger
  use { 'nvim-treesitter/playground', opt = true, cmd = 'TSPlaygroundToggle' }

  ---------------------------------
  --------- Productivity ----------
  ---------------------------------

  ----------
  -- find --
  ----------
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          layout_config = {
            height = 0.9,
            preview_width = 60,
            width = 0.9,
          },
          prompt_prefix = " ",
          selection_caret = "❯ ",
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      require('telescope').load_extension('fzf')
    end
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {
    'taybart/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup{
        width = '30%',
        auto_close = true,
        hide_dotfiles = true,
        group_empty = true,
        highlight_opened_files = true,
        auto_resize = false,
        window_picker_exclude = {
          filetype = { 'packer' },
        },
      }
      -- vim.cmd('autocmd VimResized * lua Resize_nvim_tree()')
    end
  }

  ----------
  -- edit --
  ----------
  -- lsp
  use { 'neovim/nvim-lspconfig' }
  use { 'kabouzeid/nvim-lspinstall' }

  -- completion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'disable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = true;
        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          neorg = true;
        }
      }
    end
  }

    -- -- https://github.com/hrsh7th/nvim-cmp/issues/2
    -- use {
    --   'hrsh7th/nvim-cmp',
    --   requires = {
    --     { 'hrsh7th/cmp-buffer' },
    --     { 'hrsh7th/cmp-path' },
    --     { 'hrsh7th/cmp-calc' },
    --     { 'hrsh7th/cmp-nvim-lua' },
    --     { 'hrsh7th/cmp-nvim-lsp' },
    --   }
    -- }

  -- comment using text objects
  use { 'tpope/vim-commentary' }
  -- surround using text objects
  use { 'tpope/vim-surround' }
  -- repeat extra stuff
  use { 'tpope/vim-repeat' }
  -- additional subsitutions
  use { 'tpope/vim-abolish' }
  -- git
  use {
    'tpope/vim-fugitive',
    config = function()
      -- 2021-08-25 not really using these, put in the scrap in 2 weeks
     require('tb/utils/maps').nmap('<leader>gs', '<cmd>Git<cr>')
     require('tb/utils/maps').nmap('<leader>gj', '<cmd>diffget //3<cr>')
     require('tb/utils/maps').nmap('<leader>gf', '<cmd>diffget //2<cr>')
    end,
  }
  -- treesitter text objects
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = '0.5-compat',
    config = function()
      require'nvim-treesitter.configs'.setup {
      }
    end,
  }

  -- rest.vim
  use { 'taybart/rest.vim' }

  -- b64.nvim
  use { 'taybart/b64.nvim' }

  -- useful lua functions
  -- use { 'nvim-lua/plenary.nvim', branch = 'async_jobs_v2' }
  use { 'nvim-lua/plenary.nvim' }

  -- required with tmux
  use { 'christoomey/vim-tmux-navigator' }
  vim.g.tmux_navigator_no_mappings = 1

  -- nice indicators for fF/tT
  use { 'unblevable/quick-scope' }

  -- git gutter
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function ()
      vim.cmd[[
      command! HunkReset lua require"gitsigns".reset_hunk()
      command! HunkStage lua require"gitsigns".stage_hunk()
      ]]
      require('gitsigns').setup{
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 0,
        },
        keymaps = {
          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
          ['n gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['v gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          ['n <leader>b'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',
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
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'maintained',
        highlight = {
          enable = true,
        },
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {"BufWrite", "CursorHold"},
        },
        context_commentstring = {
          enable = true
        },
      }
    end
  }

  -- bash escape coloring TODO lazy load this on cmd "FixShellColors"
  -- use { 'chrisbra/Colorizer' {opt=true}}
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }

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

end)
