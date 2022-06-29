local job = require('utils/job')
local picker = require('utils/picker')

local board = 'm5stack:esp32:m5stick-c-plus'
local port = ''

local function set_board()
  local boards = job.run('arduino-cli', { 'board', 'listall' }, { return_all = true })
  table.remove(boards, 1) -- remove title
  table.remove(boards, #boards) -- remove whitespace

  picker.pick('boards', boards, function(res)
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

  picker.pick('ports', ports, function(res)
    port = res:match('%S+') -- first
    print(port)
  end)
end

require('utils').create_augroups({
  arduino_lsp = {
    {
      event = 'FileType',
      pattern = 'arduino',
      callback = function()
        vim.api.nvim_create_user_command('Compile', function()
          if board == '' then
            print('no board selected run SetBoard first')
            return
          end
          job.run('arduino-cli', { 'compile', '-b', board }, { timeout = 60000 })
          print('compiled for ' .. board)
        end, {})
        vim.api.nvim_create_user_command('Upload', function()
          if port == '' then
            print('no port selected run SetPort first')
            return
          end
          if board == '' then
            print('no board selected run SetBoard first')
            return
          end

          job.run('arduino-cli', { 'compile', '-b', board }, { timeout = 120000 })
          print('compiled for ' .. board)
          job.run('arduino-cli', { 'upload', '-p', port, '-b', board }, { timeout = 300000 })
          print('upload complete to' .. port)
        end, {})
        vim.api.nvim_create_user_command('SetBoard', set_board, {})
        vim.api.nvim_create_user_command('SetPort', set_port, {})
      end,
    },
  },
})

return {
  get_board = function()
    return board
  end,
}
