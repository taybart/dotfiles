local job = require('utils/job')
local picker = require('utils/picker')

local board = 'm5stack:esp32:m5stick-c-plus'
local port = ''

--[==[
-- testing with nui
local function pick_port()
  local Menu = require('nui.menu')
  local event = require('nui.utils.autocmd').event

  local ports = job.run('arduino-cli', { 'board', 'list' }, { return_all = true })
  table.remove(ports, 1) -- remove title
  table.remove(ports, #ports) -- remove whitespace

  local menu_items = {}
  for i, p in ipairs(ports) do
    menu_items[i] = Menu.item(p:match('%S+'))
  end

  local menu = Menu({
    position = '50%',
    size = {
      width = 75,
      height = 5,
    },
    border = {
      style = 'single',
      text = {
        top = 'Select Port',
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    lines = menu_items,
    -- max_width = 20,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>' },
      close = { '<Esc>', '<C-c>' },
      submit = { '<CR>', '<Space>' },
    },
    on_submit = function(item)
      print('selected', item.text)
      port = item.text
    end,
  })

  -- mount the component
  menu:mount()

  -- close menu when cursor leaves buffer
  menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
end
--]==]

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

require('utils').create_augroups({
  arduino_lsp = {
    {
      event = 'FileType',
      pattern = 'arduino',
      callback = function()
        vim.api.nvim_create_user_command('Compile', compile, {})
        vim.api.nvim_create_user_command('Upload', function()
          compile()
          upload()
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
