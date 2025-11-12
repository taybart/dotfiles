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
  },
}
