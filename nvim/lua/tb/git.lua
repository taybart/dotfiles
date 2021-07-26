
vim.cmd[[
command! ShowHunk lua require"gitsigns".preview_hunk()
command! ResetHunk lua require"gitsigns".reset_hunk()
command! StageHunk lua require"gitsigns".stage_hunk()
]]

-- should not need this much config, revisit later
require('gitsigns').setup{
  current_line_blame = true,
  current_line_blame_delay = 0,
  keymaps = {
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    -- ['n <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    -- ['v <leader>ghs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    -- ['n <leader>ghu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    -- ['n <leader>ghR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    -- ['n <leader>ghb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
}
