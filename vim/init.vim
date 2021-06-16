"==============================
"=========== Plugins ==========
"==============================
call plug#begin('~/.vim/plugged')

"~~~~ code ~~~~
""" fzf
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
" nnoremap <C-p> :Files<CR>

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <C-s> :Telescope live_grep<CR>

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
" Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/completion-nvim'

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
" Plug 'rktjmp/lush.nvim'
" Plug 'npxbr/gruvbox.nvim'

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

lua <<EOF
require('nvim-treesitter.configs').setup {
ensure_installed = "maintained",
highlight = { enable = true },
}

require('lspinstall').setup() -- important

local function setup_servers()
  require('lspinstall').setup()
  local servers = require('lspinstall').installed_servers()
  for _, server in pairs(servers) do
    require('lspconfig')[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
  }
}

vim.fn.sign_define("LspDiagnosticsSignError",
    {text = "✗", texthl = "GruvboxRed"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = "", texthl = "GruvboxYellow"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = "", texthl = "GruvboxBlue"})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = "", texthl = "GruvboxAqua"})
EOF

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

runtime! languages/*.vim

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
  au BufEnter,FocusGained,InsertLeave * if &filetype != "tagbar" && !g:goyo_mode
        \ | set relativenumber
        \ | endif
  au BufLeave,FocusLost,InsertEnter * if &filetype != "tagbar" && !g:goyo_mode
        \ | set norelativenumber
        \ | endif
augroup END

" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White

" Underline the offending code
hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineWarning guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline




hi TelescopeSelection      guifg=Red gui=bold " selected item
" hi TelescopeSelectionCaret guifg=#CC241D " selection caret
" hi TelescopeMultiSelection guifg=#928374 " multisections
" hi TelescopeNormal         guibg=#00000  " floating windows created by telescope.

" " Border hi groups.
" hi TelescopeBorder         guifg=#ffffff
" hi TelescopePromptBorder   guifg=#ffffff
" hi TelescopeResultsBorder  guifg=#ffffff
" hi TelescopePreviewBorder  guifg=#ffffff

" " Used for hiing characters that you match.
" hi TelescopeMatching       guifg=blue

" " Used for the prompt prefix
" hi TelescopePromptPrefix   guifg=red


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

" escape in terminal
tnoremap <Esc> <C-\><C-n>

nmap <silent> gr <Plug>(coc-references)


" LSP
nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K  :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> [d :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> ]d :lua vim.lsp.diagnostic.goto_prev()<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Tagbar
nnoremap <F8> :TagbarToggle<CR>


" base64
vnoremap <silent> <leader>bd :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>be :<c-u>call base64#v_btoa()<cr>

" Search under cursor
nnoremap <C-a> :Rg <C-r><C-w><CR>

"--------------------------- Autocmds -----------------------------------------
augroup vimrc_autocmd
  au!
  " au StdinReadPre * let s:std_in=1
  " no beeps
  " set noerrorbells visualbell t_vb=
  " au GUIEnter * set visualbell t_vb=

  au InsertEnter * set timeoutlen=100
  au InsertLeave * set timeoutlen=1000

  au! User GoyoEnter nested call <SID>goyo_enter()
  au! User GoyoLeave nested call <SID>goyo_leave()
augroup END

augroup language_autocmd
  au!
  autocmd BufEnter * lua require'completion'.on_attach()
  " au FileType * autocmd BufWritePre <buffer> StripWhitespace
augroup END

augroup commentary
  au!
  au FileType helm setlocal commentstring=#\ %s
  au FileType svelte setlocal commentstring=<!--\ %s\ -->
  au FileType gomod setlocal commentstring=//\ %s
augroup END


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
