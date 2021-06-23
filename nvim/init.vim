"==============================
"========= Vim config =========
"==============================
filetype plugin indent on

" long live zsh
set shell=/bin/zsh

" remove pauses after j in insert mode
set timeoutlen=1000 ttimeoutlen=0

" HoldCursor faster than 4s
set updatetime=800

" use system clipboard
set clipboard+=unnamedplus,unnamed

" better completion actions
set completeopt=menuone,noinsert,noselect

" cleaner completions
set shortmess+=c

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
set inccommand=nosplit

" put signs in the number column
set signcolumn=number

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"~~~~~ Source other files ~~~~~~~
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" plugins via vim-plug
source ~/.config/nvim/plugins.vim
" keymappings
source ~/.config/nvim/mappings.vim
" looks colorscheme,hi,etc.
source ~/.config/nvim/looks.vim
" autocmd groups
source ~/.config/nvim/autocmds.vim
" lsp config
" lua require('lsp')
