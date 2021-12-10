------------------------------
-------- Keybindings ---------
------------------------------

-- helpful things
local u = require('tb/utils/maps')

vim.g.mapleader = " " -- space as leader

-- Easy escape from insert
u.mode_map_group('i', {
  {'jk', '<Esc>'},
  {'jK', '<Esc>'},
  {'JK', '<Esc>'},
})

-- Quickly open/reload nvim
u.mode_map_group('n', {
  {'<leader>ev', ':lua require("tb/plugins/telescope").edit_config()<cr>'},
  {'<leader>sv', ':lua require("tb/utils").reload_vim()<cr>'},
})

-- help vertical
u.mode_map_group('c', {
  {'vh', 'vert bo h '},
})

-- Idiot proofing
vim.cmd('command! W w')
vim.cmd('command! Q q')
vim.cmd('command! WQ wq')
vim.cmd('command! Wq wq')

-------------------
---- MOVEMENT -----
-------------------

u.map_group({noremap=true}, {
  {'c',
    -- Allow for homerow up and down in command mode
    {'<c-j>', '<down>'},
    {'<c-k>', '<up>'},
  },
  {'n',
    -- Allow for innerline navagation
    {'j', 'gj'},
    {'k', 'gk'},
    -- End and beg of line easier
    {'H', '^'},
    {'L', '$'},
  },
  -- Faster down and up
  -- {'n',
  --   {'<c-j>', '15gj'},
  --   {'<c-k>', '15gk'}
  -- },
  -- { 'v',
  --   {'<c-j>', '15gj'},
  --   {'<c-k>', '15gk'},
  -- },
})


-- u.nnoremap('<leader>l', ':bnext<cr>')
-- u.nnoremap('<leader>n', ':bnext<cr>')
-- u.nnoremap('<leader>h', ':bprevious<cr>')
-- u.nnoremap('<leader>d', ':bp <BAR> bd #<cr>')

-- Buffer control
u.mode_map_group('n', {
  {'<leader>l', ':BufferLineCycleNext<cr>'},
  {'<leader>h', ':BufferLineCyclePrev<cr>'},
  {'<leader>L', ':BufferLineMoveNext<cr>'},
  {'<leader>H', ':BufferLineMovePrev<cr>'},
  {'<leader>d', ':bp <BAR> bd #<cr>'},
}, {noremap = true})

-- escape in terminal
u.tnoremap('<Esc>', '<c-\\><c-n>')

-------------------
----- FORMAT ------
-------------------

u.nnoremap('ff', ':Format<cr>:w<cr>')

-- These create newlines like o and O but stay in normal mode
u.mode_map_group('n',{
  {'zj', 'o<Esc>k'},
  {'zk', 'O<Esc>j'},
}, {silent=true})


-- Move lines in visual mode
u.mode_map_group('v', {
  {'J', ':m \'>+1<cr>gv=gv'},
  {'K', ':m \'<-2<cr>gv=gv'},
}, {noremap = true})

-- better undo breakpoints
u.mode_map_group('i', {
  {',', ',<c-g>u'},
  {'.', '.<c-g>u'},
  {'!', '!<c-g>u'},
  {'?', '?<c-g>u'},
}, {noremap = true})

-- make yank work like the others
-- u.nnoremap('Y', 'y$') -- now default!

-- Fix all indents
u.nnoremap('<leader>t<cr>', 'mzgg=G`z:w<cr>')

-- Emacs indent
u.nnoremap('<Tab>', '==')
u.vnoremap('<Tab>', '=')

-- Get rid of the fucking stupid OCD whitespace
-- Get rid of the fucking stupid <200b>
u.nnoremap('<leader>w<cr>', ':%s/\\s\\+$//<cr>:w<cr>:noh<cr>:%s/\\%u200b//g<cr>:noh<cr>')

-- highlight pasted text
u.nnoremap('gp', '`[v`]')

--
-------------------
----- PLUGINS -----
-------------------

-- drawer
u.mode_map_group('n', {
  {'<Leader>f', ':NvimTreeToggle<cr>'},
  {'<Leader>F', ':NvimTreeFindFile<cr>'}
}, {noremap = true, silent = true})

-- tmux integration
u.mode_map_group('n', {
  {'<c-m>', ':TmuxNavigateDown<cr>'},
  {'<c-k>', ':TmuxNavigateUp<cr>' },
  {'<c-l>', ':TmuxNavigateRight<cr>'},
  {'<c-h>', ':TmuxNavigateLeft<cr>'},
  {'<c-;>', ':TmuxNavigatePrevious<cr>'},
}, {noremap = true, silent = true})

-- base64
u.mode_map_group('v', {
  {'<leader>bd', ':lua require("b64").decode()<cr>'},
  {'<leader>be', ':lua require("b64").encode()<cr>'},
}, {noremap=true, silent=true})

-- tagbar
u.nnoremap('<F8>', ':TagbarToggle<cr>')

---------------
----- Searching
---------------
u.map_group({noremap = true}, {
  { 'n',
    -- Live grep
    {'<c-s>', ':lua require("telescope.builtin").live_grep()<cr>'},
    -- Search under cursor
    {'<c-a>', ':lua require("tb/plugins/telescope").search_cword()<cr>'},
    -- Find files
    {'<c-p>', ':lua require("telescope.builtin").find_files()<cr>'},
    -- Find open buffers
    {'<c-b>', ':lua require("telescope.builtin").buffers()<cr>'},
    -- Find code actions
    {'<c-c>', ':lua require("telescope.builtin").lsp_code_actions()<cr>'},
  },
  {'v',
    -- Search using selected text
    {'<c-a>', ':lua require("tb/plugins/telescope").search_selection()<cr>'},
  },
})
