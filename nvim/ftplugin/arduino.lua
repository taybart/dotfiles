local arduino = {}

local job = require('tools/job')
local picker = require('tools/picker')
local cmds = require('tools/commands')

local board = 'm5stack:esp32:m5stick-c-plus'
local port = ''

function arduino.get_board() return board end

local function set_board()
  local boards = job.run('arduino-cli', { 'board', 'listall' }, { return_all = true })
  table.remove(boards, 1)       -- remove title
  table.remove(boards, #boards) -- remove whitespace

  picker('boards', boards, function(res)
    for b in res:gmatch('%S+') do
      board = b
    end
    print(board)
  end)
end

local function set_port()
  local ports = job.run('arduino-cli', { 'board', 'list' }, { return_all = true })
  table.remove(ports, 1)      -- remove title
  table.remove(ports, #ports) -- remove whitespace

  picker('ports', ports, function(res)
    port = res:match('%S+') -- first
    print(port)
  end)
end

local function compile()
  if board == '' then
    print('no board selected run :SetBoard first')
    return
  end
  vim.cmd('!arduino-cli --no-color compile -b ' .. board)
end

local function upload()
  if port == '' then
    print('no device/port selected run :SetPort first')
    return
  end
  vim.cmd('!arduino-cli --no-color upload -p ' .. port .. ' -b ' .. board)
end

cmds.add({
  { name = 'Compile',  cmd = compile },
  {
    name = 'Upload',
    cmd = function()
      compile()
      upload()
    end,
  },
  { name = 'SetBoard', cmd = set_board },
  { name = 'SetPort',  cmd = set_port },
})

return arduino
