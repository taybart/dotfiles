local M = {
  darkmode = false,
  watcher = nil,
  subs = {},
}

local dm = "Application('System Events').appearancePreferences.darkMode"
function M.system_preference()
  local success, darkmode = hs.osascript.javascript(('%s.get()'):format(dm))
  if not success then
    error('failed to get system dark mode preference')
    return
  end
  return darkmode
end

function M.set_dark_mode(state)
  local success = hs.osascript.javascript(('%s.set(%s)'):format(dm, state))
  if not success then
    error('could not set system dark mode preference')
  end
end

function M.subscribe(fn)
  M.subs[#M.subs + 1] = fn
end

local function init()
  M.darkmode = M.system_preference()

  -- init system watcher
  if M.watcher ~= nil then
    return
  end

  M.watcher = hs.distributednotifications.new(function()
    local dark = M.system_preference()
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
