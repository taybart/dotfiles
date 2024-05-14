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

  -- sqeaaalll
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      -- vim.g.db_ui_execute_on_save = false
    end,
    config = function()
      vim.cmd([[ autocmd FileType sql nnoremap <leader>g <Plug>(DBUI_ExecuteQuery) ]])
      vim.cmd([[ autocmd FileType sql vnoremap <leader>g <Plug>(DBUI_ExecuteQuery) ]])
    end,
  },

  -- repeat extra stuff
  { 'tpope/vim-repeat' },
  -- additional subsitutions
  { 'tpope/vim-abolish' },
  -- git
  {
    'tpope/vim-fugitive',
    config = function()
      vim.cmd([[ autocmd FileType fugitive nnoremap <leader>gp :G push<cr> ]])
    end,
  },
  -- somebody come get her
  { 'tpope/vim-scriptease' },
  -- procfile support
  { 'tpope/vim-dotenv' },
}
