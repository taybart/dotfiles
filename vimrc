execute pathogen#infect()
syntax on
filetype plugin indent on
 
" colorscheme Tomorrow-Night-Eighties
" colorscheme Benokai 
let g:airline_theme="understated"
let g:airline#extensions#tabline#enabled = 1
" for system clipboard buffer
set clipboard=unnamed 
set mouse=a
set ttymouse=xterm2
" Use relative number in normal mode and absolute number in insert mode
set number
set relativenumber
set hlsearch
" Autocmds
" close nerdtree if its the last buffer
autocmd StdinReadPre * let s:std_in=1
" no beeps
set noerrorbells visualbell t_vb=
if has('autocmd')
        autocmd GUIEnter * set visualbell t_vb=
endif

autocmd InsertEnter * set timeoutlen=100
autocmd InsertLeave * set timeoutlen=1000 

function! RangeChooser()
        let temp = tempname()
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
        if !filereadable(temp)
                redraw!
                " Nothing to read
                return
        endif
        let names = readfile(temp)
        if empty(names)
                redraw!
                " Nothing to open
                return
        endif
        " Edit the first item.
        exec 'edit ' . fnameescape(names[0])
        " Add any remaining items to the arg list/buffer list
        for name in names[1:]
                exec 'argadd ' . fnameescape(name)
        endfor
        redraw!
endfunction
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | :call RangeChooser() | endif






" ---------------------------Keymaps-----------------------------------------------------------
imap jk <Esc>
imap kj <Esc>
vmap jk <Esc>

let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>f :call RangeChooser()<CR>
nnoremap <Leader>h :noh<CR>
nnoremap <Leader><Leader> :bn<CR>
nnoremap <Leader>sp :set paste<CR>
nnoremap <Leader>sn :set nopaste<CR>
nnoremap <Leader>q :wq<CR>

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
" ---------------------------------------------------------------------------------------------- 

" --------------------------------------Commenting--------------------------------------------- 
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
nnoremap <leader>/ :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
nnoremap <leader>? :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
" ---------------------------------------------------------------------------------------------- 

 
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
