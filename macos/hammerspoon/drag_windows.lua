local u = require('utils')

local dragging_win = nil

local function handle_drag_event(e)
  if dragging_win then
    local props = hs.eventtap.event.properties
    local dx = e:getProperty(props.mouseEventDeltaX)
    local dy = e:getProperty(props.mouseEventDeltaY)
    local mods = hs.eventtap.checkKeyboardModifiers()

    -- Cmd + Ctrl to move the window under cursor
    if mods.cmd and mods.ctrl then
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
end

local drag_event = hs.eventtap.new({
  hs.eventtap.event.types.mouseMoved,
}, handle_drag_event)


local function handle_flag_event(e)
  local flags = e:getFlags()
  if flags.cmd and flags.ctrl and dragging_win == nil then
    dragging_win = u.get_window_under_mouse()
    drag_event:start()
  elseif flags.cmd and flags.shift and dragging_win == nil then
    dragging_win = u.get_window_under_mouse()
    drag_event:start()
  else
    drag_event:stop()
    dragging_win = nil
  end
  return nil
end

local flags_event = hs.eventtap.new({
  hs.eventtap.event.types.flagsChanged,
}, handle_flag_event)

flags_event:start()
