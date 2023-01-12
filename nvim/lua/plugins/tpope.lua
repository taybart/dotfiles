return {
  {
    'tpope/vim-surround',
    config = function()
      -- make surround around [",',`] work as expected
      vim.cmd([[
      nmap ysa' ys2i'
      nmap ysa" 'ys2i"
      nmap ysa` 'ys2i`
      ]])
    end,
  },
  -- repeat extra stuff
  { 'tpope/vim-repeat' },
  -- additional subsitutions
  { 'tpope/vim-abolish' },
  -- git
  { 'tpope/vim-fugitive' },
  -- somebody come get her
  { 'tpope/vim-scriptease' },
}
