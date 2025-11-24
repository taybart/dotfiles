-- Idiot proofing
local cmds = require('utils/commands')
cmds.add({
  { 'W',  'w' },
  { 'Q',  'q' },
  { 'WQ', 'wq' },
  { 'Wq', 'wq' },
})

if vim.fn.executable('unix-timestamp') and false then
  cmds.range('Date', 'unix-timestamp -u %s', { cli = true })
elseif vim.fn.has('mac') then
  -- cmds.one('Date', '<line1>,<line2>!xargs -I {} date -r {}', { range = true })
  cmds.range('Date', 'date -r %s', { cli = true, print = true })
else
  -- cmds.one('Date', '<line1>,<line2>!xargs -I {} date -d @{}', { range = true })
  cmds.range('Date', 'date -d @%s', { cli = true })
end
cmds.one('CopyPath', "let @+ = expand('%')")
