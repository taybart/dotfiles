require('move_windows')
require('drag_windows')
-- require('snap_windows')
require('brightness')
require('volume')

local function reload_config(files)
    local do_reload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            do_reload = true
        end
    end
    if do_reload then
        hs.reload()
    end
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", hs.reload)
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
