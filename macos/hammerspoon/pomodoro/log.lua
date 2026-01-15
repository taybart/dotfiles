local levels = {
  error = 0,
  warn = 1,
  info = 2,
  debug = 3,
}

local log = {
  -- level = levels.debug,
  level = levels.info,
}

function log:debug(fmt, ...)
  if self.level >= levels.debug then print('[DEBUG] ' .. fmt:format(...)) end
end

function log:info(fmt, ...)
  if self.level >= levels.info then print('[INFO] ' .. fmt:format(...)) end
end

function log:warn(fmt, ...)
  if self.level >= levels.warn then print('[WARN] ' .. fmt:format(...)) end
end

function log:error(fmt, ...)
  if self.level >= levels.error then print('[ERROR] ' .. fmt:format(...)) end
end

return log
