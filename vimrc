execute pathogen#infect()
syntax on
filetype plugin indent on
scriptencoding utf-8
set encoding=utf-8
"set t_Co=16
set t_Co=256
set autowrite
" ---------------- Look ------------------------
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Darwin"
    colorscheme Tomorrow-Night
else
    colorscheme Tomorrow-Night
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabbar#enabled = 1

" --------------- Sets/lets ---------------------

" Set word wrapping
set whichwrap+=<,>,h,l,[,]
"if has("gui_running")
highlight Pmenu guibg=brown gui=bold
"else
"highlight Pmenu ctermfg=15 ctermbg=0
"endif

set shell=/bin/bash
set cursorline
"set cursorcolumn
" Use system clipboard buffer
if has('unnamedplus')
    " By default, Vim will not use the system clipboard when yanking/pasting to
    " the default register. This option makes Vim use the system default
    " clipboard.
    " Note that on X11, there are _two_ system clipboards: the "standard" one, and
    " the selection/mouse-middle-click one. Vim sees the standard one as register
    " '+' (and this option makes Vim use it by default) and the selection one as
    " '*'.
    " See :h 'clipboard' for details.
    set clipboard=unnamedplus,unnamed
else
    " Vim now also uses the selection system clipboard for default yank/paste.
    set clipboard=unnamed
endif

set hlsearch!


set mouse=a
set ttymouse=xterm2

" Use relative number in normal mode and absolute number in insert mode
set number
set relativenumber
set hlsearch

" Paren/bracket matching
" set showmatch

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Color column
set colorcolumn=0
highlight ColorColumn ctermbg=darkgray

" Buffers
set hidden

" Project vimrc files
set exrc
set secure

" Folding
set foldmethod=manual
set nofoldenable            " Have folds open by default

" Custom togglelist commands
let g:toggle_list_no_mappings=1
" GitGutter
let g:gitgutter_map_keys = 0

" Pyclewn
let g:pyclewn_python="python3"
let g:pyclewn_args = "--pgm=/usr/bin/arm-none-eabi-gdb"


" Airline

" let g:airline_powerline_fonts = 1
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Darwin"
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " old vim-powerline symbols
    let g:airline_left_sep = '⮀'
    let g:airline_left_alt_sep = '⮁'
    let g:airline_right_sep = '⮂'
    let g:airline_right_alt_sep = '⮃'
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
endif

" YankRing
let g:yankring_history_file = '.yankring'

" Tmux
let g:tmux_navigator_no_mappings = 1

" ctags
set tags=tags;

"gvim
"set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" NERDTree
let NERDTreeIgnore=['\.o$','\.d$', '\~$']

" GCC
set errorformat^=%-G%f:%l:\ warning:%m
set errorformat^=%-G%f:%l:\ note:%m

" Git gutter
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_max_signs = 500
let g:gitgutter_escape_grep = 1

" HTML Autocomplete tags
iabbrev <// </<C-X><C-O>

"--------------------------- Autocmds -----------------------------------------
augroup vimrc_autocmd
    autocmd!
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") |:NERDTreeToggle|endif
    autocmd StdinReadPre * let s:std_in=1
    " no beeps
    set noerrorbells visualbell t_vb=
    if has('autocmd')
        autocmd GUIEnter * set visualbell t_vb=
    endif

    autocmd InsertEnter * set timeoutlen=100
    autocmd InsertLeave * set timeoutlen=1000

    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
    au BufReadPost quickfix setlocal colorcolumn=0

    autocmd FileType h,c,cpp,py,go,html,erb,rb autocmd BufWritePre <buffer> StripWhitespace

    autocmd WinEnter * call NERDTreeQuit()

augroup END

" --------------------------- Keymaps -----------------------------------------
let mapleader = "\<Space>"

" NERDTree
nnoremap <Leader>f :NERDTreeToggle<CR>

" Quickfix, Location, and Tagbar
nnoremap <script> <silent> <F7> :call ToggleQuickfixList()<CR>
nnoremap <script> <silent> <F6> :call ToggleLocationList()<CR>
nmap <F8> :TagbarToggle<CR>

" Turn off highlighted searching
nnoremap <Leader>nh :set hlsearch!<CR>

nnoremap gd <c-]>

" Setting and removing paste mode
" need a better way though but too lazy
nnoremap <Leader>sp :set paste<CR>
nnoremap <Leader>sn :set nopaste<CR>

" Buffer control
nmap <Leader>l :bnext<CR>
nmap <Leader>n :bnext<CR>
nmap <Leader>h :bprevious<CR>
nmap <Leader>d :bp <BAR> bd #<CR>

nmap <Leader>e<CR> :cnext<CR>

" tmux integration
nmap <silent> <c-h> :TmuxNavigateLeft<cr>
nmap <silent> <c-m> :TmuxNavigateDown<cr>
nmap <silent> <c-u> :TmuxNavigateUp<cr>
nmap <silent> <c-l> :TmuxNavigateRight<cr>
nmap <silent> <c-\> :TmuxNavigatePrevious<cr>

" This command will allow us to save a file we don't have permission to save
" *after* we have already opened it.
cnoremap w!! w !sudo tee % >/dev/null

" ------Make shit easier-----
nmap <Leader>s<CR> :NERDTreeFind<CR>

" Easy escape from insert
imap jk <Esc>
imap jK <Esc>
imap JK <Esc>
imap kj <Esc>
imap KJ <Esc>

" Allow for innerline navagation
nmap j gj
nmap k gk

" Allow for homerow up and down in command mode
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" Faster down and up
nnoremap <c-j> 15gj
nnoremap <c-k> 15gk

" Quickly open/reload vim
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Idiot proofing
cnoremap w' w
cnoremap W w
cnoremap Q q

" These create newlines like o and O but stay in normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j
" Fix all indents
nnoremap <leader>t<CR> mzgg=G`z
" Get rid of the fucking stupid OCD whitespace
nnoremap <leader>w<CR> :%s/\s\+$//<CR>
" Toggle git gutter when it starts getting pissed
cnoremap git :GitGutterToggle<CR>
" Fix json files
cnoremap fixjson %!python -m json.tool<CR>
" Quoting
nnoremap <leader>q" ciw""<Esc>P
nnoremap <leader>q' ciw''<Esc>P
nnoremap <leader>qd daW"=substitute(@@,"'\\\|\"","","g")<CR>P
" Run python scripts
nnoremap <leader>py :!python %<CR>
" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>
" ------------------------- Strip trailing whitespace -------------------------
function! <SID>StripTrailingWhitespaces()
    "Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" ---------------- Quit NERDTree if it is the last buffer --------------------
function! NERDTreeQuit()
    redir => buffersoutput
    silent buffers
    redir END
    "                     1BufNo  2Mods.     3File           4LineNo
    let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
    let windowfound = 0

    for bline in split(buffersoutput, "\n")
        let m = matchlist(bline, pattern)

        if (len(m) > 0)
            if (m[2] =~ '..a..')
                let windowfound = 1
            endif
        endif
    endfor

    if (!windowfound)
        quitall
    endif
endfunction
" -------------------- NERDTree previews -----------------------
let g:nerd_preview_enabled = 0
let g:preview_last_buffer  = 0

function! NerdTreePreview()
    " Only on nerdtree window
    if (&ft ==# 'nerdtree')
        " Get filename
        let l:filename = substitute(getline("."), "^\\s\\+\\|\\s\\+$","","g")

        " Preview if it is not a folder
        let l:lastchar = strpart(l:filename, strlen(l:filename) - 1, 1)
        if (l:lastchar != "/" && strpart(l:filename, 0 ,2) != "..")

            let l:store_buffer_to_close = 1
            if (bufnr(l:filename) > 0)
                " Don't close if the buffer is already open
                let l:store_buffer_to_close = 0
            endif

            " Do preview
            execute "normal go"

            " Close previews buffer
            if (g:preview_last_buffer > 0)
                execute "bwipeout " . g:preview_last_buffer
                let g:preview_last_buffer = 0
            endif

            " Set last buffer to close it later
            if (l:store_buffer_to_close)
                let g:preview_last_buffer = bufnr(l:filename)
            endif
        endif
    elseif (g:preview_last_buffer > 0)
        " Close last previewed buffer
        let g:preview_last_buffer = 0
    endif
endfunction

function! NerdPreviewToggle()
    if (g:nerd_preview_enabled)
        let g:nerd_preview_enabled = 0
        augroup nerdpreview
            autocmd!
        augroup END
    else
        let g:nerd_preview_enabled = 1
        augroup nerdpreview
            autocmd!
            autocmd CursorMoved * nested call NerdTreePreview()
        augroup END
    endif
endfunction
