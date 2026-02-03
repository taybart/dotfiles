local alert = hs.alert.show
hs.hotkey.bind({ 'cmd', 'ctrl', 'shift' }, 'a', function()
  local source = 'TAPs'
  local _, _, _, rc = hs.execute('blueutil --connect 98-1c-a2-e3-a6-22', true)
  if rc ~= 0 then
    alert('could not connect to device')
    return
  end
  local output = hs.audiodevice.findOutputByName(source)
  if output == nil then
    alert('could not find output device')
    return
  end
  local success = output:setDefaultOutputDevice()
  if not success then
    alert('could not set default output device')
    return
  end
  success = output:setDefaultEffectDevice()
  if not success then
    alert('could not set default effect device')
    return
  end
  local input = hs.audiodevice.findInputByName(source)
  if input ~= nil then
    success = input:setDefaultInputDevice()
    if not success then alert('could not set default input device') end
  end
  alert('switched output to ' .. source)
end)

hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'a', function()
  local source = 'MacBook Pro Speakers'
  local output = hs.audiodevice.findOutputByName(source)
  if output == nil then
    alert('could not find output device')
    return
  end
  local success = output:setDefaultOutputDevice()
  if not success then
    alert('could not set output device')
    return
  end
  success = output:setDefaultEffectDevice()
  if not success then
    alert('could not set output device')
    return
  end
  local input = hs.audiodevice.findInputByName(source)
  if input ~= nil then
    success = input:setDefaultInputDevice()
    if not success then alert('could not set input device') end
  end
  alert('switched output to ' .. source)
end)
