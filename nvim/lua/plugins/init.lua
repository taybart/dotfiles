--===============================
--============ Plugins ==========
--===============================

-- ensure packer is installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.api.nvim_command('packadd packer.nvim')
end

vim.cmd([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost */lua/plugins/init.lua source <afile> | PackerCompile
augroup end
]])

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })

    ---------------------------------
    ---------- Probation ------------
    ---------------------------------

    use({
      'ggandor/leap.nvim',
      config = function()
        require('leap').set_default_keymaps()
      end,
    })

    ---------------------------------
    --------- Productivity ----------
    ---------------------------------

    ----------
    -- find --
    ----------
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' },
      },
      config = function()
        require('plugins/telescope').configure()
      end,
    })

    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      config = function()
        require('neo-tree').setup({
          close_if_last_window = true,
          enable_diagnostics = false,
          enable_git_status = false,
          hijack_netrw_behavior = 'open_default',
          default_component_configs = {
            icon = {
              default = '',
            },
          },
        })

        require('utils/maps').mode_group('n', {
          { '<Leader>o', ':NeoTreeRevealToggle<cr>' },
          { '<Leader>f', ':Neotree toggle reveal position=float<cr>' },
        }, { noremap = true, silent = true })
      end,
    })

    use({
      'preservim/tagbar',
      cmd = { 'TagbarOpen', 'TagbarToggle' },
      setup = function()
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
      end,
    })

    ----------
    -- edit --
    ----------
    -- lsp
    use({ 'neovim/nvim-lspconfig' })
    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
      },
      config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
          sources = {
            -- lua
            null_ls.builtins.formatting.stylua.with({
              extra_args = { '--config-path', vim.fn.expand('~/.dotfiles/nvim/stylua.toml') },
            }),
            -- javascript
            null_ls.builtins.formatting.prettier.with({
              extra_args = { '--no-semi', '--single-quote' },
            }),
            -- sh
            null_ls.builtins.code_actions.shellcheck,
            -- python
            null_ls.builtins.formatting.black,
            null_ls.builtins.diagnostics.mypy,
          },
          root_dir = require('lspconfig.util').root_pattern(
            '.null-ls-root',
            'Makefile',
            '.git',
            'package.json'
          ),
        })
      end,
    })

    -- completions
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-calc' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-emoji' },
      },
      config = function()
        require('plugins/cmp').configure()
      end,
    })

    use({
      'L3MON4D3/LuaSnip',
      config = function()
        require('plugins/luasnip')
      end,
    })

    use({
      'numToStr/Comment.nvim',
      requires = { { 'JoosepAlviste/nvim-ts-context-commentstring' } },
      config = function()
        require('plugins/comment').configure()
      end,
    })

    -- comment using text objects
    -- use { 'tpope/vim-commentary' }
    -- surround using text objects
    use({
      'tpope/vim-surround',
      config = function()
        -- make surround around [",',`] work as expected
        require('utils/maps').mode_group('n', {
          { "ysa'", "ys2i'" },
          { 'ysa"', 'ys2i"' },
          { 'ysa`', 'ys2i`' },
        })
      end,
    })
    -- repeat extra stuff
    use({ 'tpope/vim-repeat' })
    -- additional subsitutions
    use({ 'tpope/vim-abolish' })
    -- git
    use({
      'tpope/vim-fugitive',
      config = function()
        -- 2021-08-25 not really using these, put in the scrap in 2 weeks
        require('utils/maps').mode_group('n', {
          { 'gs', '<cmd>Git<cr>' },
          { '<leader>gj', '<cmd>diffget //3<cr>' },
          { '<leader>gf', '<cmd>diffget //2<cr>' },
        })
      end,
    })
    -- somebody come get her
    use({ 'tpope/vim-scriptease' })

    -- rest.vim
    use({ 'taybart/rest.vim' })

    -- b64.nvim
    use({ 'taybart/b64.nvim' })

    -- required with tmux
    use({
      'christoomey/vim-tmux-navigator',
      setup = function()
        vim.g.tmux_navigator_no_mappings = 1
      end,
    })

    -- nice indicators for fF/tT
    use({ 'unblevable/quick-scope' })

    -- treesitter text objects
    use({
      'nvim-treesitter/nvim-treesitter-textobjects',
      config = function()
        require('plugins/treesitter').setup_textobjects()
      end,
    })

    -- git gutter
    use({
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup({
          current_line_blame = true,
          current_line_blame_opts = {
            delay = 0,
          },
        })
        require('utils/maps').mode_group('n', {
          { ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" },
          { '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" },
        }, { expr = true })
      end,
    })

    -- treesitter commentstring
    use({
      'JoosepAlviste/nvim-ts-context-commentstring',
      config = function()
        require('nvim-treesitter.configs').setup({
          context_commentstring = {
            enable = true,
          },
        })
      end,
    })
    -----------------------------
    --------- Looks -------------
    -----------------------------

    -- syntax highlighting with treesitter
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('plugins/treesitter').configure()
      end,
    })

    -- tabs
    use({
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('bufferline').setup({
          options = {
            diagnostics = 'nvim_lsp',
            separator_style = 'slant',
            max_name_length = 30,
            show_close_icon = false,
            show_buffer_close_icons = false,
            right_mouse_command = nil,
            middle_mouse_command = 'bdelete! %d',
          },
        })
      end,
    })

    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
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
    })

    -- show indents
    use({
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('indent_blankline').setup({
          filetype_exclude = { 'help', 'TelescopePrompt' },
        })
      end,
    })

    use({
      'norcalli/nvim-colorizer.lua',
      opt = true,
      config = function()
        require('colorizer').setup()
      end,
    })

    -- colorscheme
    use({ 'gruvbox-community/gruvbox' })

    -----------------------------
    --------- Extras ------------
    -----------------------------
    use({ 'folke/lua-dev.nvim' })

    use({ 'tweekmonster/startuptime.vim', cmd = { 'StartupTime' } })

    -- -- neorg
    -- use({
    -- 	'nvim-neorg/neorg',
    -- 	-- ft = 'norg',
    -- 	after = { 'nvim-treesitter' },
    -- 	config = function()
    -- 		require('plugins/norg').setup()
    -- 	end,
    -- 	requires = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    -- })

    -- cool treesitter debugger
    use({
      'nvim-treesitter/playground',
      cmd = 'TSPlaygroundToggle',
      config = function()
        require('plugins/treesitter').setup_playground()
      end,
    })
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})
