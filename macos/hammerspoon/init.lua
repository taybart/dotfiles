local mash = { 'ctrl', 'alt', 'cmd' }
hs.hotkey.bind(mash, 'r', hs.reload)

hs.loadSpoon('EmmyLua')

-- local db = require('pomodoro/db')
-- db:setup_tables()
-- -- db:add_pomo({ name = 'test:pomo', running = true, paused = false, time = 30 })
-- print(hs.inspect(db:get_latest_pomos(5)))

require('audio')
require('volume')
require('brightness')
require('pomodoro')

require('darkmode').subscribe(function(dark) hs.console.darkMode(dark) end)

--[[
local function reload_config(files)
  local do_reload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      do_reload = true
    end
  end
  if do_reload then
    hs.reload()
  end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reload_config):start()
]]

hs.alert.show('Config loaded')
