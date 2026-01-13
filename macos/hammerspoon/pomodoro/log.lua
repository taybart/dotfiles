local log = {
  contents = {},
}

-- Read the last {count} lines of the log file, ordered with the most recent one first
log.read = function(count)
  if not count then count = 10 end
  return hs.execute('tail -' .. count .. ' ' .. log._file_path .. ' | sort -r ${inputfile}')
end

log.write = function(pomo)
  local timestamp = os.date('%Y-%m-%d %H:%M')
  local is_first_today = #(log.get_completed_today()) == 0

  if is_first_today then
    -- TODO: fix external commands
    hs.execute('echo "" >> ' .. log._file_path)
  end -- Add linebreak between days
  hs.execute('echo "[' .. timestamp .. '] ' .. pomo.name .. '" >> ' .. log._file_path)
end

log.get_latest_items = function(count)
  local logs = log.read(count)
  if not logs then return end
  local logItems = {}
  for match in logs:gmatch('(.-)\r?\n') do
    table.insert(logItems, match)
  end
  return logItems
end

log.get_completed_today = function()
  local log_items = log.get_latest_items(20)
  local timestamp = os.date('%Y-%m-%d')
  local today_items = hs.fnutils.filter(log_items, function(s)
    if type(timestamp) == 'string' then -- get rid of warning
      return string.find(s, timestamp, 1, true) ~= nil
    end
  end)
  return today_items
end

-- Return a table of recent tasks ({text, subText}), most recent first
log.get_recent_task_names = function()
  local db = require('pomodoro/db')
  local pomos = db:get_latest_pomos(12)

  local names = hs.fnutils.map(
    pomos,
    function(pomo)
      return {
        text = pomo.name,
        subText = pomo.created_at,
      }
    end
  )

  if not names then return end

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

return log
