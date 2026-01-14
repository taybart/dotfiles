--[[
  originally taken from -> https://github.com/af/dotfiles/blob/2e096c5cdf99c8e8f57a9d841e46e7d07885b76e/hammerspoon/pomodoro.lua
]]

local log = require('pomodoro/log')
local chooser = require('pomodoro/chooser')

local state = require('pomodoro/state').init()
local menu = assert(hs.menubar.new()):autosaveName('pomodoro_timer')

local function complete_pomo()
  print('🍅 Pomodoro complete, starting break...')

  -- Add error handling for log.write
  local success, err = pcall(log.write, state.pomo)
  if not success then print('ERROR: log.write failed:', err) end

  -- Add error handling for notification
  local notify_success, notify_err = pcall(
    function()
      assert(hs.notify.new({
        title = 'Pomodoro complete!',
        subTitle = state.pomo.name,
        informativeText = 'Time for a break 🌴 ' .. os.date('%H:%M'),
        soundName = 'Blow',
        autoWithdraw = false,
        hasActionButton = false,
      })):send()
    end
  )

  if not notify_success then print('ERROR: notification failed:', notify_err) end

  -- Add error handling for break_time transition
  local break_success, break_err = pcall(function() state:break_time() end)
  if not break_success then
    print('ERROR: break_time transition failed:', break_err)
  else
    print('DEBUG: complete_pomo() finished, break_time should be saved')
  end
end

local function complete_break()
  local break_success, break_err = pcall(
    function()
      assert(hs.notify.new({
        title = 'Break over',
        subTitle = 'Time to get back to work',
        informativeText = os.date('%H:%M'),
        soundName = 'Blow',
        autoWithdraw = false,
        hasActionButton = false,
      })):send()
    end
  )

  if not break_success then print('ERROR: break notification failed:', break_err) end

  state:done()
end

local function update_ui()
  local title = '🍅︎'
  if state.pomo.running then
    title = ('%s (%02d) ⏵'):format(state.pomo.name, state.pomo.time)
    if state.pomo.paused then title = ('%s (%02d) ⏸'):format(state.pomo.name, state.pomo.time) end
  elseif state.take_break.running then
    title = ('🌴 %02d'):format(state.take_break.time)
    if state.take_break.paused then title = ('🌴 %02d ⏸'):format(state.take_break.time) end
  end
  menu:setTitle(title)
end

local function tick()
  print(
    ('DEBUG(tick): running=%s, break.running=%s, pomo.time=%d, break.time=%d'):format(
      tostring(state.pomo.running),
      tostring(state.take_break.running),
      state.pomo.time,
      state.take_break.time
    )
  )

  if state.pomo.running then
    if state.pomo.paused then
      print('DEBUG: pomo is paused, checking if transition needed')
      -- If timer is paused at 0, we should still transition when unpaused
      if state.pomo.time <= 0 then
        print('DEBUG: pomo paused at time 0, will transition when unpaused')
        -- Don't transition while paused, but show appropriate UI
        update_ui()
        return
      end
      -- Still update UI to show paused state, but don't decrement time
      update_ui()
      return
    end
    state.pomo.time = state.pomo.time - 1
    print('DEBUG: pomo time decremented to ' .. state.pomo.time)
    if state.pomo.time <= 0 then
      print('DEBUG: pomo time <= 0, calling complete_pomo()')
      complete_pomo()
    end
    update_ui()
    return
  end

  if state.take_break.running then
    if state.take_break.paused then
      print('DEBUG: break is paused, skipping')
      update_ui()
      return
    end
    state.take_break.time = state.take_break.time - 1
    print('DEBUG: break time decremented to ' .. state.take_break.time)

    -- Save break state immediately to ensure it's synced
    state:save()

    if state.take_break.time <= 0 then
      print('DEBUG: break time <= 0, calling complete_break()')
      complete_break()
    end
    update_ui()
    return
  end

  print('DEBUG: Neither pomo nor break is running - timer should stop')
end

local function new()
  local options = log.get_recent_task_names()
  chooser.show(options, function(task_name)
    if task_name then state:start(task_name, tick) end
    update_ui()
  end)
end

local function toggle_paused()
  if state.pomo.running then
    local was_paused = state.pomo.paused
    state:toggle_paused()

    -- If we just unpaused and time is 0, transition to break
    if was_paused and not state.pomo.paused and state.pomo.time <= 0 then
      print('DEBUG: unpaused at time 0, transitioning to break')
      complete_pomo()
    end
  elseif state.take_break.running then
    state.take_break.paused = not state.take_break.paused
  end
  state:save()
  update_ui()
end

local function stop()
  state:stop()
  update_ui()
end

local function complete()
  print('DEBUG: manual complete() called')
  -- If completing a paused pomodoro at time 0, treat it as normal completion
  if state.pomo.running and state.pomo.paused and state.pomo.time <= 0 then
    print('DEBUG: manual complete of paused pomodoro at time 0, calling complete_pomo()')
    complete_pomo()
  else
    state:stop()
  end
  update_ui()
end

local function menu_items()
  local items = {
    { title = 'new', fn = new },
  }
  if state.pomo.running or state.take_break.running then
    items[1] = { title = 'pause      ⏸', fn = toggle_paused }
    if state.pomo.paused then items[1].title = 'start        ⏵' end
    items[2] = { title = 'stop         ⏹', fn = stop }
    items[3] = { title = 'complete ✓', fn = complete }
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
