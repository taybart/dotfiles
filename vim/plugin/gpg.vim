" Don't save backups of *.gpg files
set backupskip+=*.gpg
" To avoid that parts of the file is saved to .viminfo when yanking or
" deleting, empty the 'viminfo' option.
set viminfo=
" Disable swap files, and set binary file format before reading the file
autocmd BufReadPre,FileReadPre *.gpg
      \ setlocal noswapfile bin
" Decrypt the contents after reading the file, reset binary file format
" and run any BufReadPost autocmds matching the file name without the .gpg
" extension
autocmd BufReadPost,FileReadPost *.gpg
      \ execute "'[,']!gpg --decrypt --default-recipient-self" |
      \ setlocal nobin |
      \ execute "doautocmd BufReadPost " . expand("%:r")
" Set binary file format and encrypt the contents before writing the file
autocmd BufWritePre,FileWritePre *.gpg
      \ setlocal bin |
      \ '[,']!gpg --encrypt --default-recipient-self
" After writing the file, do an :undo to revert the encryption in the
" buffer, and reset binary file format
autocmd BufWritePost,FileWritePost *.gpg
      \ silent u |
      \ setlocal nobin
