vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.number = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.g.mapleader = ' ' -- space as leader

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

local function mode_group(mode, maps, opts)
  opts = opts or {}
  for _, v in ipairs(maps) do
    if v[3] then
      vim.tbl_deep_extend('force', opts, v[3])
    end
    vim.keymap.set(mode, v[1], v[2], opts)
  end
end

-- Easy escape from insert
mode_group('i', {
  { 'jk', '<Esc>' },
  { 'jK', '<Esc>' },
  { 'JK', '<Esc>' },
})

mode_group('n', {
  { '<leader>l', ':bn<cr>' },
  { '<leader>h', ':bp<cr>' },
  { '<leader>d', ':bp <BAR> bd #<cr>' },
}, { noremap = true })

mode_group('n', {
 { 'zj', 'o<Esc>k' },
 { 'zk', 'O<Esc>j' },
}, { silent = true })

mode_group('n', {
 { 'j', 'gj' },
 { 'k', 'gk' },
 { 'H', '^' },
 { 'L', '$' },
 { '<c-d>', '15gj' }, 
 { '<c-u>', '15gk' } 
})

mode_group('v', {
  { '<c-d>', '15gj' }, 
  { '<c-u>', '15gk' }
  {'<Tab>', '>gv'},
  {'<S-Tab>', '<gv'}
})
