local cmds = require('utils/commands')
cmds.add({
  cmds = {
    { name = 'Expand',  cmd = '.!jq' },
    { name = 'Compact', cmd = '%!jq -c .' },
  },
})
