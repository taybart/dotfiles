"==============================
"=========== Plugins ==========
"==============================
call plug#begin('~/.vim/plugged')

""" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" keybind
nnoremap <C-p> :Files<CR>

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
let g:fern#renderer = 'nerdfont'
let g:fern#disable_default_mappings = 1

""" tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1


"~~~~ code ~~~~
""" rest.vim
Plug 'taybart/rest.vim'
" Plug 'transcoder'
""" tagbar
Plug 'majutsushi/tagbar'
""" coc.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Better display for messages
" set cmdheight=2
" set updatetime=300
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
  \'coc-go',
  \'coc-tsserver',
  \'coc-prettier',
  \'coc-eslint',
  \'coc-css',
  \'coc-html',
  \'coc-json',
\]

""" base64
Plug 'christianrondeau/vim-base64'


""" polyglot
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['markdown']


""" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

""" Nerd Commenter " good bye sweet prince...me want to get closers to vim
" Plug 'scrooloose/nerdcommenter'
" let g:NERDSpaceDelims = 1

""" 🙏 the pope
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'go', 'javascript']
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
command! G Ge :

"~~~~ notes ~~~~
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
let g:notes_directories = ['~/.notes']
"" goyo
Plug 'junegunn/goyo.vim'

"~~~~ looks ~~~~
""" dark
Plug 'morhetz/gruvbox'
""" light
" Plug 'vim-scripts/PaperColor.vim'
""" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

" Colorizer
" make colored terminal pipes look ok
Plug 'chrisbra/Colorizer'
""" Questionable
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'dyng/ctrlsf.vim'

call plug#end()

"==============================
"========= Vim config =========
"==============================
filetype plugin indent on
" long live zsh
set shell=/bin/zsh

" remove pauses after j in insert mode
set timeoutlen=1000 ttimeoutlen=0

" use system clipboard
set clipboard+=unnamedplus,unnamed

" add line wrapping
set whichwrap+=<,>,h,l,[,]

" allow unsaved buffers
set hidden

" use 2 spaces as tabs and always
" expand to spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" allow mouse scrolling
set mouse=a

" show incomplete commands (like substitute)
if has('nvim')
	set inccommand=nosplit
endif

"~~~~~~~~~~~~~~~~~~~
"~~~~~ Looks ~~~~~~~
"~~~~~~~~~~~~~~~~~~~
set background=dark
colorscheme gruvbox
" let g:airline_theme='gruvbox'
"
" set background=light
" colorscheme papercolor
let g:airline_theme='papercolor'

let g:goyo_mode = 0
" add numbers
set number relativenumber
augroup numbertoggle
  au!
  au BufEnter,FocusGained,InsertLeave * if &filetype != "nerdtree" && &filetype != "tagbar" && !g:goyo_mode
        \ | set relativenumber
        \ | endif
  au BufLeave,FocusLost,InsertEnter * if &filetype != "nerdtree" && &filetype != "tagbar" && !g:goyo_mode
        \ | set norelativenumber
        \ | endif
augroup END

" set relativenumber


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

" coc.vim
nnoremap <leader>cr :CocRestart<CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

au FileType go nmap gtj :CocCommand go.tags.add json<cr>
au FileType go nmap gty :CocCommand go.tags.add yaml<cr>
au FileType go nmap gtx :CocCommand go.tags.clear<cr>
au FileType go nmap <leader>r <Plug>(go-run)

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

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Tagbar
nnoremap <F8> :TagbarToggle<CR>


" base64
vnoremap <silent> <leader>bd :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>be :<c-u>call base64#v_btoa()<cr>



" fix sourcing vimrc messing up devicons
" if exists("g:loaded_webdevicons")
"   call webdevicons#refresh()
" endif

" the pope - commentary
augroup commentary
  au!
  au FileType helm setlocal commentstring=#\ %s
  au FileType svelte setlocal commentstring=<!--\ %s\ -->
augroup END


"--------------------------- Autocmds -----------------------------------------
augroup vimrc_autocmd
  au!
  au StdinReadPre * let s:std_in=1
  " no beeps
  set noerrorbells visualbell t_vb=
  au GUIEnter * set visualbell t_vb=

  au InsertEnter * set timeoutlen=100
  au InsertLeave * set timeoutlen=1000

  " au FileType * autocmd BufWritePre <buffer> StripWhitespace
  au BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

  au BufWritePre * :call CocAction('format')


  au! User GoyoEnter nested call <SID>goyo_enter()
  au! User GoyoLeave nested call <SID>goyo_leave()
augroup END



" ------------------------------ fern -----------------------------------------

" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END


function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
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
  nmap <buffer> d <Plug>(fern-action-remove)
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

" -------------------------------- Goyo custom --------------------------------
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1

  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  set noshowmode
  set noshowcmd
  set scrolloff=999
  set norelativenumber

  let g:goyo_mode = 1
  " Limelight
endfunction

function! s:goyo_leave()
  set showmode
  set showcmd
  set scrolloff=5
  " Limelight!

  let g:goyo_mode = 0
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction
