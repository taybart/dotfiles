return {
  { 'nvim-lua/plenary.nvim', priority = 1000 },
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

  --[==================[
  --===  Probation  ===
  --]==================]

  { 'stevearc/conform.nvim', opts = {} },

  {
    'huggingface/llm.nvim',
    enabled = function()
      local enabled = false
      local res = require('plenary.curl').get({
        url = 'http://localhost:8012/health',
        timeout = 200,
        on_error = function()
          print('llm disabled')
        end,
      })
      return res.status == 200
    end,
    config = function()
      require('llm').setup({
        backend = 'openai',
        url = 'http://localhost:8012',
        -- model = 'qwen2.5-coder:3b',
        debounce_ms = 250,
        accept_keymap = '<c-e>',
        dismiss_keymap = '<c-tab>',
        -- context_window = 8192, -- already set in server script
        fim = {
          enabled = true,
          prefix = '<|fim_prefix|>',
          middle = '<|fim_middle|>',
          suffix = '<|fim_suffix|>',
        },
        request_body = {
          options = {
            temperature = 0.2,
            top_p = 0.95,
          },
        },
        lsp = {
          bin_path = vim.api.nvim_call_function('stdpath', { 'data' }) .. '/mason/bin/llm-ls',
        },
      })
      vim.keymap.set('i', '<C-l>', function()
        require('llm.completion').lsp_suggest()
      end, { noremap = true, silent = true })
    end,
  },
}
