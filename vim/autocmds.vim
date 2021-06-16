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
  " autocmd BufEnter * lua require'completion'.on_attach()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  " au FileType * autocmd BufWritePre <buffer> StripWhitespace

  autocmd BufEnter * lua require'completion'.on_attach()
  autocmd BufWritePre *.go lua go_organize_imports_sync(1000)
  " autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
  au BufRead,BufNewFile *.tmpl setfiletype gohtmltmpl
  " au FileType * autocmd BufWritePre <buffer> StripWhitespace
augroup END

" au FileType go nmap gtj :CocCommand go.tags.add json<cr>
" au FileType go nmap gty :CocCommand go.tags.add yaml<cr>
" au FileType go nmap gtx :CocCommand go.tags.clear<cr>
" " au FileType go nmap <leader>r <Plug>(go-run)
" au FileType go nmap <leader>r :!go run %<cr>


augroup language_autocmd
  au!
augroup END

augroup commentary
  au!
  au FileType helm setlocal commentstring=#\ %s
  au FileType svelte setlocal commentstring=<!--\ %s\ -->
  au FileType gomod setlocal commentstring=//\ %s
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
