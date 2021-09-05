local u = require('utils')
local volume = {
    up   = function() u.sendSystemKey("SOUND_UP") end,
    down = function() u.sendSystemKey("SOUND_DOWN") end,
    mute = function() u.sendSystemKey("MUTE") end,
}
hs.hotkey.bind({"cmd", "ctrl"}, "right", volume.up)
hs.hotkey.bind({"cmd", "ctrl"}, "left", volume.down)
