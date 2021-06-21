"==============================
"======== Keybindings =========
"==============================
let mapleader = "\<Space>"

" Easy escape from insert
imap jk <Esc>
imap jK <Esc>
imap JK <Esc>

" Quickly open/reload vim
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

command! -nargs=1 Ev e ~/.vim/<args>.vim

" Idiot proofing
command! W w
command! Q q

" fern
noremap <silent> <Leader>f :Fern . -drawer -reveal=% -toggle -width=35<CR>

"~~~~~~~~~~~~~~~~~~~
"~~~~ MOVEMENT ~~~~~
"~~~~~~~~~~~~~~~~~~~

" Allow for homerow up and down in command mode
cnoremap <c-j> <down>
cnoremap <c-k> <up>
" Allow for innerline navagation
nnoremap j gj
nnoremap k gk

" Faster down and up
nnoremap <c-j> 15gj
vnoremap <c-j> 15gj
nnoremap <c-k> 15gk
vnoremap <c-k> 15gk
" End and beg of line easier
nnoremap H ^
nnoremap L $

" Buffer control
nnoremap <Leader>l :bnext<CR>
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>h :bprevious<CR>
nnoremap <Leader>d :bp <BAR> bd #<CR>

"~~~~~~~~~~~~~~~~~~~
"~~~~~ FORMAT ~~~~~~
"~~~~~~~~~~~~~~~~~~~
"
" These create newlines like o and O but stay in normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j
" Fix all indents
nnoremap <leader>t<CR> mzgg=G`z:w<CR>
" Get rid of the fucking stupid OCD whitespace
nnoremap <leader>w<CR> :%s/\s\+$//<CR>:w<CR>
" Emacs indent
nnoremap <Tab> ==
vnoremap <Tab> =
"
"~~~~~~~~~~~~~~~~~~~
"~~~~~ PLUGINS ~~~~~
"~~~~~~~~~~~~~~~~~~~

" tmux integration
nnoremap <silent> <c-m> :TmuxNavigateDown<CR>
nnoremap <silent> <c-u> :TmuxNavigateUp<CR>
nnoremap <silent> <c-l> :TmuxNavigateRight<CR>
nnoremap <silent> <c-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-;> :TmuxNavigatePrevious<cr>

" escape in terminal
tnoremap <Esc> <C-\><C-n>

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Tagbar
nnoremap <F8> :TagbarToggle<CR>


" base64
vnoremap <silent> <leader>bd :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>be :<c-u>call base64#v_btoa()<cr>

" Search under cursor
nnoremap <C-a> :Rg <C-r><C-w><CR>


" command! ConfEdit


" add json tags to go struct, single level only atm
nnoremap <leader>gtj vi{:s/\(\w\+\)\s\+\(\w\+\)/\1 \2 `json:"\1"`/<cr>vi{:s/json:"\(.*\)"/\="json:\"" . g:Abolish.snakecase(submatch(1)) . ",omitempty\""/g<cr>:noh<cr>

" ------------------------------ fern -----------------------------------------

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer><nowait> d <Plug>(fern-action-remove)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> h <Plug>(fern-action-hidden-toggle)
  nmap <buffer> R <Plug>(fern-action-reload)
  nmap <buffer> e <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END
