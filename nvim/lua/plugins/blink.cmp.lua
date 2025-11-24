return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    snippets = { preset = 'luasnip' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = {
            { 'label',     'label_description', gap = 1 },
            { 'kind_icon', 'kind',              'source_id' },
          },
        },
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        sql = { 'dadbod' },
      },
      providers = {
        dadbod = { module = 'vim_dadbod_completion.blink' },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
