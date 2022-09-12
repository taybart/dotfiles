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
