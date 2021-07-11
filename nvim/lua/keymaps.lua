------------------------------
-------- Keybindings ---------
------------------------------

-- helpful things
local u = require('util')

vim.g.mapleader = " " -- space as leader


u.nnoremap('<C-p>', ':Files<CR>')

-- Easy escape from insert
u.imap('jk', '<Esc>')
u.imap('jK', '<Esc>')
u.imap('JK', '<Esc>')

-- Quickly open/reload vim
u.nnoremap('<leader>ev', ':e $MYVIMRC<cr>')
u.nnoremap('<leader>sv', ':source $MYVIMRC<cr>') -- TODO

-- command! -nargs=1 Ev e ~/.vim/<args>.vim

-- Idiot proofing
u.cmap('W', 'w')
u.cmap('Q', 'q')

-- fern
-- noremap <silent> <Leader>f :NvimTreeToggle<cr>

-------------------
---- MOVEMENT -----
-------------------

-- Allow for homerow up and down in command mode
-- cnoremap <c-j> <down>
-- cnoremap <c-k> <up>
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

-------------------
----- FORMAT ------
-------------------

-- These create newlines like o and O but stay in normal mode
u.nnoremap('zj', 'o<Esc>k', {silent=true})
u.nnoremap('zk', 'O<Esc>j', {silent=true})

-- Fix all indents
u.nnoremap('<leader>t<cr>', 'mzgg=G`z:w<cr>')
-- Get rid of the fucking stupid OCD whitespace
u.nnoremap('<leader>w<cr>', ':%s/\\s\\+$//<cr>:w<cr>')
-- Emacs indent
u.nnoremap('<Tab>', '==')
u.vnoremap('<Tab>', '=')
--
-------------------
----- PLUGINS -----
-------------------

-- tmux integration
u.nnoremap('<c-m>', ':TmuxNavigateDown<cr>', { silent = true })
u.nnoremap('<c-u>', ':TmuxNavigateUp<cr>', { silent = true })
u.nnoremap('<c-l>', ':TmuxNavigateRight<cr>', { silent = true })
u.nnoremap('<c-h>', ':TmuxNavigateLeft<cr>', { silent = true })
u.nnoremap('<c-;>', ':TmuxNavigatePrevious<cr>', { silent = true })

-- escape in terminal
-- tnoremap <Esc> <c-\><c-n>

-- coc.vim
u.nnoremap('<leader>cr', ':CocRestart<cr>', {silent = true})

u.nmap('[d', '<Plug>(coc-diagnostic-prev)', {silent = true})
u.nmap(']d', '<Plug>(coc-diagnostic-next)', {silent = true})
u.nmap('gd', '<Plug>(coc-definition)', {silent = true})
u.nmap('gy', '<Plug>(coc-type-definition)', {silent = true})
u.nmap('gi', '<Plug>(coc-implementation)', {silent = true})
u.nmap('gr', '<Plug>(coc-references)', {silent = true})

-- Add `:Format` command to format current buffer.
-- command! -nargs=0 Format :call CocAction('format')

-- inoremap <silent><expr> <TAB>
--       \ pumvisible() ? "\<c-n>" :
--       \ <SID>check_back_space() ? "\<TAB>" :
--       \ coc#refresh()
-- function! s:check_back_space() abort
--   let col = col('.') - 1
--   return !col || getline('.')[col - 1]  =~# '\s'
-- endfunction

-- inoremap <expr><S-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"
-- inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
-- au BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

-- Use K to show documentation in preview window
-- nnoremap <silent> K :call <SID>show_documentation()<cr>
-- function! s:show_documentation()
--   if (index(['vim','help'], &filetype) >= 0)
--     execute 'h '.expand('<cword>')
--   else
--     call CocAction('doHover')
--   endif
-- endfunction

-- Tagbar
u.nnoremap('<F8>', ':TagbarToggle<cr>')


-- base64
u.vnoremap('<leader>bd', ':<c-u>call base64#v_atob()<cr>', {silent = true})
u.vnoremap('<leader>be', ':<c-u>call base64#v_btoa()<cr>', {silent = true})

-- Searching
-- command! -bang -nargs=* Rg
--   \ call fzf#vim#grep(
--   \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
--   \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
--   \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
--   \   <bang>0)

-- Live grep
u.nnoremap('<c-s>', ':Rg<cr>')
-- Search under cursor
u.nnoremap('<c-a>', ':Rg <c-r><c-w><cr>')
-- Search using selected text
u.vnoremap('<c-a>', 'y0:Rg <c-r>0<cr>')

-- nnoremap <leader>r :luafile ~/.config/nvim/lua/lsp/init.lua<cr>:LspRestart<cr>
-- add json tags to go struct, single level only atm
-- TODO redo in lua
-- nnoremap <leader>gtj vi{:s/\(\w\+\)\s\+\(\[\=\]\=\w\+\)/\1 \2 `json:"\1"`/<cr>vi{:s/json:"\(.*\)"/\="json:\"" . g:Abolish.snakecase(submatch(1)) . ",omitempty\""/g<cr>:noh<cr>
-- nnoremap <leader>jb V:s/,/,\r/g<cr>:noh<cr>
