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

-- paste without losing clipboard buffer
vim.keymap.set('x', '<leader>p', '"_dP')

-- help vertical
map.mode_group('c', {
  { 'vh', 'vert bo h ' },
})

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

map.mode_group('n', {
  { '[q', ':cprevious<cr>' },
  { ']q', ':cnext<cr>' },
  { '[Q', ':cfirst<cr>' },
  { ']Q', ':clast<cr>' },
})

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
map.vmap('<Tab>', '>gv')
map.vmap('<S-Tab>', '<gv')

-- Get rid of the fucking stupid OCD whitespace
-- Get rid of the fucking stupid <200b>
map.nnoremap('<leader>w<cr>', ':silent! %s/\\s\\+$//<cr>:silent! %s/\\%u200b//g<cr>:w<cr>:noh<cr>')

-- highlight pasted text
map.nnoremap('gp', '`[v`]')
