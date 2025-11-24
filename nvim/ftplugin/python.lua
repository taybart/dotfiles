require('utils/commands').set_run({
  cmd = function()
    local cmd = 'python'
    if vim.fn.executable('uv') then
      cmd = 'uv run'
    end
    vim.cmd('!' .. cmd .. ' %')
  end,
})
