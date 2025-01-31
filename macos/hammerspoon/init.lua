hs.loadSpoon('EmmyLua')

require('audio')
require('volume')
require('brightness')
require('pomodoro')
-- require('snap_windows')

local mash = { 'ctrl', 'alt', 'cmd' }

-- hs.hotkey.bind(mash, 'U', pomodoro.startNew)
-- hs.hotkey.bind(mash, 'I', pomodoro.togglePaused)
-- hs.hotkey.bind(mash, 'O', pomodoro.toggleLatestDisplay)

hs.hotkey.bind(mash, 'r', hs.reload)

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
