-- Idiot proofing
local cmds = require('utils/commands')
cmds.add({
  { 'W', 'w' },
  { 'Q', 'q' },
  { 'WQ', 'wq' },
  { 'Wq', 'wq' },
})

if vim.fn.has('mac') then
  cmds.one('Date', '<line1>,<line2>!xargs -I {} date -r {}', { range = true })
else
  cmds.one('Date', '<line1>,<line2>!xargs -I {} date -d @{}', { range = true })
end
cmds.one('CopyPath', "let @+ = expand('%')")
