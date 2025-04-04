return {
  {
    'huggingface/llm.nvim',
    enabled = function()
      local llm_up = vim.fn
        .system('curl -o /dev/null -s -w "%{http_code}\n" http://localhost:8012/health')
        :gsub('\n', '') == '200'
      if not llm_up then
        vim.notify('llm disabled', vim.log.levels.WARN)
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
