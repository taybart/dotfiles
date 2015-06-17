execute pathogen#infect()
syntax on
filetype plugin indent on
" ---------------- Look ------------------------
colorscheme Tomorrow-Night-Eighties
let g:airline_theme="understated"
let g:airline#extensions#tabline#enabled = 1

" --------------- Sets ------------------------
" Use system clipboard buffer
" set clipboard=unnamed 
set mouse=a
set ttymouse=xterm2

" Use relative number in normal mode and absolute number in insert mode
set number
set relativenumber
set hlsearch

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Color column
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" Buffers
set hidden

"Folding
set foldmethod=indent       " automatically fold by indent level
set nofoldenable            " ... but have folds open by default
"--------------------------- Autocmds -----------------------------------------
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") |:NERDTreeToggle|endif
autocmd StdinReadPre * let s:std_in=1
" no beeps
set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif

autocmd InsertEnter * set timeoutlen=100
autocmd InsertLeave * set timeoutlen=1000 

" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow

" --------------------------- Keymaps -----------------------------------------
imap jk <Esc>
imap kj <Esc>
vmap jk <Esc>
let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>f :NERDTreeToggle<CR>
nnoremap <Leader>nh :noh<CR>
nnoremap <Leader>sp :set paste<CR>
nnoremap <Leader>sn :set nopaste<CR>
nmap <Leader>l :bnext<CR>
nmap <Leader>h :bprevious<CR>
nmap <leader>q :bp <BAR> bd #<CR>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
vnoremap y "+y
map q: :q
nmap j gj
nmap k gk
nmap <F8> :TagbarToggle<CR>

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" ------------------------------Commenting------------------------------------- 
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
autocmd FileType vim              let b:comment_leader = '" '
nnoremap <leader>/ :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
nnoremap <leader>? :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>



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
autocmd FileType c,cpp,py,go,html,erb,rb autocmd BufWritePre :call <SID>StripTrailingWhitespaces()
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
autocmd WinEnter * call NERDTreeQuit()
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
