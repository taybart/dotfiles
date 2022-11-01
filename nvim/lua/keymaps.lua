------------------------------
-------- Keybindings ---------
------------------------------

-- helpful things
local map = require('utils/maps')

vim.g.mapleader = ' ' -- space as leader

-- Easy escape from insert
map.mode_group('i', {
  { 'jk', '<Esc>' },
  { 'jK', '<Esc>' },
  { 'JK', '<Esc>' },
})

-- Quickly open/reload nvim
map.mode_group('n', {
  { '<leader>ev', ':lua require("plugins/telescope").edit_config()<cr>' },
  { '<leader>sv', ':lua require("utils").reload_vim()<cr>' },
})

-- help vertical
map.mode_group('c', {
  { 'vh', 'vert bo h ' },
})

-- Idiot proofing
vim.cmd('command! W w')
vim.cmd('command! Q q')
vim.cmd('command! WQ wq')
vim.cmd('command! Wq wq')

-------------------
---- MOVEMENT -----
-------------------

map.group({ noremap = true }, {
  {
    'c',
    -- Allow for homerow up and down in command mode
    { '<c-j>', '<down>' },
    { '<c-k>', '<up>' },
  },
  {
    'n',
    -- Allow for innerline navagation
    { 'j', 'gj' },
    { 'k', 'gk' },
    -- End and beg of line easier
    { 'H', '^' },
    { 'L', '$' },
  },

  { 'n', { '<c-d>', '15gj' }, { '<c-u>', '15gk' } },
  { 'v', { '<c-d>', '15gj' }, { '<c-u>', '15gk' } },
})

-- u.nnoremap('<leader>l', ':bnext<cr>')
-- u.nnoremap('<leader>n', ':bnext<cr>')
-- u.nnoremap('<leader>h', ':bprevious<cr>')
-- u.nnoremap('<leader>d', ':bp <BAR> bd #<cr>')

-- Buffer control
map.mode_group('n', {
  { '<leader>l', ':BufferLineCycleNext<cr>' },
  { '<leader>h', ':BufferLineCyclePrev<cr>' },
  { '<leader>L', ':BufferLineMoveNext<cr>' },
  { '<leader>H', ':BufferLineMovePrev<cr>' },
  { '<leader>d', ':bp <BAR> bd #<cr>' },
}, { noremap = true })

-- escape in terminal
map.tnoremap('<Esc>', '<c-\\><c-n>')

-------------------
----- FORMAT ------
-------------------

-- u.nnoremap('ff', ':Format<cr>:w<cr>')

-- These create newlines like o and O but stay in normal mode
map.mode_group('n', {
  { 'zj', 'o<Esc>k' },
  { 'zk', 'O<Esc>j' },
}, { silent = true })

-- Move lines in visual mode
map.mode_group('v', {
  { 'J', ":m '>+1<cr>gv=gv" },
  { 'K', ":m '<-2<cr>gv=gv" },
}, { noremap = true })

-- better undo breakpoints
map.mode_group('i', {
  { ',', ',<c-g>u' },
  { '.', '.<c-g>u' },
  { '!', '!<c-g>u' },
  { '?', '?<c-g>u' },
}, { noremap = true })

-- Fix all indents
map.nnoremap('<leader>t<cr>', 'mzgg=G`z:w<cr>')

-- Emacs indent
-- map.nnoremap('<Tab>', '==')
-- map.vnoremap('<Tab>', '=')
-- -- mapping tab maps c-i?? #20126
-- map.nnoremap('<c-i>', '<c-i>')

-- Get rid of the fucking stupid OCD whitespace
-- Get rid of the fucking stupid <200b>
map.nnoremap('<leader>w<cr>', ':silent! %s/\\s\\+$//<cr>:silent! %s/\\%u200b//g<cr>:w<cr>:noh<cr>')

-- highlight pasted text
map.nnoremap('gp', '`[v`]')

--
-------------------
----- PLUGINS -----
-------------------

-- drawer
map.mode_group('n', {
  -- { '<Leader>f', ':NeoTreeShowToggle<cr>' },
  -- { '<Leader>f', ':NeoTreeRevealToggle<cr>' },
}, { noremap = true, silent = true })

-- tmux integration
map.mode_group('n', {
  { '<C-f><Left>', ':TmuxNavigateLeft<cr>' },
  { '<C-f><Down>', ':TmuxNavigateDown<cr>' },
  { '<C-f><Up>', ':TmuxNavigateUp<cr>' },
  { '<C-f><Right>', ':TmuxNavigateRight<cr>' },
  -- { '<;>', ':TmuxNavigatePrevious<cr>' },
}, { noremap = true, silent = true })

-- base64
map.mode_group('v', {
  { '<leader>bd', ':lua require("b64").decode()<cr>' },
  { '<leader>be', ':lua require("b64").encode()<cr>' },
}, { noremap = true, silent = true })

-- tagbar
map.nnoremap('<F8>', ':TagbarToggle<cr>')

---------------
----- Searching
---------------
map.group({ noremap = true }, {
  {
    'n',
    -- Live grep
    { '<c-s>', ':lua require("telescope.builtin").live_grep()<cr>' },
    -- Search under cursor
    { 'g<c-s>', ':lua require("plugins/telescope").search_cword()<cr>' },
    -- Find files
    { '<c-p>', ':lua require("telescope.builtin").find_files()<cr>' },
    -- Find open buffers
    { '<c-b>', ':lua require("telescope.builtin").buffers()<cr>' },
    -- Find code actions
    -- { '<c-c>', ':lua require("telescope.builtin").lsp_code_actions()<cr>' },
  },
  {
    'v',
    -- Search using selected text
    { '<c-s>', ':lua require("plugins/telescope").search_selection()<cr>' },
  },
})
