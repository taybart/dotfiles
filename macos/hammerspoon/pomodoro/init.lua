--[[
  taken from -> https://github.com/af/dotfiles/blob/2e096c5cdf99c8e8f57a9d841e46e7d07885b76e/hammerspoon/pomodoro.lua
]]

-- require('pomodoro/db').setup_tables()
local log = require('pomodoro/log')
local chooser = require('pomodoro/chooser')

local state = require('pomodoro/state').init()
local menu = assert(hs.menubar.new()):autosaveName('pomodoro_timer')

local function complete_pomo()
  log.write(state.pomo)

  assert(hs.notify.new({
    title = 'Pomodoro complete',
    subTitle = state.pomo.name,
    informativeText = 'Completed at ' .. os.date('%H:%M'),
    soundName = 'Blow',
    autoWithdraw = false,
    hasActionButton = false,
  })):send()

  state:break_time()
end

local function complete_break()
  assert(hs.notify.new({
    title = 'Get back to work',
    subTitle = 'Break time is over',
    informativeText = 'Sent at ' .. os.date('%H:%M'),
    soundName = 'Blow',
    autoWithdraw = false,
    hasActionButton = false,
  })):send()

  state:done()
end

local function update_ui()
  local title = '🍅︎'
  if state.pomo.running then
    title = ('%s (%02d) ⏵'):format(state.pomo.name, state.pomo.time)
    if state.pomo.paused then
      title = ('%s (%02d) ⏸'):format(state.pomo.name, state.pomo.time)
    end
  elseif state.take_break.running then
    title = ('🌴 %02d'):format(state.take_break.time)
    if state.take_break.paused then
      title = ('🌴 %02d ⏸'):format(state.pomo.time)
    end
  end
  menu:setTitle(title)
end

local function tick()
  if state.pomo.running then
    if state.pomo.paused then
      return
    end
    state.pomo.time = state.pomo.time - 1
    if state.pomo.time <= 0 then
      complete_pomo()
    end
    update_ui()
    return
  end

  if state.take_break.running then
    state.take_break.time = state.take_break.time - 1
    if state.take_break.time <= 0 then
      complete_break()
    end
    update_ui()
    return
  end
end

local function new()
  local options = log.get_recent_task_names()
  chooser.show(options, function(task_name)
    if task_name then
      state:start(task_name, tick)
    end
    update_ui()
  end)
end

local function toggle_paused()
  state:toggle_paused()
  state:save()
  update_ui()
end

local function stop()
  state:stop()
  update_ui()
end

local function menu_items()
  local items = {
    { title = 'New', fn = new },
  }
  if state.pomo.running or state.take_break.running then
    items[1] = { title = 'pause ⏸', fn = toggle_paused }
    if state.pomo.paused then
      items[1].title = 'start ⏵'
    end
    items[2] = { title = 'stop ⏹', fn = stop }
  end
  return items
end

local function init()
  state.init()
  if state.can_recover then
    local ms = hs.screen.mainScreen():frame()
    hs.dialog.alert(
      ms.w * 0.5,
      ms.h * 0.25,
      function(result)
        if result == 'Yes' then
          state:recover(tick)
          update_ui()
        end
      end,
      'Pomodoro in progress',
      ('Would you like to resume %s?'):format(state.last.pomo.name),
      'Yes',
      'No'
    )
  end
  menu:setMenu(menu_items)

  update_ui()
end

init()
