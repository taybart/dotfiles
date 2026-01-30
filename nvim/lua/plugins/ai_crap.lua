return {
  {
    'ggml-org/llama.vim',
    init = function()
      vim.g.llama_config = {
        show_info = 0,
        keymap_fim_trigger = '<c-t>',
        keymap_fim_accept_full = '<c-e>',
        keymap_fim_accept_line = '<c-l>',
        keymap_fim_accept_word = '<c-space>',
        keymap_inst_trigger = '',
        keymap_inst_rerun = '',
        keymap_inst_continue = '',
        keymap_inst_accept = '',
        keymap_inst_cancel = '',
        keymap_debug_toggle = '',
      }
    end,
  },
}
