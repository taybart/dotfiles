local arduino = {}

local job = require('utils/job')
local picker = require('utils/picker')

local board = 'm5stack:esp32:m5stick-c-plus'
local port = ''

function arduino.get_board()
  return board
end

local function set_board()
  local boards = job.run('arduino-cli', { 'board', 'listall' }, { return_all = true })
  table.remove(boards, 1) -- remove title
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
  table.remove(ports, 1) -- remove title
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

require('utils/augroup').create({
  arduino_lsp = {
    {
      event = 'FileType',
      pattern = 'arduino',
      callback = function()
        local command = vim.api.nvim_create_user_command
        command('Compile', compile, {})
        command('Upload', function()
          compile()
          upload()
        end, {})
        command('SetBoard', set_board, {})
        command('SetPort', set_port, {})
      end,
    },
  },
})

return arduino
