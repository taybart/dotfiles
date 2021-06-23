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
