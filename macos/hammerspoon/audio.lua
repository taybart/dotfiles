hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'a', function()
  local source = 'taps'
  local output = hs.audiodevice.findOutputByName(source)
  if output == nil then
    hs.alert.show('could not find output device')
    return
  end
  local success = output:setDefaultOutputDevice()
  if not success then
    hs.alert.show('could not set output device')
    return
  end
  success = output:setDefaultEffectDevice()
  if not success then
    hs.alert.show('could not set output device')
    return
  end
  local input = hs.audiodevice.findInputByName(source)
  if input ~= nil then
    success = input:setDefaultInputDevice()
    if not success then
      hs.alert.show('could not set input device')
    end
  end
  hs.alert.show('switched output to ' .. source)
end)
