
local M = {}

local function addopt(cmd, oname, value)
  return cmd .. ' gui' .. oname .. '=' .. value .. ' cterm'.. oname ..'=' .. value
end


function M.hi (name, opts)
  local cmd = 'hi ' .. name
  if opts.fg ~= nil then
    cmd = addopt(cmd, 'fg', opts.fg)
  end
  if opts.bg ~= nil then
    cmd = addopt(cmd, 'bg', opts.bg)
  end
  if opts.type ~= nil then
    cmd = addopt(cmd, '',opts.type)
  end
  vim.cmd(cmd)
end


return M
