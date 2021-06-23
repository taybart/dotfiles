"==============================
"======== Keybindings =========
"==============================
let mapleader = "\<Space>"

" Easy escape from insert
imap jk <Esc>
imap jK <Esc>
imap JK <Esc>

" Quickly open/reload vim
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

command! -nargs=1 Ev e ~/.vim/<args>.vim

" Idiot proofing
command! W w
command! Q q

" fern
noremap <silent> <Leader>f :Fern . -drawer -reveal=% -toggle -width=35<cr>

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
nnoremap <Leader>l :bnext<cr>
nnoremap <Leader>n :bnext<cr>
nnoremap <Leader>h :bprevious<cr>
nnoremap <Leader>d :bp <BAR> bd #<cr>

"~~~~~~~~~~~~~~~~~~~
"~~~~~ FORMAT ~~~~~~
"~~~~~~~~~~~~~~~~~~~
"
" These create newlines like o and O but stay in normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j
" Fix all indents
nnoremap <leader>t<cr> mzgg=G`z:w<cr>
" Get rid of the fucking stupid OCD whitespace
nnoremap <leader>w<cr> :%s/\s\+$//<cr>:w<cr>
" Emacs indent
nnoremap <Tab> ==
vnoremap <Tab> =
"
"~~~~~~~~~~~~~~~~~~~
"~~~~~ PLUGINS ~~~~~
"~~~~~~~~~~~~~~~~~~~

" tmux integration
nnoremap <silent> <c-m> :TmuxNavigateDown<cr>
nnoremap <silent> <c-u> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-;> :TmuxNavigatePrevious<cr>

" escape in terminal
tnoremap <Esc> <c-\><c-n>

" coc.vim
nnoremap <leader>cr :CocRestart<cr>

nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<c-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
au BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Tagbar
nnoremap <F8> :TagbarToggle<cr>


" base64
vnoremap <silent> <leader>bd :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>be :<c-u>call base64#v_btoa()<cr>

" Searching
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

" Live grep
nnoremap <c-s> :Rg<cr>
" Search under cursor
nnoremap <c-a> :Rg <c-r><c-w><cr>
" Search using selected text
vnoremap <c-a> y0:Rg <c-r>0<cr>

" command! ConfEdit


nnoremap <leader>r :luafile ~/.config/nvim/lua/lsp/init.lua<cr>:LspRestart<cr>
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
  nmap <buffer> <cr> <Plug>(fern-my-open-expand-collapse)
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
