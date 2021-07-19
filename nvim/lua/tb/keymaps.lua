------------------------------
-------- Keybindings ---------
------------------------------

-- helpful things
local u = require('tb/utils/maps')

vim.g.mapleader = " " -- space as leader

-- Easy escape from insert
u.imap('jk', '<Esc>')
u.imap('jK', '<Esc>')
u.imap('JK', '<Esc>')

-- Quickly open/reload vim
u.nnoremap('<leader>ev', ':Files ~/.dotfiles/nvim<cr>')
u.nnoremap('<leader>sv', ':lua require("tb/utils").reload_vim()<cr>')

-- Idiot proofing
u.cmap('W', 'w')
u.cmap('Q', 'q')

-------------------
---- MOVEMENT -----
-------------------

-- Allow for homerow up and down in command mode
u.cnoremap('<c-j>', '<down>')
u.cnoremap('<c-k>', '<up>')

-- Allow for innerline navagation
u.nnoremap('j', 'gj')
u.nnoremap('k', 'gk')

-- Faster down and up
u.nnoremap('<c-j>', '15gj')
u.vnoremap('<c-j>', '15gj')
u.nnoremap('<c-k>', '15gk')
u.vnoremap('<c-k>', '15gk')
-- End and beg of line easier
u.nnoremap('H', '^')
u.nnoremap('L', '$')

-- Buffer control
u.nnoremap('<leader>l', ':bnext<cr>')
u.nnoremap('<leader>n', ':bnext<cr>')
u.nnoremap('<leader>h', ':bprevious<cr>')
u.nnoremap('<leader>d', ':bp <BAR> bd #<cr>')

-- escape in terminal
u.tnoremap('<Esc>', '<c-\\><c-n>')

-------------------
----- FORMAT ------
-------------------

-- These create newlines like o and O but stay in normal mode
u.nnoremap('zj', 'o<Esc>k', {silent=true})
u.nnoremap('zk', 'O<Esc>j', {silent=true})


-- Move lines in visual mode
u.vnoremap('J', ':m \'>+1<cr>gv=gv')
u.vnoremap('K', ':m \'<-2<cr>gv=gv')

-- Fix all indents
-- u.nnoremap('<leader>t<cr>', 'mzgg=G`z:w<cr>')

-- Emacs indent
u.nnoremap('<Tab>', '==')
u.vnoremap('<Tab>', '=')

-- Get rid of the fucking stupid OCD whitespace
u.nnoremap('<leader>w<cr>', ':%s/\\s\\+$//<cr>:w<cr>:noh<cr>')
--
-------------------
----- PLUGINS -----
-------------------

-- drawer
u.nnoremap('<Leader>f', ':NvimTreeToggle<cr>', {silent = true})

-- tmux integration
u.nnoremap('<c-m>', ':TmuxNavigateDown<cr>', { silent = true })
u.nnoremap('<c-u>', ':TmuxNavigateUp<cr>', { silent = true })
u.nnoremap('<c-l>', ':TmuxNavigateRight<cr>', { silent = true })
u.nnoremap('<c-h>', ':TmuxNavigateLeft<cr>', { silent = true })
u.nnoremap('<c-;>', ':TmuxNavigatePrevious<cr>', { silent = true })


-- tagbar
u.nnoremap('<F8>', ':TagbarToggle<cr>')

-- base64
u.vnoremap('<leader>bd', ':<c-u>lua require("b64").decode()<cr>', {silent = true})
u.vnoremap('<leader>be', ':<c-u>lua require("b64").encode()<cr>', {silent = true})

----- Searching

-- -- Live grep
-- u.nnoremap('<c-s>', ':Rg<cr>')
-- -- Search under cursor
-- u.nnoremap('<c-a>', ':Rg <c-r><c-w><cr>')
-- -- Search using selected text
-- u.vnoremap('<c-a>', 'y0:Rg <c-r>0<cr>')
-- -- fzf files finder
-- -- u.nnoremap('<C-p>', ':Files<CR>')

-- Live grep
u.nnoremap('<c-s>', ':lua require("telescope.builtin").live_grep()<cr>')
-- Search under cursor
u.nnoremap('<c-a>', ':Rg <c-r><c-w><cr>')
-- Search using selected text
u.vnoremap('<c-a>', 'y0:Rg <c-r>0<cr>')

-- Telescope finder
u.nnoremap('<C-p>', ':lua require("telescope.builtin").find_files()<cr>')

vim.api.nvim_command[[
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%') : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'), <bang>0)
]]

-- NOTE: this is the todo mentioned below
-- function go_add_jtags()
--   vi{:s/\(\w\+\)\s\+\(\[\=\]\=\w\+\)/\1 \2 `json:"\1"`/<cr>vi{:s/json:"\(.*\)"/\="json:\"" . g:Abolish.snakecase(submatch(1)) . ",omitempty\""/g<cr>:noh<cr>
-- end

-- -- add json tags to go struct, single level only atm
-- -- TODO redo in lua
-- u.nnoremap('<leader>gtj', ':lua require("keymaps").go_add_jtags()<cr>')
 -- vi{:s/\(\w\+\)\s\+\(\[\=\]\=\w\+\)/\1 \2 `json:"\1"`/<cr>vi{:s/json:"\(.*\)"/\="json:\"" . g:Abolish.snakecase(submatch(1)) . ",omitempty\""/g<cr>:noh<cr>
-- nnoremap <leader>jb V:s/,/,\r/g<cr>:noh<cr>
