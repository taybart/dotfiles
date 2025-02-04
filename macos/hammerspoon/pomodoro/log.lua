local log = {
  _file_path = os.getenv('HOME') .. '/.pomo',
  contents = {},
}

-- Read the last {count} lines of the log file, ordered with the most recent one first
log.read = function(count)
  if not count then
    count = 10
  end
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
  if not logs then
    return
  end
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
  local tasks = log.get_latest_items(12)
  local non_empty_tasks = hs.fnutils.filter(tasks, function(t)
    return t ~= ''
  end)
  local names = hs.fnutils.map(non_empty_tasks, function(task_with_timestamp)
    local timestamp_end = string.find(task_with_timestamp, ']')
    return {
      text = string.sub(task_with_timestamp, timestamp_end + 2),
      subText = string.sub(task_with_timestamp, 2, timestamp_end - 1), -- slice braces off
    }
  end)

  if not names then
    return
  end

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
