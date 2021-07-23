----------------------------------
------------- Looks --------------
----------------------------------

local M = {}

vim.opt.background = 'dark' -- or "light" for light mode
vim.cmd('colorscheme gruvbox')
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
  context_commentstring = {
    enable = true
  },
}

-- inline colors
require('colorizer').setup()

-- lighter status line
vim.g.airline_theme='papercolor'

require('tb/utils').create_augroups({
  looks = {
    { 'BufEnter,FocusGained,InsertLeave', '*', 'lua require("tb/looks").toggle_num(true)' },
    { 'BufLeave,FocusLost,InsertEnter', '*', 'lua require("tb/looks").toggle_num(false)' },
  },
  whitespace = {
    { 'BufWinEnter', '<buffer>', 'match Error /\\s\\+$/' },
    { 'InsertEnter', '<buffer>', 'match Error /\\s\\+\\%#\\@<!$/' },
    { 'InsertLeave', '<buffer>', 'match Error /\\s\\+$/' },
    { 'BufWinLeave', '<buffer>', 'call clearmatches()' },
  },
  goyo = {
    { 'User GoyoEnter nested lua require("tb/autocmds").goyo_enter()' },
    { 'User GoyoLeave nested lua require("tb/autocmds").goyo_leave()' },
  },
})

function M.toggle_num(relon)
  if vim.g.goyo_mode == 1 then
    vim.opt.number=false
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

function M.goyo_enter()
  vim.b.quitting = 0
  vim.b.quitting_bang = 0
  vim.cmd('autocmd QuitPre <buffer> let b:quitting = 1')
  vim.cmd('cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!')

  vim.opt.relativenumber=false
  vim.opt.number=false
  vim.opt.showmode=false
  vim.opt.showcmd=false
  vim.opt.scrolloff=999

  vim.g.goyo_mode = 1
end

function M.goyo_leave()
  vim.opt.showmode=true
  vim.opt.showcmd=true
  vim.opt.scrolloff=5

  vim.g.goyo_mode = 0

  -- Quit Vim if this is the only remaining buffer
  if vim.b.quitting then
    local api = vim.api
    local windows = api.nvim_list_wins()
    local curtab = api.nvim_get_current_tabpage()
    local wins_in_tabpage = vim.tbl_filter(function(w)
      return api.nvim_win_get_tabpage(w) == curtab
    end, windows)
    if #windows == 1 then

    if vim.b.quitting_bang then
      api.nvim_command(':silent qa!')
    else
      api.nvim_command(':silent qa')
    end
    elseif #wins_in_tabpage == 1 then
      api.nvim_command(':tabclose')
    end
  end
end

return M
