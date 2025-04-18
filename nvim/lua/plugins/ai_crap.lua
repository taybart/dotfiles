-- local llm_endpoint = 'localhost:8012'
local llm_endpoint = 'http://localhost:11234'

return {
  {
    'ggml-org/llama.vim',
    init = function()
      ---@diagnostic disable-next-line: inject-field
      vim.g.llama_config = {
        show_info = 0,
        keymap_trigger = '<c-t>',
        keymap_accept_full = '<c-e>',
        keymap_accept_line = '<c-l>',
        keymap_accept_word = '<c-space>',
        -- endpont = llm_endpoint .. '/infill',
      }
    end,
    config = function()
      -- vim.api.nvim_set_hl(0, 'llama_hl_hint', { link = 'Comment' })
      -- vim.api.nvim_set_hl(0, 'llama_hl_hint', { fg = '#918273' })
      -- vim.api.nvim_set_hl(0, 'llama_hl_hint', { fg = '#70665A' })
    end,
  },
  -- {
  --   'huggingface/llm.nvim',
  --   enabled = function()
  --     local llm_up = vim.fn
  --       .system('curl -o /dev/null -s -w "%{http_code}\n" ' .. llm_endpoint .. '/neovim')
  --       :gsub('\n', '') == '200'
  --     if not llm_up then
  --       vim.notify('llm disabled', vim.log.levels.WARN)
  --     end
  --     return llm_up
  --   end,
  --   config = function()
  --     require('llm').setup({
  --       backend = 'openai',
  --       url = llm_endpoint,
  --       -- model = 'qwen2.5-coder:3b',
  --       debounce_ms = 750,
  --       accept_keymap = '<c-e>',
  --       dismiss_keymap = '<c-tab>',
  --       -- context_window = 8192, -- already set in server script
  --       fim = {
  --         enabled = true,
  --         prefix = '<|fim_prefix|>',
  --         middle = '<|fim_middle|>',
  --         suffix = '<|fim_suffix|>',
  --         -- prefix = '<|fim_begin|>',
  --         -- middle = '<|fim_hole|>',
  --         -- suffix = '<|fim_end|>',
  --       },
  --       request_body = {
  --         options = {
  --           temperature = 0.2,
  --           top_p = 0.95,
  --         },
  --       },
  --       lsp = {
  --         bin_path = vim.api.nvim_call_function('stdpath', { 'data' }) .. '/mason/bin/llm-ls',
  --       },
  --     })
  --     vim.keymap.set('i', '<C-l>', function()
  --       require('llm.completion').lsp_suggest()
  --     end, { noremap = true, silent = true })
  --   end,
  -- },
}
