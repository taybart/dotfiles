--===============================
--============ Plugins ==========
--===============================

-- ensure packer is installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

return require('lazy').setup({

  ---------------------------------
  ---------- Probation ------------
  ---------------------------------
  --  { 'mfussenegger/nvim-dap' },
  --
  { 'pest-parser/pest.vim', ft = 'pest' },

  {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    cmd = { 'Mind' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  --  { 'eandrju/cellular-automaton.nvim' },

  {
    'jiaoshijie/undotree',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    keys = {
      {
        '<leader>u',
        function()
          require('undotree').toggle()
        end,
        { noremap = true, silent = true },
      },
    },
  },

  ---------------------------------
  --------- Productivity ----------
  ---------------------------------

  ----------
  -- find --
  ----------

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      require('plugins/telescope').setup()
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      close_if_last_window = true,
      enable_diagnostics = false,
      enable_git_status = false,
      hijack_netrw_behavior = 'open_default',
      window = {
        mappings = {
          ['<esc>'] = 'close_window',
        },
      },
      default_component_configs = {
        icon = {
          default = '',
        },
      },
    },
    keys = {
      { '<Leader>o', ':Neotree reveal toggle<cr>', { noremap = true, silent = true } },
      {
        '<Leader>f',
        ':Neotree toggle reveal position=float<cr>',
        { noremap = true, silent = true },
      },
    },
  },

  {
    'preservim/tagbar',
    cmd = { 'TagbarOpen', 'TagbarToggle' },
    init = function()
      vim.g.tagbar_type_go = {
        ctagstype = 'go',
        kinds = {
          'p:package',
          'i:imports:1',
          'c:constants',
          'v:variables',
          't:types',
          'n:interfaces',
          'w:fields',
          'e:embedded',
          'm:methods',
          'r:constructor',
          'f:functions',
        },
        sro = '.',
        kind2scope = {
          t = 'ctype',
          n = 'ntype',
        },
        scope2kind = {
          ctype = 't',
          ntype = 'n',
        },
        ctagsbin = 'gotags',
        ctagsargs = '-sort -silent',
      }
      vim.g.tagbar_type_rust = {
        ctagstype = 'rust',
        kinds = {
          'T:types',
          'f:functions',
          'g:enumerations',
          's:structures',
          'm:modules',
          'c:constants',
          't:traits',
          'i:trait implementations',
        },
      }
    end,
  },

  ----------
  -- edit --
  ----------
  -- lsp
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', config = true },
      { 'folke/neodev.nvim', ft = 'lua', config = true },
    },
    config = function()
      require('lsp')
    end,
  },

  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = 'rust',
    opts = {
      tools = {
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = true,
          show_parameter_hints = false,
          parameter_hints_prefix = '',
          other_hints_prefix = '',
        },
      },

      server = {
        on_attach = function()
          return require('lsp').on_attach
        end,
        settings = {
          ['rust-analyzer'] = {
            -- enable clippy on save
            checkonsave = {
              command = 'clippy',
            },
          },
        },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          keymaps = {
            apply_language_filter = '<C-g>',
          },
        },
      })
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    ft = { 'lua', 'sh', 'javascript', 'typescript', 'typescriptreact' },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          -- lua
          null_ls.builtins.formatting.stylua.with({
            extra_args = {
              '--config-path',
              vim.fn.expand('~/.dotfiles/nvim/stylua.toml'),
            },
          }),
          -- javascript
          null_ls.builtins.formatting.prettier.with({
            extra_args = { '--no-semi', '--single-quote' },
          }),
          -- sh
          null_ls.builtins.code_actions.shellcheck,
          -- python
          -- null_ls.builtins.formatting.black,
          -- null_ls.builtins.diagnostics.mypy,
        },
        root_dir = require('lspconfig/util').root_pattern(
          '.null-ls-root',
          'Makefile',
          '.git',
          'package.json'
        ),
      })
    end,
  },

  -- completions
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-calc' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-emoji' },
    },
    event = 'InsertEnter',
    config = function()
      require('plugins/cmp').setup()
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('plugins/luasnip')
    end,
  },

  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup({
        ignore = '^$',
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },

  -- surround using text objects
  {
    'tpope/vim-surround',
    config = function()
      -- make surround around [",',`] work as expected
      vim.cmd([[
      nmap ysa' ys2i'
      nmap ysa" 'ys2i"
      nmap ysa` 'ys2i`
      ]])
    end,
  },
  -- repeat extra stuff
  { 'tpope/vim-repeat' },
  -- additional subsitutions
  { 'tpope/vim-abolish' },
  -- git
  { 'tpope/vim-fugitive' },
  -- somebody come get her
  { 'tpope/vim-scriptease' },

  -- rest.vim
  -- { 'taybart/rest.vim' },

  -- b64.nvim
  { 'taybart/b64.nvim' },

  -- required with tmux
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- nice indicators for fF/tT
  { 'unblevable/quick-scope' },

  -- git gutter
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 0,
        },
        on_attach = function()
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<ignore>'
          end, { expr = true })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<ignore>'
          end, { expr = true })
        end,
      })
    end,
  },

  -----------------------------
  --------- Looks -------------
  -----------------------------

  -- syntax highlighting with treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
    config = function()
      require('plugins/treesitter').setup()
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'nvim-treesitter/nvim-treesitter-context' },
    },
  },

  -- tabs
  {
    'akinsho/nvim-bufferline.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          diagnostics = 'nvim_lsp',
          separator_style = 'slant',
          max_name_length = 30,
          show_close_icon = false,
          show_buffer_close_icons = false,
          right_mouse_command = '',
          middle_mouse_command = 'bdelete! %d',
        },
      })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('utils').reload_module('lualine')
      require('lualine').setup({
        sections = {
          lualine_b = { 'b:gitsigns_status' },
          lualine_c = {
            { 'filename', file_status = true, path = 1 },
          },
        },
      })
    end,
  },

  -- show indents
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        filetype_exclude = { 'help', 'TelescopePrompt' },
      })
    end,
  },

  -- colorscheme
  { 'gruvbox-community/gruvbox' },

  -----------------------------
  --------- Extras ------------
  -----------------------------
  { 'tweekmonster/startuptime.vim', cmd = { 'StartupTime' } },

  -- cool treesitter debugger
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle' },
    config = function()
      require('plugins/treesitter').setup_playground()
    end,
  },
})
