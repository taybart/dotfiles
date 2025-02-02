local dev = {
  INTERVAL_SECONDS = 1,
  POMO_LENGTH = 30,
  BREAK_LENGTH = 15,
}

local prod = {
  INTERVAL_SECONDS = 60, -- Set to 60 (one minute) for real use; set lower for debugging
  POMO_LENGTH = 45, -- Number of intervals (minutes) in one work pomodoro
  BREAK_LENGTH = 20, -- Number of intervals (minutes) in one break time
}

-- return dev
return prod
