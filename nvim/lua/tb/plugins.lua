--===============================
--============ Plugins ==========
--===============================

-- ensure packer is installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

return require('packer').startup({function()
  local use = require('packer').use
  use { 'wbthomason/packer.nvim' }

  ---------------------------------
  ---------- Probation ------------
  ---------------------------------

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.cmd('au FileType help IndentBlanklineDisable')
    end
  }

  use { 'tweekmonster/startuptime.vim', cmd = {'StartupTime'} }

  -- cool treesitter debugger
  use {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
    config = function() require('tb/plugins/treesitter').setup_playground() end
  }

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
    config = require('tb/plugins/telescope').setup,
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {
    'taybart/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    cmd = {'NvimTreeToggle', 'NvimTreeFindFile'},
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

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-calc' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-nvim-lsp' },
    },
    config = function() require('tb/plugins/cmp').setup() end,
  }

  -- comment using text objects
  use { 'tpope/vim-commentary' }
  -- surround using text objects
  use {
    'tpope/vim-surround',
    config = function()
      -- make surround around [",',`] work as expected

      require('tb/utils/maps').mode_map_group('n', {}, {
        {'ysa\'', 'ys2i\''},
        {'ysa"', 'ys2i"'},
        {'ysa`', 'ys2i`'},
      })
    end,
  }
  -- repeat extra stuff
  use { 'tpope/vim-repeat' }
  -- additional subsitutions
  use { 'tpope/vim-abolish' }
  -- git
  use {
    'tpope/vim-fugitive',
    config = function()
      -- 2021-08-25 not really using these, put in the scrap in 2 weeks
      require('tb/utils/maps').mode_map_group('n', {}, {
        {'<leader>gs', '<cmd>Git<cr>'},
        {'<leader>gj', '<cmd>diffget //3<cr>'},
        {'<leader>gf', '<cmd>diffget //2<cr>'},
      })
    end,
  }

  -- rest.vim
  use { 'taybart/rest.vim' }

  -- b64.nvim
  use { 'taybart/b64.nvim' }

  -- useful lua functions
  use { 'nvim-lua/plenary.nvim' }

  -- required with tmux
  use { 'christoomey/vim-tmux-navigator' }
  vim.g.tmux_navigator_no_mappings = 1

  -- nice indicators for fF/tT
  use { 'unblevable/quick-scope' }

  -- treesitter text objects
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = '0.5-compat',
    config = function() require('tb/plugins/treesitter').setup_textobjects() end
  }

  -- git gutter
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function ()
      vim.cmd[[
      command! HunkReset lua require'gitsigns'.reset_hunk()
      command! HunkStage lua require'gitsigns'.stage_hunk()
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

  -- treesitter commentstring
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('nvim-treesitter.configs').setup {
        context_commentstring = {
          enable = true
        },
      }
    end
  }

  -- syntax highlighting with treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = ':TSUpdate',
    config = function() require('tb/plugins/treesitter').setup() end
  }

  -- tabs
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function ()
      require('bufferline').setup{
        options = {
          diagnostics = 'nvim_lsp',
          separator_style = 'slant',
          max_name_length = 30,
          show_close_icon = false,
          right_mouse_command = nil,
          middle_mouse_command = 'bdelete! %d',
        }
      }
    end
  }

  -- status
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      require('tb/utils').reload_module('lualine')
      require('lualine').setup{
        sections = {
          lualine_b = { 'b:gitsigns_status' },
          lualine_c = {
            { 'filename', file_status = true, path = 1 },
            -- { 'diagnostics', sources = { 'nvim_lsp' } },
          }
        }
      }
    end,
  }
  -- bash escape coloring TODO lazy load this on cmd "FixShellColors"
  -- use { 'chrisbra/Colorizer' {opt=true}}
  use {
    'norcalli/nvim-colorizer.lua',
    opt = true,
    config = function() require('colorizer').setup() end,
  }

  -- colorscheme
  -- use { 'gruvbox-community/gruvbox' }
  -- fix lsp colors for gruvbox
  -- use { 'folke/lsp-colors.nvim' }
  use { 'ellisonleao/gruvbox.nvim', requires = {'rktjmp/lush.nvim'} }

  -----------------------------
  --------- Extras ------------
  -----------------------------

  -- neorg
  use {
    'vhyrro/neorg',
    ft = 'norg',
    branch = 'unstable',
    config = function() require('tb/plugins/norg').setup() end,
    requires = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
  }
end, config = {
display = {
  open_fn = function()
    return require('packer.util').float({ border = 'single' })
  end
}
}})
