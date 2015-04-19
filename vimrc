execute pathogen#infect()
syntax on
filetype plugin indent on
 
colorscheme Tomorrow-Night-Eighties
" colorscheme Benokai 

" Use relative number in normal mode and absolute number in insert mode
set number
set relativenumber
set hlsearch

" wrapping
" set wrap
" set linebreak
" set nolist  " list disables linebreak
" Airline
let g:airline_theme="molokai"
let g:airline#extensions#tabline#enabled = 1

" Autocmds
" close nerdtree if its the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | 
" autoopen nerdtree in no files
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" no beeps
set noerrorbells visualbell t_vb=
if has('autocmd')
        autocmd GUIEnter * set visualbell t_vb=
endif

autocmd InsertEnter * set timeoutlen=100
autocmd InsertLeave * set timeoutlen=1000 


" Keymaps
imap kj <Esc>
imap jk <Esc>

let mapleader = "\<Space>"
nnoremap <eader>o :CtrlP<CR>
nnoremap <Leader>f :NERDTreeToggle<CR>
nnoremap <Leader>h :noh<CR>
nnoremap <Leader><Leader> :bn<CR>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
map q: :q

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
nnoremap <leader>/ :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
nnoremap <leader>? :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

 
" Tabs
set expandtab
set tabstop=2
"" strip trailing whitespace
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
