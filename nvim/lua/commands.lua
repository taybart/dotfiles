-- Idiot proofing
local cmd = vim.api.nvim_create_user_command
cmd('W', 'w', {})
cmd('Q', 'q', {})
cmd('WQ', 'wq', {})
cmd('Wq', 'wq', {})

-- TODO: change for linux date
if vim.fn.has('mac') then
  cmd('Date', '<line1>,<line2>!xargs -I {} date -r {}', { range = true })
else
  cmd('Date', '<line1>,<line2>!xargs -I {} date -d @{}', { range = true })
end
vim.cmd([[command! CopyPath let @+ = expand('%')]])
