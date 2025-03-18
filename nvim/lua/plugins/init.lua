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

  -- { 'zbirenbaum/copilot.lua', config = true },

  --[==================[
  --===  Probation  ===
  --]==================]

  {
    'huggingface/llm.nvim',
    lazy = true,
    enabled = function()
      local llm_up = vim.fn
        .system('curl -o /dev/null -s -w "%{http_code}\n" http://localhost:8012/health')
        :gsub('\n', '') == '200'
      if not llm_up then
        print('llm disabled')
      end
      return llm_up
    end,
    config = function()
      require('llm').setup({
        backend = 'openai',
        url = 'http://localhost:8012',
        -- model = 'qwen2.5-coder:3b',
        debounce_ms = 750,
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
