-- Idiot proofing
local cmd = vim.api.nvim_create_user_command
cmd('W', 'w', {})
cmd('Q', 'q', {})
cmd('WQ', 'wq', {})
cmd('Wq', 'wq', {})

vim.cmd([[command! CopyPath let @+ = expand('%')]])
