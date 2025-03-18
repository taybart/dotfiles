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

  -- {
  --   'folke/noice.nvim',
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     'MunifTanjim/nui.nvim',
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     'rcarriga/nvim-notify',
  --   },
  --   opts = {
  --     lsp = {
  --       -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --         ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
  --       },
  --     },
  --     -- you can enable a preset for easier configuration
  --     presets = {
  --       bottom_search = true, -- use a classic bottom cmdline for search
  --       command_palette = true, -- position the cmdline and popupmenu together
  --       long_message_to_split = true, -- long messages will be sent to a split
  --       inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --       lsp_doc_border = false, -- add a border to hover docs and signature help
  --     },
  --   },
  -- },

  {
    'stevearc/conform.nvim',
    opts = {
      -- formatters_by_ft = {
      --     sql = { 'sqlfluff' },
      -- },
      --   formatters = {
      --     sqlfluff = {
      --       args = { 'fix', '--dialect=ansi', '-' },
      --       require_cwd = false,
      --     },
    },
  },

  {
    'huggingface/llm.nvim',
    enabled = function()
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
