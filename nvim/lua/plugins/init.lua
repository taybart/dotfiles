return {
  {
    -- required with tmux
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      require('utils/maps').group({ noremap = true, silent = true }, {
        {
          'n',
          { '<c-f><left>', ':TmuxNavigateLeft<cr>' },
          { '<c-f><down>', ':TmuxNavigateDown<cr>' },
          { '<c-f><up>', ':TmuxNavigateUp<cr>' },
          { '<c-f><right>', ':TmuxNavigateRight<cr>' },
        },
        {
          't',
          { '<c-f><left>', '<c-\\><c-n>:TmuxNavigateLeft<cr>' },
          { '<c-f><down>', '<c-\\><c-n>:TmuxNavigateDown<cr>' },
          { '<c-f><up>', '<c-\\><c-n>:TmuxNavigateUp<cr>' },
          { '<c-f><right>', '<c-\\><c-n>:TmuxNavigateRight<cr>' },
        },
      })
    end,
  },
  { 'vim-scripts/vis' },

  -- { 'zbirenbaum/copilot.lua', config = true },

  { 'OXY2DEV/markview.nvim', config = true },

  --[==================[
  -- Probation
  --]==================]

  {
    'stevearc/conform.nvim',
    opts = {},
  },
  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<cr>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<cr>', { buffer = bufnr })
        end,
      })
      vim.keymap.set('n', '<F8>', '<cmd>AerialToggle<cr>', { noremap = true })
    end,
  },

  -- {
  --   'ggml-org/llama.vim',
  --   init = function()
  --     vim.g.llama_config = { show_info = 0 }
  --     -- vim.api.nvim_set_hl(0, 'llama_hl_hint', { fg = '#928374' })
  --     -- -- vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })

  --     vim.cmd([[highlight llama_hl_hint guifg=#ff772f ctermfg=202]])
  --     -- vim.cmd([[hi link llama_hl_hint Comment ]])
  --   end,
  --   config = function()
  --     -- vim.cmd([[
  --     --   silent! iunmap <buffer> <Tab>
  --     --   silent! iunmap <buffer> <S-Tab>
  --     --   inoremap <buffer> <c-<space>>   <C-O>:call llama#fim_accept('full')<CR>
  --     --   inoremap <buffer> <c-e>              <C-O>:call llama#fim_accept('line')<CR>
  --     -- ]])
  --   end,
  -- },

  -- {
  --   'huggingface/llm.nvim',
  --   enabled = false,
  --   config = function()
  --     require('llm').setup({
  --       backend = 'ollama',
  --       url = 'http://unicron:11435',
  --       -- url = 'http://localhost:11434',
  --       -- debounce_ms = 1000,
  --       debounce_ms = 500,

  --       -- model = 'codellama:7b',
  --       model = 'qwen2.5-coder:3b',
  --       tokens_to_clear = { '<|endoftext|>' },
  --       fim = {
  --         enabled = true,
  --         prefix = '<|fim_prefix|>',
  --         middle = '<|fim_middle|>',
  --         suffix = '<|fim_suffix|>',
  --       },
  --       request_body = {
  --         options = {
  --           temperature = 0.2,
  --           top_p = 0.95,
  --         },
  --       },
  --       accept_keymap = '<c-e>',
  --       dismiss_keymap = '<c-tab>',
  --       -- context_window = 40,
  --       -- context_window = 1024,
  --       context_window = 4096,
  --       -- context_window = 8192,

  --       -- starcoder
  --       -- model = 'starcoder2:3b',
  --       -- tokens_to_clear = { '<|endoftext|>' },
  --       -- fim = {
  --       --   enabled = true,
  --       --   prefix = '<fim_prefix>',
  --       --   middle = '<fim_middle>',
  --       --   suffix = '<fim_suffix>',
  --       -- },
  --       -- model = 'bigcode/starcoder',
  --       -- tokenizer = {
  --       --   repository = 'bigcode/starcoder',
  --       -- },

  --       lsp = {
  --         bin_path = vim.api.nvim_call_function('stdpath', { 'data' }) .. '/mason/bin/llm-ls',
  --         cmd_env = { LLM_LOG_LEVEL = 'DEBUG' },
  --       },
  --     })
  --     vim.keymap.set('i', '<C-l>', function()
  --       require('llm.completion').lsp_suggest()
  --     end, { noremap = true, silent = true })
  --   end,
  -- },

  {
    'mikavilpas/yazi.nvim',
    dependencies = { 'folke/snacks.nvim', lazy = true },
    event = 'VeryLazy',
    keys = {
      {
        '<leader>f',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },

  -- {
  --   'olimorris/codecompanion.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = 'copilot',
  --       },
  --       inline = {
  --         adapter = 'copilot',
  --       },
  --     },
  --   },
  -- },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local h = require('harpoon')
      h:setup()

      -- vim.keymap.set('n', '<c-e>', function()
      --   h.ui:toggle_quick_menu(h:list())
      -- end)
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table({ results = file_paths }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      require('utils/maps').mode_group('n', {
        {
          '<leader>a',
          function()
            h:list():add()
          end,
        },
        {
          '<C-e>',
          function()
            toggle_telescope(h:list())
          end,
        },
      }, {})
    end,
  },
}
