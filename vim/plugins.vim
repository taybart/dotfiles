"==============================
"=========== Plugins ==========
"==============================
call plug#begin('~/.vim/plugged')
"~~~~ code ~~~~
""" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files<CR>

" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" nnoremap <C-p> :Telescope find_files<CR>
" nnoremap <C-s> :Telescope live_grep<CR>

""" fern file explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
let g:fern#renderer = 'nerdfont'
let g:fern#disable_default_mappings = 1

""" tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1

""" tree-sitter configs
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

""" nvim lsp configs
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

""" completion with lsp
Plug 'hrsh7th/nvim-compe'
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.source = {
      \ 'path': v:true,
      \ 'buffer': v:true,
      \ 'nvim_lsp': v:true,
      \ }

""" rest.vim
Plug 'taybart/rest.vim'
"
""" tagbar
Plug 'majutsushi/tagbar'

""" base64
Plug 'christianrondeau/vim-base64'

""" polyglot
" Plug 'sheerun/vim-polyglot'
" let g:polyglot_disabled = ['markdown']
" Plug 'ARM9/arm-syntax-vim'

""" neosnippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

""" 🙏 the pope
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'go', 'javascript', 'typescript']
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
command! Gconflict :Gvdiffsplit!

"~~~~ notes ~~~~
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
let g:notes_directories = ['~/.notes']
"" goyo
Plug 'junegunn/goyo.vim'

"~~~~ looks ~~~~
""" dark
Plug 'morhetz/gruvbox'

""" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Colorizer
" make colored terminal pipes look ok
Plug 'chrisbra/Colorizer'
""" Questionable
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'dyng/ctrlsf.vim'

call plug#end()
