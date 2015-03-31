execute pathogen#infect()
syntax on
filetype plugin indent on

colorscheme Tomorrow-Night-Eighties

" Use relative number in normal mode and absolute number in insert mode
set number
set relativenumber
set hlsearch
" Airline
let g:airline_theme="molokai"
let g:airline#extensions#tabline#enabled = 1

" Autocmds
" close nerdtree if its the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | 
" autoopen nerdtree in no files
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Keymaps
let mapleader = "\<Space>"
nnoremap <leader>o :CtrlP<CR>
noremap <leader>f :NERDTreeToggle<CR>
" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <leader>/ :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <leader>? :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

imap kj <Esc>
imap jk <Esc>

" habit breaking
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Tabs
set expandtab

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
