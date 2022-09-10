-- hs.loadSpoon('EmmyLua')

hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'a', function()
  local source = 'taps'
  local success = hs.audiodevice.findOutputByName(source):setDefaultOutputDevice()
  if not success then
    hs.alert.show('could not set output device')
    return
  end
  success = hs.audiodevice.findInputByName(source):setDefaultInputDevice()
  if not success then
    hs.alert.show('could not set input device')
    return
  end
  hs.alert.show('switched to output to ' .. source)
end)

-- require('middleclick')
require('volume')
require('brightness')
-- require('snap_windows')

hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'r', hs.reload)

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

hs.alert.show('Config loaded')
