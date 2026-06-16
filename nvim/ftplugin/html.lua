if vim.fn.search('{{', 'n') > 0 or vim.fn.search('{%', 'n') > 0 then
  vim.bo.filetype = 'htmldjango'
end
