--[[
  taken from -> https://github.com/af/dotfiles/blob/2e096c5cdf99c8e8f57a9d841e46e7d07885b76e/hammerspoon/pomodoro.lua
]]

local config = require('pomodoro/config')
local log = require('pomodoro/log')
local chooser = require('pomodoro/chooser')

local alertId = nil

-- TODO: add file for sync across reloads

-- @class self
-- @field has_pomo boolean
-- @field has_break boolean
-- @field pomo self.pomo
-- @field take_break self.take_break
-- @field timer hs.timer

-- @class self.pomo
-- @field name string
-- @field paused boolean
-- @field minutes_left number

-- @class self.take_break
-- @field minutes_left number

local app = {
  has_pomo = false,
  has_break = false,
  pomo = { on = false, name = '', paused = false, minutes_left = 0 },
  take_break = { on = false, minutes_left = 0 },
  timer = nil,
}

local menu = hs.menubar.new()

function app:timer_callback()
  if self.has_pomo then
    if self.pomo.paused then
      return
    end
    self.pomo.minutes_left = self.pomo.minutes_left - 1
    if self.pomo.minutes_left <= 0 then
      app:complete_pomo()
    end
    app:update_ui()
    return
  end

  if self.has_break then
    self.take_break.minutes_left = self.take_break.minutes_left - 1
    if self.take_break.minutes_left <= 0 then
      app:complete_break()
    end
    app:update_ui()
    return
  end
end

function app:complete_pomo()
  log.write_item(self.pomo)

  hs.notify.show({
    title = 'Pomodoro complete',
    subTitle = self.pomo.name,
    informativeText = 'Completed at ' .. os.date('%H:%M'),
    soundName = 'Hero',
    autoWithdraw = false,
    hasActionButton = false,
  })

  self.has_pomo = false
  self.pomo = { name = '', paused = false, minutes_left = 0 }

  self.has_break = true
  self.take_break = { minutes_left = config.BREAK_LENGTH }
end

function app:complete_break()
  if self.timer then
    self.timer:stop()
  end

  hs.notify.show({
    title = 'Get back to work',
    subTitle = 'Break time is over',
    informativeText = 'Sent at ' .. os.date('%H:%M'),
    soundName = 'Hero',
    autoWithdraw = false,
    hasActionButton = false,
  })

  self.has_break = false
  self.take_break = { minutes_left = 0 }
end

function app:menubar_title()
  local title = '🍅︎'
  if self.has_pomo then
    title = title .. string.format(' %02d', self.pomo.minutes_left)
    if self.pomo.paused then
      title = title .. ' (paused)'
    end
  elseif self.has_break then
    title = title .. (' b' .. string.format('%02d', self.take_break.minutes_left))
  end
  return title
end

function app:update_ui()
  if not menu then
    return
  end
  menu:setTitle(self:menubar_title())
end

function app:start_new()
  local options = log.get_recent_task_names()
  chooser.show_prompt(options, function(task_name)
    if task_name then
      self.pomo = { minutes_left = config.POMO_LENGTH, name = task_name }
      self.has_pomo = true
      if self.timer then
        self.timer:stop()
      end
      self.timer = hs.timer.doEvery(config.INTERVAL_SECONDS, function()
        self:timer_callback()
      end)
      self:update_ui()
    end
  end)
end

function app:toggle_paused()
  if not self.has_pomo then
    return
  end
  self.pomo.paused = not self.pomo.paused
  self:update_ui()
end

function app:stop()
  self.current_pomo = nil
  self:update_ui()
end

function app:toggle_latest_display()
  local logs = log.read(30)
  if alertId then
    hs.alert.closeSpecific(alertId)
    alertId = nil
  else
    local msg = 'LATEST ACTIVITY\n\n' .. logs
    if self.has_pomo then
      msg = 'NOW: ' .. self.app.pomo.name .. '\n==========\n\n' .. msg
    end
    alertId = hs.alert(msg, { textSize = 17, textFont = 'Courier' }, 'indefinite')
  end
end

function app:init()
  if not menu then
    return
  end
  menu:setMenu(function()
    local completed_count = #(log.get_completed_today())

    local pause_play = {
      title = 'Start',
      fn = function()
        self:start_new()
      end,
    }
    local stop = nil
    if self.has_pomo then
      pause_play = {
        title = 'Pause',
        fn = function()
          self:toggle_paused()
        end,
      }
      if self.pomo.paused then
        pause_play.title = 'Resume'
      end
      stop = {
        title = 'Stop',
        fn = function()
          self:stop()
        end,
      }
    end
    return {
      { title = completed_count .. ' pomos completed today', disabled = true },
      pause_play,
      stop,
    }
  end)

  self:update_ui()
end

app:init()
return app
