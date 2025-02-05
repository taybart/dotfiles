local M = {
  darkmode = false,
  watcher = nil,
  subs = {},
}

function M.get_dark_mode_from_system()
  local _, darkmode = hs.osascript.javascript([[
    Application('System Events').appearancePreferences.darkMode.get()
    ]])
  return darkmode
end

function M.set_dark_mode(state)
  hs.osascript.javascript(
    ("Application('System Events').appearancePreferences.darkMode.set(%s)"):format(state)
  )
end

function M.subscribe(fn)
  M.subs[#M._.subs + 1] = fn
end

local function init()
  M.darkmode = M.get_dark_mode_from_system()

  -- init system watcher
  if M.watcher ~= nil then
    return
  end

  M.watcher = hs.distributednotifications.new(function()
    local dark = M.get_dark_mode_from_system()
    if dark ~= M.darkmode then -- we switched
      M.darkmode = dark
      for _, fn in ipairs(M.subs) do
        fn(dark)
      end
    end
  end, 'AppleInterfaceThemeChangedNotification')

  M.watcher:start()
end

init()

return M
