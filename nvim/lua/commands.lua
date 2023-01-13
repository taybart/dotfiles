local cmd = vim.api.nvim_create_user_command

-- Idiot proofing
cmd('W', 'w', {})
cmd('Q', 'q', {})
cmd('WQ', 'wq', {})
cmd('Wq', 'wq', {})
