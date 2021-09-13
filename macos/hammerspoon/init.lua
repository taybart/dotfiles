require('volume')
require('brightness')
require('snap_windows')

local SkyRocket = hs.loadSpoon("SkyRocket")
SkyRocket:new({
  noClick = true,
  moveModifiers = {'cmd', 'ctrl'},
  resizeModifiers = {'alt', 'ctrl'},
})
hs.loadSpoon("EmmyLua")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", hs.reload)

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
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()


hs.alert.show("Config loaded")
