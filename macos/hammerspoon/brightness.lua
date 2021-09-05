local u = require('utils')

local brightness = {
    up   = function() u.sendSystemKey("BRIGHTNESS_UP") end,
    down = function() u.sendSystemKey("BRIGHTNESS_DOWN") end,
}
hs.hotkey.bind({"cmd", "ctrl"}, "up", brightness.up)
hs.hotkey.bind({"cmd", "ctrl"}, "down", brightness.down)
