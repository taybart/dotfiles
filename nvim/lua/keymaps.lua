------------------------------
-------- Keybindings ---------
------------------------------

local map = require('tools/maps')

---@diagnostic disable-next-line: inject-field
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

map.mode_group('n', {
  { '<F9>',  'cprev' },
  { '<F10>', 'cnext' },
})

-- see language specific definitions of Run in languages/{language}
map.nnoremap('<leader>r', ':Run<cr>')

-- turn on very magic everytime
-- map.cnoremap('%s/', '%s/\\v')

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
  { '<leader>l', ':bn<cr>' },
  { '<leader>h', ':bp<cr>' },
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

map.nnoremap('<C-w>T', ':tab split<CR>', { silent = true })

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
-- map.mode_group('v', {
--   { 'J', ":m '>+1<cr>gv=gv" },
--   { 'K', ":m '<-2<cr>gv=gv" },
-- }, { noremap = true })

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
-- -- mapping tab maps c-i?? https://github.com/neovim/neovim/issues/20126
-- map.nnoremap('<c-i>', '<c-i>')

map.vmap('<Tab>', '>gv')
map.vmap('<S-Tab>', '<gv')

map.vnoremap('<leader>q', ':s/\\(\\S.*\\)/"\\1",<cr>:noh<cr>')

-- Get rid of the fucking stupid OCD whitespace
-- Get rid of the fucking stupid <200b>
map.nnoremap('<leader>w<cr>', ':silent! %s/\\s\\+$//<cr>:silent! %s/\\%u200b//g<cr>:w<cr>:noh<cr>')

-- highlight pasted text
map.nnoremap('gp', '`[v`]')

-------------------
---- SNIPPETS -----
-------------------
map.group({ silent = true }, {
  {
    { 'i', 's' },
    '<c-j>',
    function()
      if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        local seq = vim.api.nvim_replace_termcodes('<c-j>', true, true, true)
        vim.api.nvim_feedkeys(seq, 'n', true)
      end
    end,
  },
  {
    { 'i', 's' },
    '<c-k>',
    function()
      if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
    end,
  },
})
