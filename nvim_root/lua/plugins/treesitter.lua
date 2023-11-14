return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    pcall(require('nvim-treesitter.install').update({ with_sync = true }))
  end,
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'astro',
        'bash',
        'c',
        'cpp',
        'dockerfile',
        'go',
        'gomod',
        'hcl',
        'javascript',
        'json',
        'json5',
        'lua',
        'make',
        'markdown',
        'python',
        'rust',
        'tsx',
        'typescript',
        'vimdoc',
        'vue',
        'yaml',
      },
      highlight = {
        enable = true,
      },
      context_commentstring = {
        enable = true,
      },
      textobjects = {
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['uc'] = '@comment.outer',
          },
        },
      },
      playground = {
        enable = true,
        disable = {},
        -- Debounced for highlighting nodes in the playground from source
        updatetime = 25,
        -- Whether the query persists across vim sessions
        persist_queries = false,
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
    })
  end,
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
  },
}
