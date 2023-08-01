--[[
  original: https://github.com/af/dotfiles/blob/main/hammerspoon/pomodoro.lua
  I updated some things and fixed some issues
]]
local menu = hs.menubar.new()
local timer = nil
local currentPomo = nil
local alertId = nil

local INTERVAL_SECONDS = 60 -- Set to 60 (one minute) for real use; set lower for debugging
local POMO_LENGTH = 25 -- Number of intervals (minutes) in one work pomodoro
-- POMO_LENGTH = 1 -- Number of intervals (minutes) in one work pomodoro
local BREAK_LENGTH = 5 -- Number of intervals (minutes) in one break time
local LOG_FILE = '~/.pomo'

-- Namespace tables
local commands = {}
local log = {}
local app = {}

-- (ab)use hs.chooser as a text input with the possibility of using other options
local showChooserPrompt = function(items, callback)
  local chooser = nil
  chooser = hs.chooser.new(function(item)
    if item then
      callback(item.text)
    end
    if chooser then
      chooser:delete()
    end
  end)

  -- The table of choices to present to the user. It's comprised of one empty
  -- item (which we update as the user types), and those passed in as items
  local choiceList = { { text = '' } }
  for i = 1, #items do
    choiceList[#choiceList + 1] = items[i]
  end

  chooser:choices(function()
    choiceList[1]['text'] = chooser:query()
    return choiceList
  end)

  -- Re-compute the choices every time a key is pressed, to ensure that the top
  -- choice is always the entered text:
  chooser:queryChangedCallback(function()
    chooser:refreshChoicesCallback()
  end)

  chooser:show()
end

-- Read the last {count} lines of the log file, ordered with the most recent one first
log.read = function(count)
  if not count then
    count = 10
  end
  return hs.execute('tail -' .. count .. ' ' .. LOG_FILE .. ' | sort -r ${inputfile}')
end

log.writeItem = function(pomo)
  local timestamp = os.date('%Y-%m-%d %H:%M')
  local isFirstToday = #(log.getCompletedToday()) == 0

  if isFirstToday then
    hs.execute('echo "" >> ' .. LOG_FILE)
  end -- Add linebreak between days
  hs.execute('echo "[' .. timestamp .. '] ' .. pomo.name .. '" >> ' .. LOG_FILE)
end

log.getLatestItems = function(count)
  local logs = log.read(count)
  local logItems = {}
  for match in logs:gmatch('(.-)\r?\n') do
    table.insert(logItems, match)
  end
  return logItems
end

log.getCompletedToday = function()
  local logItems = log.getLatestItems(20)
  local timestamp = os.date('%Y-%m-%d')
  local todayItems = hs.fnutils.filter(logItems, function(s)
    return string.find(s, timestamp, 1, true) ~= nil
  end)
  return todayItems
end

-- Return a table of recent tasks ({text, subText}), most recent first
log.getRecentTaskNames = function()
  local tasks = log.getLatestItems(12)
  local nonEmptyTasks = hs.fnutils.filter(tasks, function(t)
    return t ~= ''
  end)
  local names = hs.fnutils.map(nonEmptyTasks, function(taskWithTimestamp)
    local timeStampEnd = string.find(taskWithTimestamp, ']')
    return {
      text = string.sub(taskWithTimestamp, timeStampEnd + 2),
      subText = string.sub(taskWithTimestamp, 2, timeStampEnd - 1), -- slice braces off
    }
  end)

  -- dedupe
  local res, hash = {}, {}
  for _, v in ipairs(names) do
    if not hash[v.text] then
      res[#res + 1] = v
      hash[v.text] = true
    end
  end
  return res
end

commands.startNew = function()
  local options = log.getRecentTaskNames()
  showChooserPrompt(options, function(taskName)
    if taskName then
      currentPomo = { minutesLeft = POMO_LENGTH, name = taskName }
      if timer then
        timer:stop()
      end
      timer = hs.timer.doEvery(INTERVAL_SECONDS, app.timerCallback)
    end
    app.updateUI()
  end)
end

commands.togglePaused = function()
  if not currentPomo then
    return
  end
  currentPomo.paused = not currentPomo.paused
  app.updateUI()
end

commands.stop = function()
  currentPomo = nil
  app.updateUI()
end

commands.toggleLatestDisplay = function()
  local logs = log.read(30)
  if alertId then
    hs.alert.closeSpecific(alertId)
    alertId = nil
  else
    local msg = 'LATEST ACTIVITY\n\n' .. logs
    if currentPomo then
      msg = 'NOW: ' .. currentPomo.name .. '\n==========\n\n' .. msg
    end
    alertId = hs.alert(msg, { textSize = 17, textFont = 'Courier' }, 'indefinite')
  end
end

app.timerCallback = function()
  if not currentPomo then
    return
  end
  if currentPomo.paused then
    return
  end
  currentPomo.minutesLeft = currentPomo.minutesLeft - 1
  if currentPomo.minutesLeft <= 0 then
    app.completePomo(currentPomo)
  end
  app.updateUI()
end

app.completePomo = function(pomo)
  local n = hs.notify.new({
    title = 'Pomodoro complete',
    subTitle = pomo.name,
    informativeText = 'Completed at ' .. os.date('%H:%M'),
    soundName = 'Hero',
  })
  n:autoWithdraw(false)
  n:hasActionButton(false)
  n:send()

  log.writeItem(pomo)
  currentPomo = nil

  if timer then
    timer:stop()
  end
  timer = hs.timer.doAfter(INTERVAL_SECONDS * BREAK_LENGTH, function()
    local n2 = hs.notify.new({
      title = 'Get back to work',
      subTitle = 'Break time is over',
      informativeText = 'Sent at ' .. os.date('%H:%M'),
      soundName = 'Hero',
    })
    n2:autoWithdraw(false)
    n2:hasActionButton(false)
    n2:send()
  end)
end

app.getMenubarTitle = function(pomo)
  local title = '🍅'
  if pomo then
    title = title .. ('0:' .. string.format('%02d', pomo.minutesLeft))
    if pomo.paused then
      title = title .. ' (paused)'
    end
  end
  return title
end

app.updateUI = function()
  menu:setTitle(app.getMenubarTitle(currentPomo))
end

app.init = function()
  menu:setMenu(function()
    local completedCount = #(log.getCompletedToday())

    local pausePlay = { title = 'Start', fn = commands.startNew }
    local stop = nil
    if currentPomo then
      pausePlay = { title = 'Pause', fn = commands.togglePaused }
      if currentPomo.paused then
        pausePlay.title = 'Resume'
      end
      stop = { title = 'Stop', fn = commands.stop }
    end
    return {
      { title = completedCount .. ' pomos completed today', disabled = true },
      pausePlay,
      stop,
    }
  end)

  app.updateUI()
end

app.init()

return commands
