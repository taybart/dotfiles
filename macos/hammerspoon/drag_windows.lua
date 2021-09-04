-- Inspired by Linux alt-drag or Better Touch Tools move/resize functionality

local function get_window_under_mouse()
  -- Invoke `hs.application` because `hs.window.orderedWindows()` doesn't do it
  -- and breaks itself
  local _ = hs.application

  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()

  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return my_screen == w:screen() and my_pos:inside(w:frame())
  end)
end

local dragging_win = nil
local dragging_mode = 1

local drag_event = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(e)
  if dragging_win then
    local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
    local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
    local mods = hs.eventtap.checkKeyboardModifiers()

    -- Cmd + Ctrl to move the window under cursor
    if dragging_mode == 1 and mods.cmd and mods.ctrl then
      dragging_win:move({dx, dy}, nil, false, 0)

    -- Alt + Ctrl to resize the window under cursor
    elseif mods.alt and mods.ctrl then
      local sz = dragging_win:size()
      local w1 = sz.w + dx
      local h1 = sz.h + dy
      dragging_win:setSize(w1, h1)
    end
  end
  return nil
end)

local flags_event = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
  local flags = e:getFlags()
  if flags.cmd and flags.ctrl and dragging_win == nil then
    dragging_win = get_window_under_mouse()
    dragging_mode = 1
    drag_event:start()
  elseif flags.cmd and flags.shift and dragging_win == nil then
    dragging_win = get_window_under_mouse()
    dragging_mode = 2
    drag_event:start()
  else
    drag_event:stop()
    dragging_win = nil
  end
  return nil
end)
flags_event:start()
