----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

vim.o.background = "dark" -- or "light" for light mode
vim.cmd 'colorscheme gruvbox'
-- nice markdown highlighting
vim.g.markdown_fenced_languages = {
  'html',
  'python',
  'sh',
  'bash=sh',
  'shell=sh',
  'go',
  'javascript',
  'js=javascript',
  'typescript',
  'ts=typescript',
  'py=python',
}

---- Tree Sitter
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
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
    lint_events = {"BufWrite", "CursorHold"},
  },
}

-- inline colors
require('colorizer').setup()

-- lighter status line
vim.g.airline_theme='papercolor'


function M.toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    return
  end

  local re = vim.regex('tagbar\\|NvimTree\\|vista\\|packer')
  if re:match_str(vim.bo.ft) then
    vim.opt.number=false
    return
  end

  vim.opt.number=true
  vim.opt.relativenumber=relon
end

return M
